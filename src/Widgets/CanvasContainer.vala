public class TradeSim.Widgets.CanvasContainer : Gtk.Box {

    public weak TradeSim.MainWindow main_window { get; construct; }

    string provider_name;
    string ticker_name;
    string time_frame;
    string file_name;
    DateTime initial_date;

    private int page;

    // public Gtk.Scrollbar hscollbar;

    public TradeSim.Widgets.Canvas chart_canvas;
    public TradeSim.Widgets.OscilatorCanvas oscilator_canvas;

    private Gtk.Paned pane_container;

    public CanvasContainer (TradeSim.MainWindow window, string _provider_name, string _ticker_name, string _time_frame, string _simulation_name, double _simulation_initial_balance, DateTime _initial_date, string ? from_file = null) {
        Object (
            main_window: window,
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0
            );

        provider_name = _provider_name;
        ticker_name = _ticker_name;
        time_frame = _time_frame;
        file_name = from_file;
        initial_date = _initial_date;

        init (_simulation_name, _simulation_initial_balance);
    }

    public void init (string simulation_name, double simulation_initial_balance) {

        // var ajuste = new Gtk.Adjustment (0, 0, 100, 1, 1, 50);

        pane_container = new Gtk.Paned (Gtk.Orientation.VERTICAL);

        oscilator_canvas = new TradeSim.Widgets.OscilatorCanvas (main_window);
        chart_canvas = new TradeSim.Widgets.Canvas (main_window, oscilator_canvas, provider_name, ticker_name, time_frame, simulation_name, simulation_initial_balance, initial_date, file_name);
        

        pane_container.pack1(chart_canvas, true, true);
        pane_container.pack2(oscilator_canvas, true, true);

        /*
            //De esta manera se puede ocultar el panel del oscilador.
            var oc = main_window.main_layout.current_oscilator_canvas;
            oc.set_size_request(100, -1);
        */

        oscilator_canvas.set_size_request(100, 100);

        pack_start (pane_container, true, true, 0);

    }

    public void set_page (int p) {
        page = p;
    }

    public int get_page () {
        return page;
    }

}
