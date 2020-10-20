public class TradeSim.Widgets.ZoomButton : Gtk.Grid {
    public weak TradeSim.MainWindow main_window { get; construct; }

    private Gtk.Label label_btn;
    public Gtk.Button zoom_out_button;
    public Gtk.Button zoom_default_button;
    public Gtk.Button zoom_in_button;


    public ZoomButton (TradeSim.MainWindow window) {
        Object (
            main_window: window
            );
    }

    construct {
        get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        get_style_context ().add_class ("linked-flat");
        valign = Gtk.Align.CENTER;
        column_homogeneous = false;
        width_request = 140;
        hexpand = false;

        zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic", Gtk.IconSize.MENU);
        zoom_out_button.clicked.connect (zoom_out);
        zoom_out_button.get_style_context ().add_class ("raised");
        zoom_out_button.get_style_context ().add_class ("button-zoom");
        zoom_out_button.can_focus = false;
        zoom_out_button.tooltip_markup = Granite.markup_accel_tooltip ({ "<Ctrl>minus" }, "Zoom Out");

        zoom_default_button = new Gtk.Button.with_label ("100%");
        zoom_default_button.hexpand = true;
        zoom_default_button.clicked.connect (zoom_reset);
        zoom_default_button.can_focus = false;
        zoom_default_button.tooltip_markup = Granite.markup_accel_tooltip ({ "<Ctrl>0" }, "Reset Zoom");

        zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic", Gtk.IconSize.MENU);
        zoom_in_button.clicked.connect (zoom_in);
        zoom_in_button.get_style_context ().add_class ("raised");
        zoom_in_button.get_style_context ().add_class ("button-zoom");
        zoom_in_button.can_focus = false;
        zoom_in_button.tooltip_markup = Granite.markup_accel_tooltip ({ "<Ctrl>plus" }, "Zoom In");

        attach (zoom_out_button, 0, 0, 1, 1);
        attach (zoom_default_button, 1, 0, 1, 1);
        attach (zoom_in_button, 2, 0, 1, 1);

        label_btn = new Gtk.Label ("Zoom");
        label_btn.get_style_context ().add_class ("headerbar-label");
        label_btn.margin_top = 4;

        attach (label_btn, 0, 1, 3, 1);
        // udpate_label ();

        /*settings.changed["show-label"].connect ( () => {
            udpate_label ();
           });*/
    }

    /*private void udpate_label () {
        label_btn.visible = settings.show_label;
        label_btn.no_show_all = !settings.show_label;
       }*/

    public void zoom_set (double zoom_factor) {
        zoom_default_button.label = "%.0f%%".printf (zoom_factor);
    }

    public void zoom_out () {
        var zoom = int.parse (zoom_default_button.label) - 25;
        zoom_out_button.sensitive = (zoom > 25);
        if (zoom < 25) {
            return;
        }

        zoom_in_button.sensitive = true;
        zoom_default_button.label = "%.0f%%".printf (zoom);

        main_window.change_zoom_level (int.parse (zoom_default_button.label) / 100.000);

        // mainWindow.event_bus.request_zoom ("out");
    }

    public void zoom_in () {
        var zoom = int.parse (zoom_default_button.label) + 25;
        zoom_in_button.sensitive = (zoom < 150);
        if (zoom > 150) {
            return;
        }

        zoom_out_button.sensitive = true;
        zoom_default_button.label = "%.0f%%".printf (zoom);

        main_window.change_zoom_level (int.parse (zoom_default_button.label) / 100.000);

        // mainWindow.event_bus.request_zoom ("in");
    }

    public void zoom_reset () {

        zoom_in_button.sensitive = true;
        zoom_out_button.sensitive = true;
        zoom_default_button.label = "100%";

        main_window.change_zoom_level (1.000);

    }

}
