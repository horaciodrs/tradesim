public class TradeSim.Services.Database : GLib.Object {

    private Sqlite.Database db; 
    private string db_path;

    /*DEPENDENCIA: sudo apt install libsqlite3-dev  */ 

    public Database (bool skip_tables = false) {
        int rc = 0;
        db_path = Environment.get_home_dir () + "/.local/share/com.github.horaciodrs.tradesim/database.db";

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

            "price_open     REAL    NOT NULL," +
            "price_close    REAL    NOT NULL," +
            "price_max      REAL    NOT NULL," +
            "price_min      REAL    NOT NULL)", null, null);
        debug ("Table tickers created");

        rc = db.exec ("PRAGMA foreign_keys = ON;");

        insert_provider("EODATA", "EODATA");
        insert_provider("HistData.com", "HISTDATA");
        insert_provider("Tradingview.com", "TVIEW");

        int id_forex = insert_market("Forex", "");

        insert_ticker("EURUSD", id_forex);
        insert_ticker("USDJPY", id_forex);
        insert_ticker("GBPUSD", id_forex);

        return rc;
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

        return get_id_if_market_exists(_name);

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

    /*public bool music_file_exists (string uri) {
        bool file_exists = false;
        Sqlite.Statement stmt;

        int res = db.prepare_v2 ("SELECT COUNT (*) FROM tracks WHERE path = ?", -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, uri);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            file_exists = stmt.column_int (0) > 0;
        }

        return file_exists;
    }

    public bool music_blacklist_exists (string uri) {
        bool file_exists = false;
        Sqlite.Statement stmt;

        int res = db.prepare_v2 ("SELECT COUNT (*) FROM blacklist WHERE path = ?", -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, uri);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            file_exists = stmt.column_int (0) > 0;
        }

        return file_exists;
    }

    public bool radio_exists (string url) {
        bool exists = false;
        Sqlite.Statement stmt;

        int res = db.prepare_v2 ("SELECT COUNT (*) FROM radios WHERE url = ?", -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, url);
        assert (res == Sqlite.OK);

        if (stmt.step () == Sqlite.ROW) {
            exists = stmt.column_int (0) > 0;
        }

        return exists;
    }*/

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

    /*


    public void insert_quote (TradeSim.Services.QuoteItem quote_item) {
        Sqlite.Statement stmt;
        string sql;
        int res;

        sql = """ INSERT OR IGNORE INTO quotes (provider_id, market_id, ticker_id, time_frame_id, date_year
                                              , date_month, date_day, date_hour, date_minute , price_open
                                              , price_close, price_max, price_min) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);  """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (1, quote_item.provider_id);
        assert (res == Sqlite.OK);
        
        res = stmt.bind_int (2, quote_item.market_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (3, quote_item.ticker_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (4, quote_item.time_frame_id);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (5, quote_item.date_year);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (6, quote_item.date_month);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (7, quote_item.date_day);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (8, quote_item.date_hour);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (9, quote_item.date_minute);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (10, quote_item.price_open);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (11, quote_item.price_close);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (12, quote_item.price_max);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (13, quote_item.price_min);
        assert (res == Sqlite.OK);


        if (stmt.step () != Sqlite.DONE) {
            warning ("Error: %d: %s", db.errcode (), db.errmsg ());
        }

        stmt.reset ();

    }
    */

    /*

    public Objects.Track? get_track_by_path (string path) {
        Sqlite.Statement stmt;
        int res;

        string sql = """
            SELECT tracks.id, tracks.path, tracks.title, tracks.duration, tracks.is_favorite, tracks.track, tracks.date_added, 
            tracks.play_count, tracks.album_id, albums.title, artists.id, artists.name, tracks.favorite_added, tracks.last_played FROM tracks 
            INNER JOIN albums ON tracks.album_id = albums.id
            INNER JOIN artists ON albums.artist_id = artists.id WHERE tracks.path = ?;
        """;

        res = db.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (1, path);
        assert (res == Sqlite.OK);

        var track = new Objects.Track ();

        if (stmt.step () == Sqlite.ROW) {
            track.id = stmt.column_int (0);
            track.path = stmt.column_text (1);
            track.title = stmt.column_text (2);
            track.duration = stmt.column_int64 (3);
            track.is_favorite = stmt.column_int (4);
            track.track = stmt.column_int (5);
            track.date_added = stmt.column_text (6);
            track.play_count = stmt.column_int (7);
            track.album_id = stmt.column_int (8);
            track.album_title = stmt.column_text (9);
            track.artist_id = stmt.column_int (10);
            track.artist_name = stmt.column_text (11);
            track.favorite_added = stmt.column_text (12);
            track.last_played = stmt.column_text (13);
        }

        return track;
    }
*/

}
