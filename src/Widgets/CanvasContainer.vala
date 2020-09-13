public class TradeSim.Widgets.CanvasContainer : Gtk.Box {

    public weak TradeSim.MainWindow main_window { get; construct; }

    string provider_name;
    string ticker_name;
    string time_frame;

    //public Gtk.Scrollbar hscollbar;

    public TradeSim.Widgets.Canvas chart_canvas;

    public CanvasContainer (TradeSim.MainWindow window, string _provider_name, string _ticker_name, string _time_frame, string _simulation_name, double _simulation_initial_balance) {
        Object (
            main_window: window,
            orientation : Gtk.Orientation.VERTICAL,
            spacing: 0
            );

        provider_name = _provider_name;
        ticker_name = _ticker_name;
        time_frame = _time_frame;

        init(_simulation_name, _simulation_initial_balance);
    }

    public void init(string simulation_name, double simulation_initial_balance) {

        var ajuste = new Gtk.Adjustment(0, 0, 100, 1, 1, 50);

        //chart_canvas = new TradeSim.Widgets.Canvas (main_window, "TRADESIM", "EURUSD", "H1");
        chart_canvas = new TradeSim.Widgets.Canvas (main_window, provider_name, ticker_name, time_frame, simulation_name, simulation_initial_balance);

        //hscollbar = new Gtk.Scrollbar (Gtk.Orientation.HORIZONTAL, ajuste);

        pack_start (chart_canvas, true, true, 0);

    }

}