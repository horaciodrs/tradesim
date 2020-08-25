public class TradeSim.Widgets.ButtonImage: Gtk.Image {

    private string icon;
    private Gtk.IconSize size;

    public ButtonImage (string icon_name, Gtk.IconSize icon_size = Gtk.IconSize.LARGE_TOOLBAR) {
        icon = icon_name;
        size = icon_size;
        margin = 0;

        set_from_icon_name (icon, size);
    }
    
}

