public class TradeSim.Dialogs.SettingsDialog : Gtk.Dialog {
    public weak TradeSim.MainWindow main_window { get; construct; }
    private Gtk.Stack stack;
    private Gtk.Switch dark_theme_switch;

    private Gtk.ScrolledWindow scroll_provider;
    private Gtk.ListStore list_store_provider;
    private Gtk.TreeIter add_iter_provider;
    private Gtk.TreeView tree_view_provider;

    private Gtk.ScrolledWindow scroll_ticker;
    private Gtk.ListStore list_store_ticker;
    private Gtk.TreeIter add_iter_ticker;
    private Gtk.TreeView tree_view_ticker;

    private Gtk.ScrolledWindow scroll_time_frame;
    private Gtk.ListStore list_store_time_frame;
    private Gtk.TreeIter add_iter_time_frame;
    private Gtk.TreeView tree_view_time_frame;

    private Gtk.ScrolledWindow scroll_year;
    private Gtk.ListStore list_store_year;
    private Gtk.TreeIter add_iter_year;
    private Gtk.TreeView tree_view_year;

    private Gtk.ScrolledWindow scroll_quotes;
    private Gtk.ListStore list_store_quotes;
    private Gtk.TreeIter add_iter_quotes;
    private Gtk.TreeView tree_view_quotes;

    private string ds_selected_provider;
    private string ds_selected_ticker;
    private string ds_selected_year;
    private string ds_selected_time_frame;

    public TradeSim.Services.QuotesManager qm;

    public SettingsDialog (TradeSim.MainWindow window) {
        Object (
            main_window: window,
            border_width: 6,
            deletable: true,
            resizable: true,
            modal: true,
            title: "Preferencias"
            );
    }

    construct {

        qm = new TradeSim.Services.QuotesManager ();

        ds_selected_provider = "";
        ds_selected_ticker = "";
        ds_selected_year = "";
        ds_selected_time_frame = "";

        transient_for = main_window;
        stack = new Gtk.Stack ();
        stack.margin = 6;
        stack.margin_bottom = 15;
        stack.margin_top = 15;
        stack.add_titled (get_interface_box (), "interface", "Interface");
        stack.add_titled (get_data_source_box (), "datasource", "Data Source");
        stack.add_titled (get_about_box (), "about", "About");
        stack.set_hexpand (true);
        stack.halign = Gtk.Align.FILL;

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);
        stack_switcher.halign = Gtk.Align.CENTER;


        var grid = new Gtk.Grid ();
        grid.halign = Gtk.Align.FILL;
        grid.attach (stack_switcher, 1, 1);
        grid.attach (stack, 1, 2);
        grid.set_hexpand (true);

        get_content_area ().add (grid);

    }

    private Gtk.Widget get_interface_box () {
        var grid = new Gtk.Grid ();
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.column_homogeneous = true;

        grid.attach (new SettingsHeader ("Interface"), 0, 0, 2, 1);

        grid.attach (new SettingsLabel ("Use Dark Theme:"), 0, 1, 1, 1);
        dark_theme_switch = new SettingsSwitch ("dark-theme");
        grid.attach (dark_theme_switch, 1, 1, 1, 1);

        dark_theme_switch.set_active (main_window.settings.get_boolean ("window-dark-theme"));

        dark_theme_switch.notify["active"].connect (() => {
            main_window.change_theme (false, dark_theme_switch.get_state ());
            // main_window.event_bus.change_theme ();
        });

        return grid;
    }

    private void configure_provider () {

        scroll_provider = new Gtk.ScrolledWindow (null, null);
        scroll_provider.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_provider = new Gtk.ListStore (2, typeof (string), typeof (string));
        add_iter_provider = Gtk.TreeIter ();

        Array<TradeSim.Objects.Provider> providers = new Array<TradeSim.Objects.Provider>();

        providers = qm.db.get_providers ();


        for (int i = 0 ; i < providers.length ; i++) {

            list_store_provider.append (out add_iter_provider);
            list_store_provider.set (add_iter_provider, 0, providers.index (i).name);
            list_store_provider.set (add_iter_provider, 1, providers.index (i).folder_name);

        }

        tree_view_provider = new Gtk.TreeView ();

        tree_view_provider.set_size_request (100, 200);

        tree_view_provider.set_model (list_store_provider);

        Gtk.CellRendererText provider_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText provider_folder_cell = new Gtk.CellRendererText ();

        tree_view_provider.get_selection ().changed.connect ((sel) => {

            Gtk.TreeIter edited_iter;
            Gtk.TreeModel model;
            GLib.Value nombre;

            sel.get_selected (out model, out edited_iter);


            model.get_value (edited_iter, 1, out nombre);

            ds_selected_provider = nombre.get_string ();

            update_quotes_by_filter ();

        });

        tree_view_provider.insert_column_with_attributes (-1, "Provider", provider_cell, "text", 0);
        tree_view_provider.insert_column_with_attributes (-1, "ProviderFolderName", provider_folder_cell, "text", 1);

        tree_view_provider.get_column (1).set_visible (false); // oculto la columna con la url.

        scroll_provider.add (tree_view_provider);
        scroll_provider.set_vexpand (true);
        scroll_provider.set_hexpand (true);
        scroll_provider.get_style_context ().add_class ("scrolled-window-data");

    }

    private void configure_ticker () {

        scroll_ticker = new Gtk.ScrolledWindow (null, null);
        scroll_ticker.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_ticker = new Gtk.ListStore (1, typeof (string));
        add_iter_ticker = Gtk.TreeIter ();

        Array<TradeSim.Objects.Ticker> tickers = new Array<TradeSim.Objects.Ticker>();

        tickers = qm.db.get_tickers ();


        for (int i = 0 ; i < tickers.length ; i++) {

            list_store_ticker.append (out add_iter_provider);
            list_store_ticker.set (add_iter_provider, 0, tickers.index (i).name);

        }

        tree_view_ticker = new Gtk.TreeView ();

        tree_view_ticker.set_model (list_store_ticker);

        Gtk.CellRendererText ticker_cell = new Gtk.CellRendererText ();

        tree_view_ticker.get_selection ().changed.connect ((sel) => {

            Gtk.TreeIter edited_iter;
            Gtk.TreeModel model;
            GLib.Value nombre;

            sel.get_selected (out model, out edited_iter);


            model.get_value (edited_iter, 0, out nombre);

            ds_selected_ticker = nombre.get_string ();

            update_quotes_by_filter ();

        });

        tree_view_ticker.insert_column_with_attributes (-1, "Ticker", ticker_cell, "text", 0);

        scroll_ticker.add (tree_view_ticker);
        scroll_ticker.set_vexpand (true);
        scroll_ticker.set_hexpand (true);
        scroll_ticker.get_style_context ().add_class ("scrolled-window-data");

    }

    private void configure_year () {

        int min_year = 2010;
        int max_year = 2020;

        scroll_year = new Gtk.ScrolledWindow (null, null);
        scroll_year.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_year = new Gtk.ListStore (1, typeof (string));
        add_iter_year = Gtk.TreeIter ();

        for (int i = max_year ; i >= min_year ; i--) {
            list_store_year.append (out add_iter_year);
            list_store_year.set (add_iter_year, 0, i.to_string ());
        }

        tree_view_year = new Gtk.TreeView ();

        tree_view_year.set_model (list_store_year);

        Gtk.CellRendererText year_cell = new Gtk.CellRendererText ();

        tree_view_year.get_selection ().changed.connect ((sel) => {

            Gtk.TreeIter edited_iter;
            Gtk.TreeModel model;
            GLib.Value nombre;

            sel.get_selected (out model, out edited_iter);


            model.get_value (edited_iter, 0, out nombre);

            ds_selected_year = nombre.get_string ();

            update_quotes_by_filter ();

        });

        tree_view_year.insert_column_with_attributes (-1, "Year", year_cell, "text", 0);

        scroll_year.add (tree_view_year);
        scroll_year.set_vexpand (true);
        scroll_year.set_hexpand (true);
        scroll_year.get_style_context ().add_class ("scrolled-window-data");

    }

    private void configure_time_frame () {

        scroll_time_frame = new Gtk.ScrolledWindow (null, null);
        scroll_time_frame.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_time_frame = new Gtk.ListStore (1, typeof (string));
        add_iter_time_frame = Gtk.TreeIter ();

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "D1");

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "H4");

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "H1");

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "M30");

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "M15");

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "M5");

        list_store_time_frame.append (out add_iter_time_frame);
        list_store_time_frame.set (add_iter_time_frame, 0, "M1");

        tree_view_time_frame = new Gtk.TreeView ();

        tree_view_time_frame.set_model (list_store_time_frame);

        Gtk.CellRendererText time_frame_cell = new Gtk.CellRendererText ();

        tree_view_time_frame.get_selection ().changed.connect ((sel) => {

            Gtk.TreeIter edited_iter;
            Gtk.TreeModel model;
            GLib.Value nombre;

            sel.get_selected (out model, out edited_iter);


            model.get_value (edited_iter, 0, out nombre);

            ds_selected_time_frame = nombre.get_string ();

            update_quotes_by_filter ();

        });

        tree_view_time_frame.insert_column_with_attributes (-1, "Time Frame", time_frame_cell, "text", 0);

        scroll_time_frame.add (tree_view_time_frame);
        scroll_time_frame.set_vexpand (true);
        scroll_time_frame.set_hexpand (true);
        scroll_time_frame.get_style_context ().add_class ("scrolled-window-data");

    }

    private void update_quotes_by_filter () {

        list_store_quotes.clear ();

        if ((ds_selected_provider == "") || (ds_selected_ticker == "") || (ds_selected_time_frame == "") || (ds_selected_year == "")) {
            return;
        }


        for (int i = 1 ; i <= 12 ; i++) {

            string url = "https://raw.githubusercontent.com/horaciodrs/TradeSim/master/data/quotes";
            string mes = i.to_string ();

            mes = "00" + mes;

            mes = mes.substring (mes.len () - 2, 2);

            url = url + "/" + ds_selected_provider;
            url = url + "/" + ds_selected_year;
            url = url + "/" + ds_selected_ticker;
            url = url + "/" + ds_selected_provider + "_" + ds_selected_ticker + "_" + ds_selected_time_frame + "_" + ds_selected_year + "_";
            url = url + mes + ".csv";

            //print(url + "\n");

            list_store_quotes.append (out add_iter_quotes);
            list_store_quotes.set (add_iter_quotes
                                   , 0, ds_selected_provider
                                   , 1, "Forex"
                                   , 2, ds_selected_ticker
                                   , 3, int.parse (ds_selected_year)
                                   , 4, get_month_name (i)
                                   , 5, ds_selected_time_frame
                                   , 6, qm.db.import_data_exists (ds_selected_provider, "Forex", ds_selected_ticker, ds_selected_time_frame, ds_selected_year.to_int (), i)
                                   , 7, url);
        }


    }

    private void configure_quotes () {

        scroll_quotes = new Gtk.ScrolledWindow (null, null);
        scroll_quotes.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_quotes = new Gtk.ListStore (8, typeof (string), typeof (string), typeof (string), typeof (int), typeof (string), typeof (string), typeof (bool), typeof (string));
        add_iter_quotes = Gtk.TreeIter ();

        tree_view_quotes = new Gtk.TreeView ();

        tree_view_quotes.set_model (list_store_quotes);

        Gtk.CellRendererText quotes_provider_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText quotes_ticker_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText quotes_market_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText quotes_timeframe_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText quotes_year_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText quotes_month_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererToggle quotes_data_toggle = new Gtk.CellRendererToggle ();
        Gtk.CellRendererText quotes_url_cell = new Gtk.CellRendererText ();

        quotes_data_toggle.toggled.connect ((toggle, path) => {

            Gtk.TreeIter edited_iter;
            GLib.Value url;
            GLib.Value mes;

            list_store_quotes.get_iter (out edited_iter, new Gtk.TreePath.from_string (path));

            list_store_quotes.get_value (edited_iter, 7, out url);
            list_store_quotes.get_value (edited_iter, 4, out mes);

            // print("mes:" + get_month_number(mes.get_string()).to_string());

            if (qm.db.import_data_exists (ds_selected_provider, "Forex", ds_selected_ticker, ds_selected_time_frame, ds_selected_year.to_int (), get_month_number (mes.get_string ()))) {

                qm.db.delete_imported_data (ds_selected_provider, "Forex", ds_selected_ticker, ds_selected_time_frame, ds_selected_year.to_int (), get_month_number (mes.get_string ()));

                list_store_quotes.set (edited_iter, 6, !toggle.active);

                return;

            }

            // Obtener datos desde el link de url....

            File file = File.new_for_uri (url.get_string ());

            // Open the file for reading:
            InputStream @is = file.read (); // esta linea da error cuando no esta el archivo...

            // Output: ``M``
            uint8 buffer[1];
            size_t size = @is.read (buffer);
            stdout.write (buffer, size);


            DataInputStream dis = new DataInputStream (@is);

            string str = "";

            str = dis.read_line ();

            while (str != null) {

                qm.insert_cuote_to_db (str);

                // print ("%s\n", str);

                str = dis.read_line ();
            }

            /*fin obtener archivo */

            list_store_quotes.set (edited_iter, 6, !toggle.active);

        });

        tree_view_quotes.insert_column_with_attributes (-1, "Provider", quotes_provider_cell, "text", 0);
        tree_view_quotes.insert_column_with_attributes (-1, "Market", quotes_market_cell, "text", 1);
        tree_view_quotes.insert_column_with_attributes (-1, "Ticker", quotes_ticker_cell, "text", 2);
        tree_view_quotes.insert_column_with_attributes (-1, "Year", quotes_year_cell, "text", 3);
        tree_view_quotes.insert_column_with_attributes (-1, "Month", quotes_month_cell, "text", 4);
        tree_view_quotes.insert_column_with_attributes (-1, "Timeframe", quotes_timeframe_cell, "text", 5);
        tree_view_quotes.insert_column_with_attributes (-1, "Imported", quotes_data_toggle, "active", 6);
        tree_view_quotes.insert_column_with_attributes (-1, "Url", quotes_url_cell, "text", 7);

        tree_view_quotes.get_column (7).set_visible (false); // oculto la columna con la url.

        scroll_quotes.add (tree_view_quotes);
        scroll_quotes.set_vexpand (true);
        scroll_quotes.set_hexpand (true);
        scroll_quotes.get_style_context ().add_class ("scrolled-window-data");

        // update_quotes_by_filter ();


    }

    private Gtk.Widget get_data_source_box () {

        // https://raw.githubusercontent.com/horaciodrs/TradeSim/master/data/quotes/EODATA/2020/EURUSD/EODATA_EURUSD_D1_2020_01.csv
        // FORMATO DE LOS ARCHVOS
        // Symbol, DateYear, DateMonth, DateDay, DateHours, DateMinutes, Open, High, Low, Close, Volume

        configure_provider ();
        configure_ticker ();
        configure_time_frame ();
        configure_year ();
        configure_quotes ();

        var grid = new Gtk.Grid ();
        grid.row_spacing = 3;
        grid.column_spacing = 3;
        grid.column_homogeneous = true;
        grid.set_hexpand (true);

        grid.attach (new SettingsHeader ("Data Source"), 0, 0);
        grid.attach (scroll_provider, 0, 1, 1, 2);
        grid.attach (scroll_ticker, 1, 1, 1, 2);
        grid.attach (scroll_year, 2, 1, 1, 2);
        grid.attach (scroll_time_frame, 3, 1, 1, 2);
        grid.attach (scroll_quotes, 0, 3, 4, 3);

        return grid;
    }

    private Gtk.Widget get_about_box () {
        var grid = new Gtk.Grid ();
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.halign = Gtk.Align.CENTER;

        var app_icon = new Gtk.Image ();
        app_icon.gicon = new ThemedIcon ("com.github.horaciodrs.TradeSim");
        app_icon.pixel_size = 64;
        app_icon.margin_top = 12;

        var app_name = new Gtk.Label ("TradeSim");
        app_name.get_style_context ().add_class ("h2");
        app_name.margin_top = 6;

        var app_description = new Gtk.Label ("The Linux Trading Simulator");
        app_description.get_style_context ().add_class ("h3");

        var app_version = new Gtk.Label ("v0 - alpha");
        app_version.get_style_context ().add_class ("dim-label");
        app_version.selectable = true;

        var disclaimer = new Gtk.Label ("Remember!\n TradeSim it's under development and it's on alpha state. Only install for testing.");

        disclaimer.justify = Gtk.Justification.CENTER;
        disclaimer.get_style_context ().add_class ("warning-message");
        disclaimer.max_width_chars = 60;
        disclaimer.wrap = true;
        disclaimer.margin_top = disclaimer.margin_bottom = 12;

        var patreons_label = new Gtk.Label ("Thanks to our awesome supporters!");
        patreons_label.get_style_context ().add_class ("h4");

        var patreons_url = new Gtk.LinkButton.with_label (
            "https://github.com/horaciodrs/tradesim/SUPPORTERS.md",
            "View the list of supporters"
            );
        patreons_url.halign = Gtk.Align.CENTER;
        patreons_url.margin_bottom = 12;

        grid.attach (app_icon, 0, 0);
        grid.attach (app_name, 0, 1);
        grid.attach (app_description, 0, 2);
        grid.attach (app_version, 0, 3);
        grid.attach (disclaimer, 0, 4);
        grid.attach (patreons_label, 0, 5);
        grid.attach (patreons_url, 0, 6);

        // Button grid at the bottom of the About page.
        var button_grid = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_grid.halign = Gtk.Align.CENTER;
        button_grid.spacing = 6;

        var donate_button = new Gtk.Button.with_label ("Make a Donation");
        donate_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://github.com/horaciodrs/tradesim#-support", null);
            } catch (Error e) {
                warning (e.message);
            }
        });

        var translate_button = new Gtk.Button.with_label ("Suggest Translations");
        translate_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://github.com/horaciodrs/tradesim/issues", null);
            } catch (Error e) {
                warning (e.message);
            }
        });

        var bug_button = new Gtk.Button.with_label ("Report a Problem");
        bug_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://github.com/horaciodrs/tradesim/issues", null);
            } catch (Error e) {
                warning (e.message);
            }
        });

        button_grid.add (donate_button);
        button_grid.add (translate_button);
        button_grid.add (bug_button);

        grid.attach (button_grid, 0, 7);

        return grid;
    }

    private class SettingsHeader : Gtk.Label {
        public SettingsHeader (string text) {
            label = text;
            get_style_context ().add_class ("h4");
            halign = Gtk.Align.START;
        }

    }

    private class SettingsLabel : Gtk.Label {
        public SettingsLabel (string text) {
            label = text;
            halign = Gtk.Align.END;
        }

    }

    private class SettingsSwitch : Gtk.Switch {
        public SettingsSwitch (string setting) {
            halign = Gtk.Align.START;
            // settings.bind (setting, this, "active", SettingsBindFlags.DEFAULT);
        }

    }
}