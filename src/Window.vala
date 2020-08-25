public class TradeSim.MainWindow : Gtk.ApplicationWindow {

	public TradeSim.Layouts.HeaderBar headerbar;
	public TradeSim.Layouts.Main main_layout;

	public MainWindow (TradeSim.Application trade_sim_app) {
		Object (
			application: trade_sim_app
		);
	}
	
	construct {
		//inicializacion de la ventana...
		
		headerbar = new TradeSim.Layouts.HeaderBar (this);
		main_layout = new TradeSim.Layouts.Main (this);
		
		set_titlebar (headerbar);

		var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_path ("/usr/share/com.github.horaciodrs.TradeSim/stylesheet.css");

        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);
		
		

		add(main_layout);
		
		show_all();
	}
	
}
