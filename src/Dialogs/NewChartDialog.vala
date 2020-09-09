public class TradeSim.Dialogs.NewChartDialog : Gtk.Dialog {

    public weak TradeSim.MainWindow main_window { get; construct; }

    public Gtk.Calendar calendario;
    public Gtk.Entry time_frame;
    public Gtk.Button acept_button;
    public Gtk.Button cancel_button;


    public NewChartDialog (TradeSim.MainWindow window) {
        Object (
            main_window: window,
            border_width: 6,
            deletable: true,
            resizable: true,
            modal: true,
            title: "Nuevo Gráfico"
            );
    }

    construct {


        var grid = new Gtk.Grid ();
        grid.halign = Gtk.Align.FILL;
        grid.row_spacing = 6;
        grid.column_spacing = 6;

        time_frame = new Gtk.Entry ();

        calendario = new Gtk.Calendar ();

        acept_button = new Gtk.Button.with_label ("Ok");
        cancel_button = new Gtk.Button.with_label ("Cancel");

        cancel_button.clicked.connect (() => {
            close ();
        });

        acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var lbl_time_frame = new Gtk.Label ("Time Frame:");

        grid.attach (lbl_time_frame, 0, 0);
        grid.attach (time_frame, 0, 1);
        grid.attach (calendario, 1, 0, 1, 2);
        grid.attach (cancel_button, 0, 3);
        grid.attach (acept_button, 1, 3);


        grid.set_hexpand (true);

        get_content_area ().add (grid);

    }

}