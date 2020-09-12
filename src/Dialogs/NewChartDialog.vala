public class TradeSim.Dialogs.NewChartDialog : Gtk.Dialog {
    public weak TradeSim.MainWindow main_window { get; construct; }

    public Gtk.Button acept_button;
    public Gtk.Button cancel_button;

    private Gtk.Label header_title;

    private Gtk.Label label_name;
    private Gtk.Label label_provider;
    private Gtk.Label label_ticker;
    private Gtk.Label label_time_frame;
    private Gtk.Label label_amount;

    private Gtk.Entry txt_name;
    private Gtk.Entry txt_amount;

    private Gtk.ComboBox cbo_provider;
    private Gtk.ComboBox cbo_ticker;
    private Gtk.ComboBox cbo_time_frame;

    private string aux_provider_name;
    private string aux_time_frame_name;
    private string aux_ticker_name;

    private TradeSim.Services.Database db;

    enum Action {
        OK,
        CANCEL
    }

    public NewChartDialog (TradeSim.MainWindow ? parent, string _provider_name, string _ticker_name) {
        Object (
            border_width: 5,
            deletable: false,
            resizable: true,
            title: "New Simulation",
            transient_for: parent,
            main_window: parent
            );

        aux_provider_name = _provider_name;
        aux_ticker_name = _ticker_name;

        init ();

    }

    public void init () {

        db = new TradeSim.Services.Database ();

        build_content ();

        response.connect (on_response);

    }

    private void build_content () {

        var body = get_content_area ();

        var header_grid = new Gtk.Grid ();
        header_grid.margin_start = 30;
        header_grid.margin_end = 30;
        header_grid.margin_bottom = 10;

        var image = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.DIALOG);
        image.margin_end = 10;

        header_title = new Gtk.Label ("New Simulation");
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.halign = Gtk.Align.START;
        header_title.ellipsize = Pango.EllipsizeMode.END;
        header_title.margin_end = 10;
        header_title.set_line_wrap (true);
        header_title.hexpand = true;

        header_grid.attach (image, 0, 0, 1, 2);
        header_grid.attach (header_title, 1, 0, 1, 2);

        body.add (header_grid);

        var form_grid = new Gtk.Grid ();
        form_grid.margin = 30;
        form_grid.row_spacing = 12;
        form_grid.column_spacing = 20;

        label_name = new Gtk.Label ("Simulation Name:");
        txt_name = new Gtk.Entry ();
        label_name.halign = Gtk.Align.END;

        form_grid.attach (label_name, 0, 0, 1, 1);
        form_grid.attach (txt_name, 1, 0, 1, 1);

        label_provider = new Gtk.Label ("Data Provider:");
        build_cbo_provider ();
        label_provider.halign = Gtk.Align.END;

        label_ticker = new Gtk.Label ("Ticker:");
        build_cbo_ticker ();
        label_ticker.halign = Gtk.Align.END;

        label_time_frame = new Gtk.Label ("Timeframe:");
        build_cbo_time_frame ();
        label_time_frame.halign = Gtk.Align.END;

        label_amount = new Gtk.Label ("Initial Balance:");
        txt_amount = new Gtk.Entry ();
        label_amount.halign = Gtk.Align.END;

        form_grid.attach (label_provider, 0, 1, 1, 1);
        form_grid.attach (cbo_provider, 1, 1, 1, 1);

        form_grid.attach (label_ticker, 0, 2, 1, 1);
        form_grid.attach (cbo_ticker, 1, 2, 1, 1);

        form_grid.attach (label_time_frame, 0, 3, 1, 1);
        form_grid.attach (cbo_time_frame, 1, 3, 1, 1);

        form_grid.attach (label_amount, 0, 4, 1, 1);
        form_grid.attach (txt_amount, 1, 4, 1, 1);


        body.add (form_grid);

        acept_button = new Gtk.Button.with_label ("Ok");
        acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        cancel_button = new Gtk.Button.with_label ("Cancel");

        add_action_widget (acept_button, Action.OK);
        add_action_widget (cancel_button, Action.CANCEL);

    }

    private void build_cbo_provider () {

        Array<TradeSim.Objects.Provider> providers = db.get_providers_with_data ();

        var list_store_providers = new Gtk.ListStore (1, typeof (string));

        for (int i = 0 ; i < providers.length ; i++) {
            Gtk.TreeIter iter;
            list_store_providers.append (out iter);
            list_store_providers.set (iter, 0, providers.index (i).name);
        }

        cbo_provider = new Gtk.ComboBox.with_model (list_store_providers);
        var cell = new Gtk.CellRendererText ();
        cbo_provider.pack_start (cell, false);

        cbo_provider.set_attributes (cell, "text", 0);
        cbo_provider_select_by_text(aux_provider_name);
        cbo_provider.changed.connect (cbo_provider_changed);

    }

    public void cbo_provider_select_by_text (string txt) {

        Array<TradeSim.Objects.Provider> providers = db.get_providers_with_data ();

        for (int i = 0 ; i < providers.length ; i++) {
            if(providers.index(i).name == txt){
                cbo_provider.set_active (i);
            }
        }

    }

    public void cbo_provider_changed () {

        var modelo = cbo_provider.get_model ();
        Gtk.TreeIter selected_item;
        GLib.Value selected_provider;

        cbo_provider.get_active_iter (out selected_item);
        modelo.get_value (selected_item, 0, out selected_provider);

        aux_provider_name = selected_provider.get_string ();

        reload_cbo_ticker ();
        reload_cbo_time_frame ();

    }

    private void build_cbo_ticker () {

        var list_store_ticker = new Gtk.ListStore (1, typeof (string));

        if (aux_provider_name != "") {

            Array<string> tickers = db.get_tickers_with_data (aux_provider_name);

            for (int i = 0 ; i < tickers.length ; i++) {
                Gtk.TreeIter iter;
                list_store_ticker.append (out iter);
                list_store_ticker.set (iter, 0, tickers.index (i));
            }

        }

        cbo_ticker = new Gtk.ComboBox.with_model (list_store_ticker);
        var cell = new Gtk.CellRendererText ();
        cbo_ticker.pack_start (cell, false);

        cbo_ticker.set_attributes (cell, "text", 0);
        cbo_ticker_select_by_text(aux_ticker_name);
        cbo_ticker.changed.connect (cbo_ticker_changed);
        
        //cbo_ticker.set_active(-1);

    }

    public void cbo_ticker_changed () {

        var modelo = cbo_ticker.get_model ();
        Gtk.TreeIter selected_item;
        GLib.Value selected_ticker;

        cbo_ticker.get_active_iter (out selected_item);
        modelo.get_value (selected_item, 0, out selected_ticker);

        aux_ticker_name = selected_ticker.get_string ();

    }

    public void reload_cbo_ticker () {

        var list_store_ticker = new Gtk.ListStore (1, typeof (string));

        if (aux_provider_name != "") {

            Array<string> tickers = db.get_tickers_with_data (aux_provider_name);

            for (int i = 0 ; i < tickers.length ; i++) {
                Gtk.TreeIter iter;
                list_store_ticker.append (out iter);
                list_store_ticker.set (iter, 0, tickers.index (i));
            }

        }

        cbo_ticker.set_model (list_store_ticker);
        cbo_ticker.set_active (-1);

    }

    public void cbo_ticker_select_by_text (string txt) {

        Array<string> tickers = db.get_tickers_with_data (aux_provider_name);

        for (int i = 0 ; i < tickers.length ; i++) {
            if(tickers.index(i) == txt){
                cbo_ticker.set_active (i);
            }
        }

    }

    private void build_cbo_time_frame () {

        var list_store_time_frames = new Gtk.ListStore (1, typeof (string));

        if (aux_provider_name != "") {

            Array<string> time_frames = db.get_time_frames_with_data (aux_provider_name);

            for (int i = 0 ; i < time_frames.length ; i++) {
                Gtk.TreeIter iter;
                list_store_time_frames.append (out iter);
                list_store_time_frames.set (iter, 0, time_frames.index (i));
            }

        }

        cbo_time_frame = new Gtk.ComboBox.with_model (list_store_time_frames);
        var cell = new Gtk.CellRendererText ();
        cbo_time_frame.pack_start (cell, false);

        cbo_time_frame.set_attributes (cell, "text", 0);

        cbo_time_frame.changed.connect (cbo_time_frame_changed);

        cbo_time_frame.set_active(-1);

    }

    public void cbo_time_frame_changed () {

        var modelo = cbo_time_frame.get_model ();
        Gtk.TreeIter selected_item;
        GLib.Value selected_time_frame;

        cbo_time_frame.get_active_iter (out selected_item);
        modelo.get_value (selected_item, 0, out selected_time_frame);

        aux_time_frame_name = selected_time_frame.get_string ();

    }

    public void reload_cbo_time_frame () {

        var list_store_time_frames = new Gtk.ListStore (1, typeof (string));

        if (aux_provider_name != "") {

            Array<string> time_frames = db.get_time_frames_with_data (aux_provider_name);

            for (int i = 0 ; i < time_frames.length ; i++) {
                Gtk.TreeIter iter;
                list_store_time_frames.append (out iter);
                list_store_time_frames.set (iter, 0, time_frames.index (i));
            }

        }

        cbo_time_frame.set_model (list_store_time_frames);
        cbo_time_frame.set_active (-1);

    }

    public void cbo_time_frame_select_by_text (string txt) {

        Array<string> time_frames = db.get_time_frames_with_data (aux_provider_name);

        for (int i = 0 ; i < time_frames.length ; i++) {
            if(time_frames.index(i) == txt){
                cbo_time_frame.set_active (i);
            }
        }

    }

    private void on_response (Gtk.Dialog source, int response_id) {

        switch (response_id) {
        case Action.OK:

            TradeSim.Dialogs.NewChartDialog dialogo = ((TradeSim.Dialogs.NewChartDialog)source);

            var objetivo = dialogo.main_window.main_layout;

            print("provider:" + aux_provider_name + " ticker:" + aux_ticker_name + " time_frame: " + aux_time_frame_name);
            //el error es porque en el dialogo nuevo. Falta el combo de Ticker.

            objetivo.new_chart(aux_provider_name, aux_ticker_name, aux_time_frame_name);

            destroy ();

            break;

        case Action.CANCEL:
            destroy ();
            break;
        }
    }

}