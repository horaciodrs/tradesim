public class TradeSim.Widgets.CanvasContainer : Gtk.Box {

    public weak TradeSim.MainWindow main_window { get; construct; }

    //public Gtk.Scrollbar hscollbar;

    public TradeSim.Widgets.Canvas chart_canvas;

    public CanvasContainer (TradeSim.MainWindow window) {
        Object (
            main_window: window,
            orientation : Gtk.Orientation.VERTICAL,
            spacing: 0
            );
    }

    construct {

        var ajuste = new Gtk.Adjustment(0, 0, 100, 1, 1, 50);

        chart_canvas = new TradeSim.Widgets.Canvas (main_window, "TRADESIM", "EURUSD", "H1");

        //hscollbar = new Gtk.Scrollbar (Gtk.Orientation.HORIZONTAL, ajuste);

        pack_start (chart_canvas, true, true, 0);
        //pack_start (hscollbar, false, true, 0);

    }

}