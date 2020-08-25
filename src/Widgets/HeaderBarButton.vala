public class TradeSim.Widgets.HeaderBarButton : Gtk.Grid {

	public weak TradeSim.MainWindow mainWindow;
	public Gtk.Button button;
	private Gtk.Label label_btn;
	public TradeSim.Widgets.ButtonImage image;
	
	public HeaderBarButton (TradeSim.MainWindow window, string icon_name, string name, string[]? accels = null){
		
		mainWindow = window;
		
		label_btn = new Gtk.Label (name);
		label_btn.get_style_context ().add_class ("headerbar-label");
		
		button = new Gtk.Button ();
        button.can_focus = false;
        button.halign = Gtk.Align.CENTER;
        button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        button.tooltip_markup = Granite.markup_accel_tooltip (accels, name);
        
        image = new ButtonImage (icon_name);
        button.add (image);

        attach (button, 0, 0, 1, 1);
        attach (label_btn, 0, 1, 1, 1);
		
	}
}
