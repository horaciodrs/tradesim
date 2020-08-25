/*
 * Copyright (c) 2020-2020 horaciodrs (https://github.com/horaciodrs/TradeSim)
 *
 * This file is part of TradeSim.
 *
 * TradeSim is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * TradeSim is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with Akira. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Horacio Daniel Ros <horaciodrs@gmail.com>
 */

public class TradeSim.MainWindow : Gtk.ApplicationWindow {

    public TradeSim.Layouts.HeaderBar headerbar;
    public TradeSim.Layouts.Main main_layout;

    public MainWindow (TradeSim.Application trade_sim_app) {
        Object (
            application: trade_sim_app
            );
    }

    construct {
        // inicializacion de la ventana...

        headerbar = new TradeSim.Layouts.HeaderBar (this);
        main_layout = new TradeSim.Layouts.Main (this);

        set_titlebar (headerbar);

        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_path ("/usr/share/com.github.horaciodrs.TradeSim/stylesheet.css");

        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );



        add (main_layout);

        show_all ();
    }

}
