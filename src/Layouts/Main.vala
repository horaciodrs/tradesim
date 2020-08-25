public class TradeSim.Layouts.Main : Gtk.Box {

    public weak TradeSim.MainWindow main_window {get; construct; }

    public Gtk.Paned pane_top;
    public Gtk.Paned pane_left;

    public Main (TradeSim.MainWindow window) {
        Object (
            main_window: window
        );
    }

    construct {

        pane_top = new Gtk.Paned (Gtk.Orientation.VERTICAL);
        pane_left = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

        pane_left.pack1(new Gtk.Label("Hola"), true, true);
        pane_left.pack2(new Gtk.Label("Mundo"), true, true);

        pane_top.pack1(pane_left, true, false);
        pane_top.pack2(new Gtk.Label("Bottom Bar"), true, true);
        
        pack_start (pane_top, true, true, 1);

    }
}