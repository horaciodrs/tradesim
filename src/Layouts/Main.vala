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

public class TradeSim.Layouts.Main : Gtk.Box {

    public weak TradeSim.MainWindow main_window { get; construct; }

    public Gtk.Paned pane_top;
    public Gtk.Paned pane_left;

    public Gtk.Notebook nb_chart_container;

    public TradeSim.Widgets.CanvasContainer canvas_container;

    

    /*
        Goo.Canvas VS Gtk.DrawingArea (INVESTIGAR)

        Goo.Canvas
        public void render (Context cr, CanvasBounds? bounds, double scale) 

        Cairo.Context
    */


    public Main (TradeSim.MainWindow window) {
        Object (
            main_window: window
            );
    }

    construct {

        canvas_container = new TradeSim.Widgets.CanvasContainer(main_window);

        nb_chart_container = new Gtk.Notebook ();

        nb_chart_container.set_show_border(false);

        nb_chart_container.append_page (canvas_container, new Gtk.Label ("EURUSD, M5"));
        nb_chart_container.append_page (new Gtk.Label ("Contenido del grafico USDJPY"), new Gtk.Label ("USDJPY, M5"));

        pane_top = new Gtk.Paned (Gtk.Orientation.VERTICAL);
        pane_left = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

        pane_left.pack1 (new Gtk.Label ("Hola"), true, true);
        pane_left.pack2 (nb_chart_container, true, true);

        pane_top.pack1 (pane_left, true, false);
        pane_top.pack2 (new Gtk.Label ("Bottom Bar"), true, true);

        pack_start (pane_top, true, true, 1);

    }
}