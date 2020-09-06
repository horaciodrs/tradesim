public class TradeSim.Dialogs.SettingsDialog : Gtk.Dialog {
    public weak TradeSim.MainWindow main_window { get; construct; }
    private Gtk.Stack stack;
    private Gtk.Switch dark_theme_switch;

    public SettingsDialog (TradeSim.MainWindow window) {
        Object (
            main_window: window,
            border_width: 6,
            deletable: true,
            resizable: false,
            modal: true,
            title: "Preferencias"
            );
    }

    construct {
        transient_for = main_window;
        stack = new Gtk.Stack ();
        stack.margin = 6;
        stack.margin_bottom = 15;
        stack.margin_top = 15;
        stack.add_titled (get_interface_box (), "interface", "Interface");
        stack.add_titled (get_data_source_box (), "datasource", "Data Source");
        stack.add_titled (get_about_box (), "about", "About");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);
        stack_switcher.halign = Gtk.Align.CENTER;

        var grid = new Gtk.Grid ();
        grid.halign = Gtk.Align.CENTER;
        grid.attach (stack_switcher, 1, 1, 1, 1);
        grid.attach (stack, 1, 2, 1, 1);

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

    private Gtk.Widget get_data_source_box () {

        var grid = new Gtk.Grid ();
        grid.row_spacing = 3;
        /*grid.column_spacing = 12;*/
        grid.column_homogeneous = true;

        var scroll = new Gtk.ScrolledWindow(null, null);
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        

        /******************************* */

        Gtk.ListStore list_store = new Gtk.ListStore(5, typeof(string), typeof(string), typeof(string), typeof(string), typeof(string));
        Gtk.TreeIter add_iter = Gtk.TreeIter();

        list_store.append(out add_iter);
        list_store.set(add_iter, 0, "EURUSD", 1, "Forex", 2, "M1", 3, "2011", 4, "Enero");

        list_store.append(out add_iter);
        list_store.set(add_iter, 0, "EURUSD", 1, "Forex", 2, "M1", 3, "2011", 4, "Febrero");

        Gtk.TreeView tree_view = new Gtk.TreeView();

        tree_view.set_model(list_store);

        Gtk.CellRendererText ticker_cell = new Gtk.CellRendererText();
        Gtk.CellRendererText market_cell = new Gtk.CellRendererText();
        Gtk.CellRendererText timeframe_cell = new Gtk.CellRendererText();
        Gtk.CellRendererText year_cell = new Gtk.CellRendererText();
        Gtk.CellRendererText month_cell = new Gtk.CellRendererText();

        tree_view.insert_column_with_attributes(-1, "Ticker", ticker_cell, "text", 0);
        tree_view.insert_column_with_attributes(-1, "Mercado", market_cell, "text", 1);
        tree_view.insert_column_with_attributes(-1, "Year", timeframe_cell, "text", 2);
        tree_view.insert_column_with_attributes(-1, "Year", year_cell, "text", 3);
        tree_view.insert_column_with_attributes(-1, "Month", month_cell, "text", 4);

        scroll.get_style_context ().add_class ("scrolled-window-data");

        /***************************** */

        scroll.add(tree_view);
        scroll.set_vexpand(true);


        grid.attach (new SettingsHeader ("Data Source"), 0, 0);
        grid.attach (scroll, 0, 1);

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