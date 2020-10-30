/*
 * Copyright (c) 2020-2020 horaciodrs (https://github.com/horaciodrs/TradeSim)
 *
 * This file is part of TradeSim.
 *
 * TradeSim is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * TradeSim is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with Akira. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Horacio Daniel Ros <horaciodrs@gmail.com>
 */

public class TradeSim.Services.Database : GLib.Object {

    private Sqlite.Database db;
    private string db_path;
    private string db_path_folder;

    public bool import_is_working;
    public int import_total_lines;
    public int imported_lines;

    /*DEPENDENCIA: sudo apt install libsqlite3-dev  */

    public Database (bool skip_tables = false) {

        init (skip_tables);

    }

    public void reset () {

        try{

            GLib.File db_file = GLib.File.new_for_path (db_path);

            db_file.delete ();

            init ();

        }catch (Error e){
            print("Error: %s\n", e.message);
            return;
        }

    }

    public void export (string to_path) {

        try{
            
            GLib.File source_file = GLib.File.new_for_path (db_path);
            GLib.File dest_file = GLib.File.new_for_path (to_path);

            source_file.copy (dest_file, GLib.FileCopyFlags.OVERWRITE, null, null);

        }catch(Error e){
            print("Error: %s\n", e.message);
            return;
        }

    }


    public void import (string from_path) {

        try{
            
            GLib.File source_file = GLib.File.new_for_path (from_path);
            GLib.File dest_file = GLib.File.new_for_path (db_path_folder + "/database.db");

            source_file.copy (dest_file, GLib.FileCopyFlags.OVERWRITE, null, null);


        }catch(Error e){
            print("Error: %s\n", e.message);
            return;
        }

    }

    private void init (bool skip_tables = false) {
        
        int rc = 0;
        db_path_folder = Environment.get_home_dir () + "/.local/share/com.github.horaciodrs.tradesim";
        db_path = db_path_folder + "/database.db";

        if (!skip_tables) {
            if (create_tables () != Sqlite.OK) {
                stderr.printf ("Error creating db table: %d, %s\n", rc, db.errmsg ());
                Gtk.main_quit ();
            }
        }

        rc = Sqlite.Database.open (db_path, out db);

        if (rc != Sqlite.OK) {
            stderr.printf ("Can't open database: %d, %s\n", rc, db.errmsg ());
            Gtk.main_quit ();
        }

    }

    public void start_import_quotes (int quotes) {

        import_total_lines = quotes;
        imported_lines = 0;
        import_is_working = true;

    }

    public void end_import_quotes () {

        import_is_working = false;

    }

    private int create_tables () {
        int rc;

        rc = Sqlite.Database.open (db_path, out db);

        if (rc != Sqlite.OK) {
            stderr.printf ("Can't open database: %d, %s\n", rc, db.errmsg ());
            Gtk.main_quit ();
        }

        rc = db.exec ("CREATE TABLE IF NOT EXISTS providers (" +
                      "id             INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "name           TEXT    NOT NULL," +
                      "folder_name    TEXT    NOT NULL," +
                      "CONSTRAINT unique_provider UNIQUE (name))", null, null);
        debug ("Table provider created");

        rc = db.exec ("CREATE TABLE IF NOT EXISTS markets (" +
                      "id             INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "name           TEXT    NOT NULL," +
                      "folder_name    TEXT    NOT NULL," +
                      "CONSTRAINT unique_market UNIQUE (name))", null, null);
        debug ("Table market created");

        rc = db.exec ("CREATE TABLE IF NOT EXISTS tickers (" +
                      "id             INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "name           TEXT    NOT NULL," +
                      "market_id      INT     NOT NULL," +
                      "CONSTRAINT unique_ticker UNIQUE (name)," +
                      "FOREIGN KEY (market_id) REFERENCES markets (id) ON DELETE CASCADE)", null, null);
        debug ("Table tickers created");

        rc = db.exec ("CREATE TABLE IF NOT EXISTS time_frames (" +
                      "id             INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "name           TEXT    NOT NULL," +
                      "CONSTRAINT unique_time_frame UNIQUE (name))", null, null);
        debug ("Table tickers created");

        rc = db.exec ("CREATE TABLE IF NOT EXISTS imported_data (" +
                      "id             INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "provider_id    INT     NOT NULL," +
                      "market_id      INT     NOT NULL," +
                      "ticker_id      INT     NOT NULL," +
                      "time_frame_id  INT     NOT NULL," +
                      "q_year         INT     NOT NULL," +
                      "q_month        INT     NOT NULL," +
                      "CONSTRAINT unique_market UNIQUE (provider_id, market_id, ticker_id, time_frame_id, q_year, q_month))", null, null);
        debug ("Table imported_data created");

        rc = db.exec ("CREATE TABLE IF NOT EXISTS quotes (" +
                      "id             INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "provider_id    INT     NOT NULL," +
                      "market_id      INT     NOT NULL," +
                      "ticker_id      INT     NOT NULL," +
                      "time_frame_id  INT     NOT NULL," +

                      "date_year      INT     NOT NULL," +
                      "date_month     INT     NOT NULL," +
                      "date_day       INT     NOT NULL," +
                      "date_hour      INT     NOT NULL," +
                      "date_minute    INT     NOT NULL," +
                      "date_str       TEXT    NOT NULL," +

                      "price_open     REAL    NOT NULL," +
                      "price_close    REAL    NOT NULL," +
                      "price_max      REAL    NOT NULL," +
                      "price_min      REAL    NOT NULL)", null, null);
        debug ("Table tickers created");

        rc = db.exec ("PRAGMA foreign_keys = ON;");

        insert_provider ("TRADESIM", "TRADESIM");

        int id_forex = insert_market ("Forex", "");

        insert_ticker ("EURUSD", id_forex);
        // insert_ticker ("USDJPY", id_forex);
        insert_ticker ("GBPUSD", id_forex);
        // insert_ticker ("USDCHF", id_forex);
        // insert_ticker ("USDCAD", id_forex);

        insert_time_frames ("D1");
        insert_time_frames ("H4");
        insert_time_frames ("H1");
        insert_time_frames ("M30");
        insert_time_frames ("M15");
        insert_time_frames ("M5");
        insert_time_frames ("M1");

        return rc;
    }

    public bool import_data_exists (string provider, string market, string ticker, string time_frame, int year, int month) {

        int provider_id = get_db_id_by_table_and_field ("providers", "folder_name", provider);
        int market_id = get_db_id_by_name ("markets", market);
        int ticker_id = get_db_id_by_name ("tickers", ticker);
        int time_frame_id = get_db_id_by_name ("time_frames", time_frame);

        bool file_exists = false;
        Sqlite.Statement stmt;

        // int res = db.prepare_v2 ("SELECT COUNT (*) FROM imported_data WHERE provider_id = ? AND market_id = ? AND ticker_id = ? AND time_frame_id = ? AND q_year = ? AND q_month = ?", -1, out stmt);
        int res = db.prepare_v2 ("SELECT COUNT (*) FROM imported_data WHERE provider_id = ? AND market_id = ? AND ticker_id = ? AND time_frame_id = ? AND q_year = ? AND q_month = ?", -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, time_frame_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, year);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, month);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            file_exists = stmt.column_int (0) > 0;
        }

        return file_exists;
    }

    public int get_db_id_by_name (string db_table, string _name) {

        return get_db_id_by_table_and_field (db_table, "name", _name);

    }

    public int get_db_id_by_table_and_field (string db_table, string db_field, string _name) {

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = "SELECT COUNT (*) FROM " + db_table + " WHERE " + db_field + " = ?;";

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, _name);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            if (stmt.column_int (0) > 0) {
                stmt.reset ();

                sql = "SELECT id FROM " + db_table + " WHERE " + db_field + " = ?;";

                res = db.prepare_v2 (sql, -1, out stmt);
                assert (res == Sqlite.OK);

                res = stmt.bind_text (1, _name);
                assert (res == Sqlite.OK);

                if (stmt.step () == Sqlite.ROW) {
                    return stmt.column_int (0);
                } else {
                    warning ("Error: %d: %s", db.errcode (), db.errmsg ());
                    return 0;
                }
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }

    public void add_imported_data (int provider_id, int market_id, int ticker_id, int time_frame_id, int year, int month) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ INSERT OR IGNORE INTO imported_data (provider_id, market_id, ticker_id, time_frame_id, q_year, q_month) VALUES (?, ?, ?, ?, ?, ?);  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, time_frame_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, year);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, month);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

    }

    public void delete_imported_data (string provider_name, string market_name, string ticker_name, string time_frame_name, int year, int month) {

        int provider_id = get_db_id_by_table_and_field ("providers", "folder_name", provider_name);
        int market_id = get_db_id_by_name ("markets", market_name);
        int ticker_id = get_db_id_by_name ("tickers", ticker_name);
        int time_frame_id = get_db_id_by_name ("time_frames", time_frame_name);

        Sqlite.Statement stmt;
        string sql;
        int res;


        sql = """ DELETE FROM quotes where provider_id = ? AND market_id = ? AND ticker_id = ? AND time_frame_id = ? AND date_year = ? AND date_month = ?;  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, time_frame_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, year);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, month);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

        // --------------------------

        sql = """ DELETE FROM imported_data where provider_id = ? AND market_id = ? AND ticker_id = ? AND time_frame_id = ? AND q_year = ? AND q_month = ?;  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, time_frame_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, year);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, month);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

    }

    public void insert_quote (TradeSim.Services.QuoteItem quote_item) {
        new Thread<void *> ("insert_quote", () => {

            // Without usleep it crashes on smb:// protocol
            int provider_id = get_db_id_by_table_and_field ("providers", "folder_name", quote_item.provider_folder_name);
            int market_id = get_db_id_by_name ("markets", "Forex");
            int ticker_id = get_db_id_by_name ("tickers", quote_item.ticker);
            int time_frame_id = get_db_id_by_name ("time_frames", quote_item.time_frame_name);


            int date_year = quote_item.date_time.get_year ();
            int date_month = quote_item.date_time.get_month ();
            int date_day = quote_item.date_time.get_day_of_month ();
            int date_hour = quote_item.date_time.get_hour ();
            int date_minute = quote_item.date_time.get_minute ();

            string aux_day = "00" + date_day.to_string ();
            string aux_month = "00" + date_month.to_string ();
            string aux_hour = "00" + date_hour.to_string ();
            string aux_minute = "00" + date_minute.to_string ();
            string date_str = date_year.to_string () + "-" + aux_month.substring (aux_month.length - 2, 2) + "-" + aux_day.substring (aux_day.length - 2, 2);

            date_str = date_str + " " + aux_hour.substring (aux_hour.length - 2, 2);
            date_str = date_str + ":" + aux_minute.substring (aux_minute.length - 2, 2);

            double price_open = quote_item.open_price;
            double price_close = quote_item.close_price;
            double price_max = quote_item.max_price;
            double price_min = quote_item.min_price;

            Sqlite.Statement stmt;
            string sql;
            int res;

            sql = """ INSERT OR IGNORE INTO quotes (
                    provider_id
                , market_id
                , ticker_id
                , time_frame_id
                , date_year
                , date_month
                , date_day
                , date_hour
                , date_minute
                , date_str
                , price_open
                , price_close
                , price_max
                , price_min
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);  """;

            res = db.prepare_v2 (sql, -1, out stmt);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (1, provider_id);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (2, market_id);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (3, ticker_id);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (4, time_frame_id);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (5, date_year);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (6, date_month);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (7, date_day);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (8, date_hour);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (9, date_minute);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (10, date_str);
            assert (res == Sqlite.OK);

            res = stmt.bind_double (11, price_open);
            assert (res == Sqlite.OK);

            res = stmt.bind_double (12, price_close);
            assert (res == Sqlite.OK);

            res = stmt.bind_double (13, price_max);
            assert (res == Sqlite.OK);

            res = stmt.bind_double (14, price_min);
            assert (res == Sqlite.OK);

            if (stmt.step () != Sqlite.DONE) {
                warning ("Error: %d: %s", db.errcode (), db.errmsg ());
            }

            stmt.reset ();

            add_imported_data (provider_id, market_id, ticker_id, time_frame_id, date_year, date_month);

            // Thread.usleep (1000000);

            imported_lines++;

            return null;

        });
    }

    public void insert_provider (string _name, string folder_name) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ INSERT OR IGNORE INTO providers (name, folder_name) VALUES (?, ?);  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, _name);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (2, folder_name);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

    }

    public void insert_time_frames (string _name) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ INSERT OR IGNORE INTO time_frames (name) VALUES (?);  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, _name);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

    }

    public void insert_ticker (string _name, int _market_id) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ INSERT OR IGNORE INTO tickers (name, market_id) VALUES (?, ?);  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, _name);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, _market_id);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

    }

    public int insert_market (string _name, string _folder_name) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ INSERT OR IGNORE INTO markets (name, folder_name) VALUES (?, ?);  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, _name);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (2, _folder_name);
        assert (res == Sqlite.OK);

        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

        return get_id_if_market_exists (_name);

    }

    public int get_id_if_market_exists (string _name) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """
            SELECT COUNT (*) FROM markets WHERE name = ?;
        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, _name);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            if (stmt.column_int (0) > 0) {
                stmt.reset ();

                sql = """
                    SELECT id FROM markets WHERE name = ?;
                """;

                res = db.prepare_v2 (sql, -1, out stmt);
                assert (res == Sqlite.OK);

                res = stmt.bind_text (1, _name);
                assert (res == Sqlite.OK);

                if (stmt.step () == Sqlite.ROW) {
                    return stmt.column_int (0);
                } else {
                    warning ("Error: %d: %s", db.errcode (), db.errmsg ());
                    return 0;
                }
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }

    public bool is_database_empty () {
        bool empty = false;
        Sqlite.Statement stmt;

        int res = db.prepare_v2 ("SELECT COUNT (*) FROM quotes", -1, out stmt);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            empty = stmt.column_int (0) <= 0;
        }

        return empty;
    }

    public Array<TradeSim.Objects.Provider> get_providers () {

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ SELECT id, name, folder_name FROM providers ORDER BY name DESC; """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        var all = new Array<TradeSim.Objects.Provider> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {
            all.append_val (new TradeSim.Objects.Provider (stmt.column_int (0), stmt.column_text (1), stmt.column_text (2)));
        }

        return all;
    }

    public Array<TradeSim.Objects.Provider> get_providers_with_data () {

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """
            SELECT providers.id, providers.name, providers.folder_name
              FROM imported_data
              INNER JOIN providers ON imported_data.provider_id = providers.id
              GROUP BY name
              ORDER BY name DESC; """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        var all = new Array<TradeSim.Objects.Provider> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {
            all.append_val (new TradeSim.Objects.Provider (stmt.column_int (0), stmt.column_text (1), stmt.column_text (2)));
        }

        return all;
    }

    public Array<string> get_time_frames_with_data (string provider_name) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", provider_name);

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """
            SELECT time_frames.id, time_frames.name
              FROM imported_data
              INNER JOIN providers ON imported_data.provider_id = providers.id
              INNER JOIN time_frames ON imported_data.time_frame_id = time_frames.id
             WHERE imported_data.provider_id = ?
              GROUP BY time_frames.name
              ORDER BY time_frames.name DESC; """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        var all = new Array<string> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {
            all.append_val (stmt.column_text (1));
        }

        return all;
    }

    public Array<string> get_tickers_with_data (string provider_name) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", provider_name);

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """
            SELECT tickers.id, tickers.name
              FROM imported_data
              INNER JOIN providers ON imported_data.provider_id = providers.id
              INNER JOIN tickers ON imported_data.ticker_id = tickers.id
             WHERE imported_data.provider_id = ?
              GROUP BY tickers.name
              ORDER BY tickers.name DESC; """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        var all = new Array<string> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {
            all.append_val (stmt.column_text (1));
        }

        return all;
    }

    public Array<TradeSim.Objects.Ticker> get_tickers () {

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ SELECT id, name FROM tickers ORDER BY name DESC; """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        var all = new Array<TradeSim.Objects.Ticker> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {
            all.append_val (new TradeSim.Objects.Ticker (stmt.column_int (0), stmt.column_text (1)));
        }

        return all;
    }

    public Array<TradeSim.Objects.ProviderTicker> get_providers_tickers (string provider_name) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", provider_name);

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ SELECT imported_data.ticker_id, tickers.name, imported_data.provider_id, providers.folder_name, providers.name
                    FROM imported_data
                    INNER JOIN providers ON imported_data.provider_id = providers.id
                    INNER JOIN tickers ON imported_data.ticker_id = tickers.id
                    WHERE imported_data.provider_id = ?
                    GROUP BY imported_data.provider_id, imported_data.ticker_id
                    ORDER BY imported_data.provider_id, imported_data.ticker_id;

        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        var all = new Array<TradeSim.Objects.ProviderTicker> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {
            all.append_val (new TradeSim.Objects.ProviderTicker (stmt.column_int (0), stmt.column_text (1), stmt.column_int (2), stmt.column_text (3), stmt.column_text (4)));
        }

        return all;
    }

    public Array<TradeSim.Services.QuoteItem> get_quotes_to_canvas (string _provider_name, string _ticker_name, string _time_frame, DateTime _date_from, DateTime _date_to) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", _provider_name);
        int market_id = get_db_id_by_name ("markets", "Forex");
        int ticker_id = get_db_id_by_name ("tickers", _ticker_name);
        int time_frame_id = get_db_id_by_name ("time_frames", _time_frame);

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ SELECT DATE(quotes.date_str)
                         provider_id
                        ,market_id
                        ,ticker_id
                        ,time_frame_id
                        ,date_year
                        ,date_month
                        ,date_day
                        ,date_hour
                        ,date_minute
                        ,date_str
                        ,price_open
                        ,price_close
                        ,price_max
                        ,price_min
                        ,providers.folder_name
                    FROM quotes
                   INNER JOIN providers ON quotes.provider_id = providers.id
                   WHERE DATETIME(quotes.date_str) >= DATETIME(?)
                     AND DATETIME(quotes.date_str) < DATETIME(?)
                     AND provider_id = ?
                     AND market_id = ?
                     AND ticker_id = ?
                     AND time_frame_id = ?
                    ORDER BY DATETIME(quotes.date_str) ASC
        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, get_datetime_to_db (_date_from));
        assert (res == Sqlite.OK);

        res = stmt.bind_text (2, get_datetime_to_db (_date_to));
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, time_frame_id);
        assert (res == Sqlite.OK);

        var all = new Array<TradeSim.Services.QuoteItem> ();

        while ((res = stmt.step ()) == Sqlite.ROW) {

            var quote_item = new TradeSim.Services.QuoteItem (_ticker_name);

            var date_year = stmt.column_int (4);
            var date_month = stmt.column_int (5);
            var date_day = stmt.column_int (6);
            var date_hour = stmt.column_int (7);
            var date_minute = stmt.column_int (8);
            var item_open = stmt.column_double (10);
            var item_close = stmt.column_double (11);
            var item_min = stmt.column_double (13);
            var item_max = stmt.column_double (12);
            var item_folder_name = stmt.column_text (14);

            DateTime item_date = new DateTime.local (date_year, date_month, date_day, date_hour, date_minute, 0);

            if (!is_valid_market_date (item_date)) {
                continue;
            }

            quote_item.set_provider_name (_provider_name);
            quote_item.set_provider_folder_name (item_folder_name);
            quote_item.set_time_frame_name (_time_frame);
            quote_item.set_date_time (item_date);
            quote_item.set_open_price (item_open);
            quote_item.set_close_price (item_close);
            quote_item.set_min_price (item_min);
            quote_item.set_max_price (item_max);

            all.append_val (quote_item);

        }

        return all;
    }

    public int get_available_quotes (string _provider_name, string _ticker_name, string _time_frame, DateTime _date) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", _provider_name);
        int market_id = get_db_id_by_name ("markets", "Forex");
        int ticker_id = get_db_id_by_name ("tickers", _ticker_name);
        int time_frame_id = get_db_id_by_name ("time_frames", _time_frame);

        int return_value = 0;

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """SELECT COUNT(*) as RecordCount
             FROM quotes
            WHERE DATETIME(date_str) >= DATETIME(?)
              AND provider_id = ?
              AND market_id = ?
              AND ticker_id = ?
              AND time_frame_id = ?
        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, get_datetime_to_db (_date));
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, time_frame_id);
        assert (res == Sqlite.OK);

        if ((res = stmt.step ()) == Sqlite.ROW) {
            return_value = stmt.column_int (0);
        }

        return return_value;

    }

    public DateTime get_min_date (string _provider_name, string _ticker_name, string _time_frame) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", _provider_name);
        int market_id = get_db_id_by_name ("markets", "Forex");
        int ticker_id = get_db_id_by_name ("tickers", _ticker_name);
        int time_frame_id = get_db_id_by_name ("time_frames", _time_frame);

        DateTime return_value = new DateTime.local (2010, 1, 1, 1, 1, 0);

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """SELECT quotes.date_year, quotes.date_month, quotes.date_day, quotes.date_hour, quotes.date_minute
             FROM quotes
            WHERE provider_id = ?
              AND market_id = ?
              AND ticker_id = ?
              AND time_frame_id = ?
        ORDER BY DATE(quotes.date_str) ASC, id ASC
        LIMIT 1;
        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, time_frame_id);
        assert (res == Sqlite.OK);

        if ((res = stmt.step ()) == Sqlite.ROW) {

            var date_year = stmt.column_int (0);
            var date_month = stmt.column_int (1);
            var date_day = stmt.column_int (2);
            var date_hour = stmt.column_int (3);
            var date_minute = stmt.column_int (4);

            return_value = new DateTime.local (date_year, date_month, date_day, date_hour, date_minute, 0);

        }

        return return_value;

    }

    /************************************************** */

    public TradeSim.Services.QuoteItem ? get_next_quotes (string _provider_name, string _ticker_name, string _time_frame, DateTime _date) {

        int provider_id = get_db_id_by_table_and_field ("providers", "name", _provider_name);
        int market_id = get_db_id_by_name ("markets", "Forex");
        int ticker_id = get_db_id_by_name ("tickers", _ticker_name);
        int time_frame_id = get_db_id_by_name ("time_frames", _time_frame);

        DateTime target_date = date_add_int_by_time_frame (_date, _time_frame, 1);

        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ SELECT DATE(quotes.date_str)
                         provider_id
                        ,market_id
                        ,ticker_id
                        ,time_frame_id
                        ,date_year
                        ,date_month
                        ,date_day
                        ,date_hour
                        ,date_minute
                        ,date_str
                        ,price_open
                        ,price_close
                        ,price_max
                        ,price_min
                        ,providers.folder_name
                    FROM quotes
                   INNER JOIN providers ON quotes.provider_id = providers.id
                   WHERE quotes.date_year = ?
                     AND quotes.date_month = ?
                     AND quotes.date_day = ?
                     AND quotes.date_hour = ?
                     AND quotes.date_minute = ?
                     AND provider_id = ?
                     AND market_id = ?
                     AND ticker_id = ?
                     AND time_frame_id = ?
                    LIMIT 1;
        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, target_date.get_year ());
        assert (res == Sqlite.OK);

        res = stmt.bind_int (2, target_date.get_month ());
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, target_date.get_day_of_month ());
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, target_date.get_hour ());
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, target_date.get_minute ());
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, provider_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (7, market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (8, ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (9, time_frame_id);
        assert (res == Sqlite.OK);

        if ((res = stmt.step ()) == Sqlite.ROW) {

            var quote_item = new TradeSim.Services.QuoteItem (_ticker_name);

            var date_year = stmt.column_int (4);
            var date_month = stmt.column_int (5);
            var date_day = stmt.column_int (6);
            var date_hour = stmt.column_int (7);
            var date_minute = stmt.column_int (8);
            var item_open = stmt.column_double (10);
            var item_close = stmt.column_double (11);
            var item_min = stmt.column_double (13);
            var item_max = stmt.column_double (12);
            var item_folder_name = stmt.column_text (14);

            DateTime item_date = new DateTime.local (date_year, date_month, date_day, date_hour, date_minute, 0);

            // print(">>>>La fecha de la quote es:" + item_date.to_string() + "\n");
            // print("DATE YEAAAAAAAAAAAAAAAAAAAAAAARRRRRRRRRRRRRR:" + target_date.get_year().to_string() +"\n\n\n\n");
            // print("DATE MONTHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH:" + target_date.get_month().to_string() +"\n\n\n\n");
            // print("DATE DAYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY:" + target_date.get_day_of_month().to_string() +"\n\n\n\n");
            // print("DATE HOURRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR:" + target_date.get_hour().to_string() +"\n\n\n\n");
            // print("DATE MINUTEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE:" + target_date.get_minute().to_string() +"\n\n\n\n");

            quote_item.set_provider_name (_provider_name);
            quote_item.set_provider_folder_name (item_folder_name);
            quote_item.set_time_frame_name (_time_frame);
            quote_item.set_date_time (item_date);
            quote_item.set_open_price (item_open);
            quote_item.set_close_price (item_close);
            quote_item.set_min_price (item_min);
            quote_item.set_max_price (item_max);

            return quote_item;

        } // else{
          // print("no hay quote.........................");
          // }

        return null;
    }

}
