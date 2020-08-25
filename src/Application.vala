public class TradeSim.Application : Gtk.Application {

    public Application() {
        Object (
            application_id: "com.github.horaciodrs.TradeSim",
            flags: GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
    
        var WindowTradeSim = new TradeSim.MainWindow (this);
        
        Gtk.Settings.get_default ().set_property ("gtk-icon-theme-name", "elementary");
        Gtk.Settings.get_default ().set_property ("gtk-theme-name", "elementary");
        
        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/horaciodrs/TradeSim");

        add_window (WindowTradeSim);

    }

}
