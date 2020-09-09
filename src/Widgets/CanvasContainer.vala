public class TradeSim.Widgets.CanvasContainer : Gtk.Box {

    public weak TradeSim.MainWindow main_window { get; construct; }

    string provider_name;
    string ticker_name;
    string time_frame;

    //public Gtk.Scrollbar hscollbar;

    public TradeSim.Widgets.Canvas chart_canvas;

    public CanvasContainer (TradeSim.MainWindow window, string _provider_name, string _ticker_name, string _time_frame) {
        Object (
            main_window: window,
            orientation : Gtk.Orientation.VERTICAL,
            spacing: 0
            );

        provider_name = _provider_name;
        ticker_name = _ticker_name;
        time_frame = _time_frame;

        init();
    }

    public void init() {

        var ajuste = new Gtk.Adjustment(0, 0, 100, 1, 1, 50);

        //chart_canvas = new TradeSim.Widgets.Canvas (main_window, "TRADESIM", "EURUSD", "H1");
        chart_canvas = new TradeSim.Widgets.Canvas (main_window, provider_name, ticker_name, time_frame);

        //hscollbar = new Gtk.Scrollbar (Gtk.Orientation.HORIZONTAL, ajuste);

        pack_start (chart_canvas, true, true, 0);

    }

}