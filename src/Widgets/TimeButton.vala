public class TradeSim.Widgets.TimeButton : Gtk.Grid {

    public weak TradeSim.MainWindow main_window { get; construct; }

    public Gtk.Label time_container_label;
    public Gtk.Button m1;
    public Gtk.Button m15;
    public Gtk.Button h1;
    public Gtk.Button tx;   //Botom para elegir un marco temporal personalizado

    public TimeButton (TradeSim.MainWindow window) {
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

        m1 = new Gtk.Button.with_label ("M1");
        m1.get_style_context ().add_class ("raised");
        m1.get_style_context ().add_class ("button-zoom");
        m1.can_focus = false;

        m15 = new Gtk.Button.with_label ("M15");
        m15.hexpand = true;
        m15.can_focus = false;

        h1 = new Gtk.Button.with_label ("H1");
        h1.hexpand = true;
        h1.can_focus = false;

        tx = new Gtk.Button.with_label ("Tx");
        tx.get_style_context ().add_class ("raised");
        tx.get_style_context ().add_class ("button-zoom");
        tx.can_focus = false;

        attach (m1, 0, 0, 1, 1);
        attach (m15, 1, 0, 1, 1);
        attach (h1, 2, 0, 1, 1);
        attach (tx, 3, 0, 1, 1);

        time_container_label = new Gtk.Label ("Temporalidad (M15)");
        time_container_label.get_style_context ().add_class ("headerbar-label");
        time_container_label.margin_top = 4;

        attach (time_container_label, 0, 1, 4, 1);
     
    }

}