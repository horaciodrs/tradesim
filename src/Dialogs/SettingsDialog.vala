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

    public Gtk.StackSwitcher stack_switcher;
    public Gtk.Grid grid_aparence;
    public Gtk.Grid grid_data_source;
    public Gtk.Grid grid_about_us;

    public Gtk.ProgressBar progress_import;
    public Gtk.Spinner spiner_data_source;
    public Gtk.Label label_waiting;
    public int data_files_found;
    public bool working;


    int item_focus;

    public SettingsDialog (TradeSim.MainWindow window, int _item_focus) {

        Object (
            main_window: window,
            border_width: 6,
            deletable: true,
            resizable: true,
            modal: true,
            title: _ ("Preferences")
            );

        set_default_size (300, 500);

        delete_event.connect ((e) => {
            return before_destroy ();
        });

        item_focus = _item_focus;

        data_files_found = 0;

        qm = new TradeSim.Services.QuotesManager ();

        ds_selected_provider = "";
        ds_selected_ticker = "";
        ds_selected_year = "";
        ds_selected_time_frame = "H1";

        grid_aparence = get_interface_box ();
        grid_data_source = get_data_source_box ();
        grid_about_us = get_about_box ();

        transient_for = main_window;
        stack = new Gtk.Stack ();
        stack.margin = 6;
        stack.margin_bottom = 15;
        stack.margin_top = 15;
        stack.add_titled (grid_aparence, "interface", _ ("Interface"));
        stack.add_titled (grid_data_source, "datasource", _ ("Data Source"));
        stack.add_titled (grid_about_us, "about", _ ("About"));
        stack.set_hexpand (true);
        stack.halign = Gtk.Align.FILL;

        stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);
        stack_switcher.halign = Gtk.Align.CENTER;


        var grid = new Gtk.Grid ();
        grid.halign = Gtk.Align.FILL;
        grid.attach (stack_switcher, 1, 1);
        grid.attach (stack, 1, 2);
        grid.set_hexpand (true);

        get_content_area ().add (grid);

        stack_focus ();


    }

    public bool before_destroy () {
        return working;
    }

    public void stack_focus () {

        switch (item_focus) {
        case TradeSim.MainWindow.SettingsActions.APARENCE:
            grid_aparence.set_visible (true);
            stack.set_visible_child (grid_aparence);
            break;
        case TradeSim.MainWindow.SettingsActions.DATA_SOURCE:
            grid_data_source.set_visible (true);
            stack.set_visible_child (grid_data_source);
            break;
        case TradeSim.MainWindow.SettingsActions.ABOUT_US:
            grid_about_us.set_visible (true);
            stack.set_visible_child (grid_about_us);
            break;
        }

    }

    private Gtk.Grid get_interface_box () {
        var grid = new Gtk.Grid ();
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.column_homogeneous = true;

        grid.attach (new SettingsHeader (_ ("Interface")), 0, 0, 2, 1);

        grid.attach (new SettingsLabel (_ ("Use Dark Theme:")), 0, 1, 1, 1);
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

            start_update_quotes_by_filter ();

        });

        tree_view_provider.insert_column_with_attributes (-1, _ ("Provider"), provider_cell, "text", 0);
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

            start_update_quotes_by_filter ();

        });

        tree_view_ticker.insert_column_with_attributes (-1, _ ("Ticker"), ticker_cell, "text", 0);

        scroll_ticker.add (tree_view_ticker);
        scroll_ticker.set_vexpand (true);
        scroll_ticker.set_hexpand (true);
        scroll_ticker.get_style_context ().add_class ("scrolled-window-data");

    }

    private void configure_year () {

        int min_year = 2019;
        int max_year = new DateTime.now_local().get_year();

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

            start_update_quotes_by_filter ();

        });

        tree_view_year.insert_column_with_attributes (-1, _ ("Year"), year_cell, "text", 0);

        scroll_year.add (tree_view_year);
        scroll_year.set_vexpand (true);
        scroll_year.set_hexpand (true);
        scroll_year.get_style_context ().add_class ("scrolled-window-data");

    }

    private void start_update_quotes_by_filter () {

        if (working) {
            return;
        }

        spiner_data_source.set_visible (true);
        spiner_data_source.start ();
        label_waiting.set_text (_ ("Waiting for data..."));
        progress_import.set_fraction (0.00);

        var loop = new MainLoop ();

        working = true;
        tree_view_provider.set_sensitive (false);
        tree_view_ticker.set_sensitive (false);
        tree_view_year.set_sensitive (false);
        tree_view_quotes.set_sensitive (false);

        update_quotes_by_filter.begin ((obj, res) => {

            update_quotes_by_filter.end (res);
            label_waiting.set_text (_ ("Done! - Has been found ") + data_files_found.to_string () + _ (" data files"));
            label_waiting.get_style_context ().add_class ("label-status");
            spiner_data_source.stop ();
            working = false;
            tree_view_provider.set_sensitive (true);
            tree_view_ticker.set_sensitive (true);
            tree_view_year.set_sensitive (true);
            tree_view_quotes.set_sensitive (true);

            main_window.main_layout.providers_panel.refresh_providers ();

            loop.quit ();

        });

        loop.run ();

    }

    private async bool check_file_exists (string url) {

        File file = File.new_for_uri (url);

        try {

            yield file.read_async ();

        } catch (Error e) {
            return false;
        }


        return true;

    }

    private async int get_file_lines (string url) {

        File file = File.new_for_uri (url);
        int return_value = 0;

        try {

            InputStream @is = yield file.read_async ();

            uint8 buffer[1];
            size_t size = @is.read (buffer);
            stdout.write (buffer, size);

            DataInputStream dis = new DataInputStream (@is);

            string str = "";

            str = yield dis.read_line_async ();

            while (str != null) {

                return_value++;

                str = yield dis.read_line_async ();

            }

        } catch (Error e) {
            return 0;
        }

        return return_value;

    }

    private async void update_quotes_by_filter () {

        list_store_quotes.clear ();

        if ((ds_selected_provider == "") || (ds_selected_ticker == "") || (ds_selected_time_frame == "") || (ds_selected_year == "")) {
            return;
        }

        data_files_found = 0;

        for (int i = 1 ; i <= 12 ; i++) {

            string url = main_window.settings.get_string ("tradesim-datasource-url");

            string mes = i.to_string ();

            mes = "00" + mes;

            mes = mes.substring (mes.length - 2, 2);

            url = url + "/" + ds_selected_provider;
            url = url + "/" + ds_selected_year;
            url = url + "/" + ds_selected_ticker;
            url = url + "/" + ds_selected_provider + "_" + ds_selected_ticker + "_" + ds_selected_time_frame + "_" + ds_selected_year + "_";
            url = url + mes + ".csv";

            bool existe_file = yield check_file_exists (url);

            if (existe_file) {

                list_store_quotes.append (out add_iter_quotes);
                list_store_quotes.set (add_iter_quotes
                                       , 0, ds_selected_provider
                                       , 1, "Forex"
                                       , 2, ds_selected_ticker
                                       , 3, int.parse (ds_selected_year)
                                       , 4, get_month_name (i)
                                       , 5, ds_selected_time_frame
                                       , 6, qm.db.import_data_exists (ds_selected_provider, "Forex", ds_selected_ticker, ds_selected_time_frame, int.parse (ds_selected_year), i)
                                       , 7, url);

                data_files_found++;

            }

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

            if (qm.db.import_data_exists (ds_selected_provider, "Forex", ds_selected_ticker, ds_selected_time_frame, int.parse (ds_selected_year), get_month_number (mes.get_string ()))) {

                qm.db.delete_imported_data (ds_selected_provider, "Forex", ds_selected_ticker, ds_selected_time_frame, int.parse (ds_selected_year), get_month_number (mes.get_string ()));

                list_store_quotes.set (edited_iter, 6, !toggle.active);

                main_window.main_layout.providers_panel.refresh_providers ();

                return;

            }

            spiner_data_source.set_visible (true);
            spiner_data_source.start ();
            label_waiting.set_text (_ ("Importing data..."));

            var loop = new MainLoop ();

            import_data_from_internet.begin (url.get_string (), (obj, res) => {

                import_data_from_internet.end (res);
                label_waiting.set_text (_ ("Done!"));
                label_waiting.get_style_context ().add_class ("label-status");
                spiner_data_source.stop ();
                loop.quit ();

            });

            loop.run ();

            list_store_quotes.set (edited_iter, 6, !toggle.active);

        });

        tree_view_quotes.insert_column_with_attributes (-1, _ ("Provider"), quotes_provider_cell, "text", 0);
        tree_view_quotes.insert_column_with_attributes (-1, _ ("Market"), quotes_market_cell, "text", 1);
        tree_view_quotes.insert_column_with_attributes (-1, _ ("Ticker"), quotes_ticker_cell, "text", 2);
        tree_view_quotes.insert_column_with_attributes (-1, _ ("Year"), quotes_year_cell, "text", 3);
        tree_view_quotes.insert_column_with_attributes (-1, _ ("Month"), quotes_month_cell, "text", 4);
        tree_view_quotes.insert_column_with_attributes (-1, _ ("Timeframe"), quotes_timeframe_cell, "text", 5);
        tree_view_quotes.insert_column_with_attributes (-1, _ ("Imported"), quotes_data_toggle, "active", 6);
        tree_view_quotes.insert_column_with_attributes (-1, "Url", quotes_url_cell, "text", 7);

        tree_view_quotes.get_column (5).set_visible (false); // oculto la columna con el Timeframe.
        tree_view_quotes.get_column (7).set_visible (false); // oculto la columna con la url.

        scroll_quotes.add (tree_view_quotes);
        scroll_quotes.set_vexpand (true);
        scroll_quotes.set_hexpand (true);
        scroll_quotes.get_style_context ().add_class ("scrolled-window-data");

        // update_quotes_by_filter ();


    }

    private bool check_import_state () {

        // Esta función es llamada con Timer y se ejecuta hasta que la
        // importación de los datos es completada.

        if (qm.db.import_total_lines == 0) {
            return true;
        }

        double completado = 1.00 * qm.db.imported_lines / qm.db.import_total_lines;

        progress_import.set_fraction (completado);
        label_waiting.set_text (_ ("Imported ") + qm.db.imported_lines.to_string () + " of " + qm.db.import_total_lines.to_string () + _ (" quotes."));

        if (qm.db.imported_lines == qm.db.import_total_lines) {
            label_waiting.set_text (_ ("Import Completed!"));
            tree_view_provider.set_sensitive (true);
            tree_view_ticker.set_sensitive (true);
            tree_view_year.set_sensitive (true);
            tree_view_quotes.set_sensitive (true);
            qm.db.end_import_quotes ();
            working = false;
            main_window.main_layout.providers_panel.refresh_providers ();
            return false;
        }

        return true;

    }

    private async void import_data_from_internet (string url) {

        // TODO: Tengo que conocer la cantidad de lineas que tiene el archivo.
        // TODO: para poder conocer el momento en el que se terminan de ejecutar
        // TODO: todos los hilos que se encargan de subir las cotizaciones en
        // TODO: la base de datos. De esta forma puedo saber cuando se termino
        // TODO: de importar el archivo y puedo manejar este evento.
        // TODO: En la clase QuotesManager agregue una propiedad para registrar
        // TODO: la cantidad todas de lineas a importar y la cantidad que se
        // TODO: han importado hasta el momento.

        working = true;

        tree_view_provider.set_sensitive (false);
        tree_view_ticker.set_sensitive (false);
        tree_view_year.set_sensitive (false);
        tree_view_quotes.set_sensitive (false);

        qm.db.start_import_quotes (yield get_file_lines (url));
        Timeout.add (100, check_import_state, GLib.Priority.HIGH);

        File file = File.new_for_uri (url);

        try {

            InputStream @is = yield file.read_async ();

            uint8 buffer[1];
            size_t size = @is.read (buffer);
            stdout.write (buffer, size);

            DataInputStream dis = new DataInputStream (@is);

            string str = "";

            str = yield dis.read_line_async ();

            while (str != null) {

                qm.insert_cuote_to_db (str); // Esto es un Thread, queda procesando en segundo plano.

                str = yield dis.read_line_async ();

            }

        } catch (Error e) {
            error ("%s", e.message);
        }

    }

    private Gtk.Grid get_data_source_box () {

        // https://raw.githubusercontent.com/horaciodrs/TradeSim/master/data/quotes/EODATA/2020/EURUSD/EODATA_EURUSD_D1_2020_01.csv
        // FORMATO DE LOS ARCHVOS
        // Symbol, DateYear, DateMonth, DateDay, DateHours, DateMinutes, Open, High, Low, Close, Volume

        configure_provider ();
        configure_ticker ();
        configure_year ();
        configure_quotes ();

        var grid = new Gtk.Grid ();
        grid.row_spacing = 3;
        grid.column_spacing = 3;
        grid.column_homogeneous = true;
        grid.set_hexpand (true);

        var grid_waiting = new Gtk.Grid ();
        spiner_data_source = new Gtk.Spinner ();
        label_waiting = new Gtk.Label ("");
        grid_waiting.attach (spiner_data_source, 0, 0);
        grid_waiting.attach (label_waiting, 1, 0);
        grid_waiting.halign = Gtk.Align.CENTER;

        progress_import = new Gtk.ProgressBar ();

        spiner_data_source.halign = Gtk.Align.END;
        label_waiting.halign = Gtk.Align.START;

        var delete_button = new Gtk.Button.with_label (_ ("Reset"));
        var backup_button = new Gtk.Button.with_label (_ ("Export"));
        var restore_button = new Gtk.Button.with_label (_ ("Import"));

        var download_label = new Gtk.Label (_ ("If you cannot import the quotes from under section. Try clicking the Download button and follow the steps."));
        var download_button = new Gtk.Button.with_label (_ ("Download available quotes"));

        download_label.justify = Gtk.Justification.CENTER;
        download_label.get_style_context ().add_class ("warning-message");
        download_label.max_width_chars = 60;
        download_label.wrap = true;
        download_label.margin_top = download_label.margin_bottom = 12;

        download_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://github.com/horaciodrs/tradesim/quotes", null);
            } catch (Error e) {
                warning (e.message);
            }
        });


        restore_button.clicked.connect ( () => {

            var dialog = new Gtk.FileChooserDialog (_ ("Import Database file"), this,
                                                Gtk.FileChooserAction.OPEN,
                                                _ ("Open"),
                                                Gtk.ResponseType.OK,
                                                _ ("Cancel"),
                                                Gtk.ResponseType.CANCEL
                                                );

            dialog.set_modal (true);

            Gtk.FileFilter filter = new Gtk.FileFilter ();
            filter.add_pattern ("*.db");
            filter.set_filter_name (_ ("Sqlite files"));
            dialog.add_filter (filter);

            filter = new Gtk.FileFilter ();
            filter.add_pattern ("*");
            filter.set_filter_name (_ ("All files"));

            dialog.add_filter (filter);

            dialog.response.connect ((dialog, response_id) => {

                var dlg = (Gtk.FileChooserDialog)dialog;

                switch (response_id) {
                case Gtk.ResponseType.OK:
                    string file_path = dlg.get_filename ();
                    if (file_path.index_of (".db") < 0) {
                        file_path += ".db";
                    }
                    if (confirm ("Warning! All previous data will be lost. Are you sure you want to import this database file?", main_window, Gtk.MessageType.WARNING)){
                        qm.db.import (file_path);
                        qm = new TradeSim.Services.QuotesManager ();
                        main_window.main_layout.providers_panel.refresh_providers ();
                        update_quotes_by_filter.begin ((obj, res) => {});
                    }
                    break;
                case Gtk.ResponseType.CANCEL:
                    print ("Cancel\n");
                    break;
                }

                dlg.destroy ();

            });

            dialog.show ();


        });

        backup_button.clicked.connect ( () => {

            var dialog = new Gtk.FileChooserDialog (_ ("Export database file"), main_window,
                                                    Gtk.FileChooserAction.SAVE,
                                                    _ ("Save"),
                                                    Gtk.ResponseType.OK,
                                                    _ ("Cancel"),
                                                    Gtk.ResponseType.CANCEL
                                                    );

            dialog.set_do_overwrite_confirmation (true);
            dialog.set_modal (true);

            Gtk.FileFilter filter = new Gtk.FileFilter ();
            filter.add_pattern ("*.db");
            filter.set_filter_name (_ ("Sqlite files"));
            dialog.add_filter (filter);

            filter = new Gtk.FileFilter ();
            filter.add_pattern ("*");
            filter.set_filter_name (_ ("All files"));

            dialog.add_filter (filter);

            dialog.response.connect ((dialog, response_id) => {

                var dlg = (Gtk.FileChooserDialog)dialog;

                switch (response_id) {
                case Gtk.ResponseType.OK:
                    string file_path = dlg.get_filename ();
                    if (file_path.index_of (".db") < 0) {
                        file_path += ".db";
                    }
                    qm.db.export (file_path);
                    break;
                case Gtk.ResponseType.CANCEL:
                    print ("Cancel\n");
                    break;
                }

                dlg.destroy ();

            });

            dialog.show ();


        });

        delete_button.clicked.connect ( () => {

            if( confirm(_("Are you sure you want to database reset?"), main_window, Gtk.MessageType.QUESTION)){

                qm.db.reset ();

                main_window.main_layout.providers_panel.refresh_providers ();

                start_update_quotes_by_filter ();

            }

        });

        grid.attach (new SettingsHeader (_ ("Database")), 0, 0);
        grid.attach (delete_button, 0, 1);
        grid.attach (backup_button, 1, 1);
        grid.attach (restore_button, 2, 1);

        grid.attach (download_label, 0, 2, 3);
        grid.attach (download_button, 0, 3, 3);

        grid.attach (new SettingsHeader (_ ("Data Source")), 0, 4);
        grid.attach (scroll_provider, 0, 5, 1, 2);
        grid.attach (scroll_ticker, 1, 5, 1, 2);
        grid.attach (scroll_year, 2, 5, 1, 2);
        grid.attach (scroll_quotes, 0, 7, 3, 3);
        grid.attach (grid_waiting, 0, 10, 3);
        grid.attach (progress_import, 0, 11, 3);

        return grid;
    }

    private Gtk.Grid get_about_box () {
        var grid = new Gtk.Grid ();
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.halign = Gtk.Align.CENTER;

        var app_icon = new Gtk.Image ();
        app_icon.gicon = new ThemedIcon ("com.github.horaciodrs.tradesim");
        app_icon.pixel_size = 64;
        app_icon.margin_top = 12;

        var app_name = new Gtk.Label ("TradeSim");
        app_name.get_style_context ().add_class ("h2");
        app_name.margin_top = 6;

        var app_description = new Gtk.Label (_ ("The Linux Trading Simulator"));
        app_description.get_style_context ().add_class ("h3");

        var app_version = new Gtk.Label (TradeSim.Data.APP_VERSION);
        app_version.get_style_context ().add_class ("dim-label");
        app_version.selectable = true;

        var disclaimer = new Gtk.Label (_ ("Remember!\n TradeSim it's under development and it's on beta state. Only install for testing."));

        disclaimer.justify = Gtk.Justification.CENTER;
        disclaimer.get_style_context ().add_class ("warning-message");
        disclaimer.max_width_chars = 60;
        disclaimer.wrap = true;
        disclaimer.margin_top = disclaimer.margin_bottom = 12;

        var patreons_label = new Gtk.Label (_ ("Thanks to our awesome supporters!"));
        patreons_label.get_style_context ().add_class ("h4");

        var patreons_url = new Gtk.LinkButton.with_label (
            "https://github.com/horaciodrs/tradesim/SUPPORTERS.md",
            _ ("View the list of supporters")
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

        var donate_button = new Gtk.Button.with_label (_ ("Make a Donation"));
        donate_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://github.com/horaciodrs/tradesim#-support", null);
            } catch (Error e) {
                warning (e.message);
            }
        });

        var translate_button = new Gtk.Button.with_label (_ ("Suggest Translations"));
        translate_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("https://github.com/horaciodrs/tradesim/issues", null);
            } catch (Error e) {
                warning (e.message);
            }
        });

        var bug_button = new Gtk.Button.with_label (_ ("Report a Problem"));
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
