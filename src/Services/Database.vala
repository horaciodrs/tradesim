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
        insert_ticker("USDCHF", id_forex);
        insert_ticker("USDCAD", id_forex);

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

}
