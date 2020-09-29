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

public class TradeSim.Widgets.DrawingsPanel : Gtk.Grid{

    public weak TradeSim.MainWindow main_window;

    public Gtk.Label label_title;
    public Gtk.ScrolledWindow scroll_drawings;
    public Gtk.Grid grid_data;

    public DrawingsPanel(TradeSim.MainWindow _window){

        main_window = _window;

        init();

    }

    public void init(){

        label_title = new Gtk.Label("Drawings Panel");
        scroll_drawings = new Gtk.ScrolledWindow (null, null);
        scroll_drawings.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scroll_drawings.get_style_context ().add_class ("scrolled-window-drawings");

        grid_data = new Gtk.Grid();

        label_title.vexpand = false;
        label_title.hexpand = true;
        label_title.get_style_context().add_class("h4");

        scroll_drawings.hexpand = true;
        scroll_drawings.vexpand = true;

        attach(label_title, 0, 0);
        attach(scroll_drawings, 0, 1);

        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Dibujo 1", 0, "scrolled-window-drawings-row"), 0, 0);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Dibujo 2", 1, "scrolled-window-drawings-row-alternate"), 0, 1);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Dibujo 3", 2, "scrolled-window-drawings-row"), 0, 2);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Dibujo 4 - Test", 3, "scrolled-window-drawings-row-alternate"), 0, 3);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Object7", 3, "scrolled-window-drawings-row"), 0, 4);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Resistencia 1", 3, "scrolled-window-drawings-row-alternate"), 0, 5);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Fibo de prueba", 3, "scrolled-window-drawings-row"), 0, 6);
        grid_data.attach(new TradeSim.Widgets.DrawingsPanelItem("Test", 3, "scrolled-window-drawings-row-alternate"), 0, 7);

        scroll_drawings.add(grid_data);

    }
}