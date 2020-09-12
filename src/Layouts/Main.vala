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

    public TradeSim.Layouts.Welcome welcome_widget;

    public Gtk.Paned pane_top;
    public Gtk.Paned pane_left;

    public Gtk.Notebook nb_chart_container;

    public TradeSim.Widgets.CanvasContainer canvas_container;
    public TradeSim.Widgets.ProvidersPanel providers_panel;
    public TradeSim.Widgets.OperationsPanel operations_panel;

    public TradeSim.Widgets.Canvas current_canvas;


    public Main (TradeSim.MainWindow window) {

        Object (
            main_window: window
            );


    }

    construct {

        providers_panel = new TradeSim.Widgets.ProvidersPanel (main_window);
        operations_panel = new TradeSim.Widgets.OperationsPanel (main_window);
        welcome_widget = new TradeSim.Layouts.Welcome(main_window);

        // canvas_container = new TradeSim.Widgets.CanvasContainer(main_window);

        nb_chart_container = new Gtk.Notebook ();

        nb_chart_container.set_show_border (false);

        nb_chart_container.append_page (welcome_widget, new Gtk.Label ("Welcome to TradeSim"));

        pane_top = new Gtk.Paned (Gtk.Orientation.VERTICAL);
        pane_left = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

        pane_left.pack1 (providers_panel, true, true);
        pane_left.pack2 (nb_chart_container, true, true);

        pane_top.pack1 (pane_left, true, false);
        pane_top.pack2 (operations_panel, true, true);

        pack_start (pane_top, true, true, 1);

    }

    public void add_canvas (string provider_name, string ticker_name, string time_frame) {


        var new_chart_dialog = new TradeSim.Dialogs.NewChartDialog (main_window, provider_name, ticker_name);

        new_chart_dialog.show_all ();
        new_chart_dialog.present ();


    }

    public void new_chart(string provider_name, string ticker_name, string time_frame_name){

        canvas_container = new TradeSim.Widgets.CanvasContainer (main_window, provider_name, ticker_name, time_frame_name);

        nb_chart_container.insert_page (canvas_container, new Gtk.Label (provider_name + " - " + ticker_name + ", " + time_frame_name), 0);

        nb_chart_container.show_all ();

        current_canvas = canvas_container.chart_canvas;

    }

}