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

    // voy a modificar este archivo para crear una nueva seccion en el panel de la izquierda
    // que me permita incorporar una seccion para editar los objetos dibujados.

    public weak TradeSim.MainWindow main_window { get; construct; }

    public TradeSim.Layouts.Welcome welcome_widget;

    public Gtk.Paned pane_top;
    public Gtk.Paned pane_left;
    public Gtk.Paned pane_left_vertical;

    public Gtk.Notebook nb_chart_container;

    public TradeSim.Widgets.ProvidersPanel providers_panel;
    public TradeSim.Widgets.OperationsPanel operations_panel;
    public TradeSim.Widgets.DrawingsPanel drawings_panel;

    public TradeSim.Widgets.Canvas current_canvas;


    public Main (TradeSim.MainWindow window) {

        Object (
            main_window: window
            );

    }

    construct {

        providers_panel = new TradeSim.Widgets.ProvidersPanel (main_window);
        operations_panel = new TradeSim.Widgets.OperationsPanel (main_window);
        drawings_panel = new TradeSim.Widgets.DrawingsPanel (main_window);
        welcome_widget = new TradeSim.Layouts.Welcome (main_window);

        nb_chart_container = new Gtk.Notebook ();

        nb_chart_container.set_show_border (false);

        nb_chart_container.append_page (welcome_widget, new Gtk.Label (_ ("Welcome to TradeSim")));

        nb_chart_container.switch_page.connect (on_change_canvas_focus);
        nb_chart_container.page_removed.connect (on_page_removed);

        pane_top = new Gtk.Paned (Gtk.Orientation.VERTICAL);
        pane_left = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        pane_left_vertical = new Gtk.Paned (Gtk.Orientation.VERTICAL);

        pane_left_vertical.pack1 (providers_panel, true, true);
        pane_left_vertical.pack2 (drawings_panel, true, true);

        pane_left.pack1 (pane_left_vertical, true, true);
        pane_left.pack2 (nb_chart_container, true, true);

        pane_top.pack1 (pane_left, true, false);
        pane_top.pack2 (operations_panel, true, true);

        pack_start (pane_top, true, true, 1);

    }

    public bool check_unsaved_tab_before_close () {

        int pages = nb_chart_container.get_n_pages ();

        for(int i=0; i<pages; i++){
            var item = nb_chart_container.get_nth_page (i);
            if (item.get_type () == typeof (TradeSim.Widgets.CanvasContainer)){
                var cb_cont = ((TradeSim.Widgets.CanvasContainer) item);
                if(cb_cont.chart_canvas.need_save){
                    if(confirm(_ ("There are unsaved simulation/s. ¿Are you sure you want to exit?"), main_window, Gtk.MessageType.QUESTION)){
                        continue;
                    }else {
                        return true;
                    }
                }
            }
        }

        return false;

    }

    public void on_change_canvas_focus (Gtk.Notebook nb, Gtk.Widget tab, uint order) {

        if (current_canvas != null) {

            if (current_canvas.get_type () == typeof (TradeSim.Widgets.Canvas)) {
                // Si en la pestaña anterior hay un canvas...
                current_canvas.stop_simulation ();
            }

        }

        if (tab.get_type () == typeof (TradeSim.Widgets.CanvasContainer)) {

            var container = ((TradeSim.Widgets.CanvasContainer)tab);

            drawings_panel.delete_all ();

            current_canvas = container.chart_canvas;

            main_window.headerbar.set_subtitle (current_canvas.simulation_name);

            drawings_panel.reload_objects ();
            operations_panel.update_operations ();
            operations_panel.update_bottom_info ();

            main_window.headerbar.zoom.zoom_set (current_canvas.get_zoom_factor ());

        } else if (tab.get_type () == typeof (TradeSim.Layouts.Welcome)) {
            main_window.headerbar.set_subtitle (_ ("The Linux Trading Simulator"));
            drawings_panel.delete_all ();
            operations_panel.delete_operations ();
        }

    }

    public void write_file (string path) {

        print ("path:" + path + "\n");

        Xml.TextWriter writer = new Xml.TextWriter.filename (path, false);

        if (writer == null) {
            print ("Error: Xml.TextWriter.filename () == null\n");
            return;
        }

        try {
            writer.start_document ("1.0", "utf-8");
            writer.set_indent (true);
            current_canvas.write_file (writer);
            writer.flush ();
            current_canvas.need_save = false;
        } catch (Error e) {
            print ("Error: %s\n", e.message);
        }

    }

    public void add_canvas (string ? provider_name, string ? ticker_name, string time_frame) {

        if (provider_name == null) {
            return;
        }

        if (ticker_name == null) {
            return;
        }

        var new_chart_dialog = new TradeSim.Dialogs.NewChartDialog (main_window, provider_name, ticker_name);

        new_chart_dialog.show_all ();
        new_chart_dialog.present ();

    }

    public void new_chart_from_file (string file_name) {

        string provider_name = "";
        string ticker_name = "";
        string time_frame_name = "";
        string _simulation_name = "";
        double _simulation_initial_balance = 0.00;
        DateTime _initial_date;

        try {

            var simulation_file = new TradeSim.Services.FileReader (file_name);

            simulation_file.read ();

            provider_name = simulation_file.canvas_data.provider_name;
            ticker_name = simulation_file.canvas_data.ticker;
            time_frame_name = simulation_file.canvas_data.time_frame;
            _simulation_name = simulation_file.canvas_data.simulation_name;
            _simulation_initial_balance = simulation_file.canvas_data.simulation_initial_balance;
            _initial_date = simulation_file.canvas_data.date_inicial;

            new_chart (provider_name, ticker_name, time_frame_name, _simulation_name, _simulation_initial_balance, _initial_date, file_name);

        } catch (Error e) {
            return;
        }

    }

    public void new_chart (string provider_name, string ticker_name, string time_frame_name, string _simulation_name, double _simulation_initial_balance, DateTime _initial_date, string ? file_name = null) {

        int position = nb_chart_container.get_n_pages ();

        var grid_tab = new Gtk.Grid ();
        var label_title = new Gtk.Label (provider_name + " - " + ticker_name + ", " + time_frame_name);
        var button_close = new Gtk.Button.from_icon_name ("window-close", Gtk.IconSize.SMALL_TOOLBAR);

        button_close.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        grid_tab.attach (label_title, 0, 0);
        grid_tab.attach (button_close, 1, 0);

        grid_tab.show_all ();

        var canvas_container = new TradeSim.Widgets.CanvasContainer (main_window, provider_name, ticker_name, time_frame_name, _simulation_name, _simulation_initial_balance, _initial_date, file_name);

        canvas_container.set_page (position);

        button_close.clicked.connect (() => {
            close_tab (canvas_container);
        });

        nb_chart_container.insert_page (canvas_container, grid_tab, position);

        nb_chart_container.show_all ();

        nb_chart_container.set_current_page (position);

        current_canvas = canvas_container.chart_canvas;

    }

    public void close_tab (TradeSim.Widgets.CanvasContainer cc) {

        if (current_canvas.need_save == true) {
            if (confirm (_ ("Are you sure you want to exit without save changes?"), main_window, Gtk.MessageType.QUESTION)) {
                nb_chart_container.remove_page (cc.get_page ());
            }
        } else {
            nb_chart_container.remove_page (cc.get_page ());
        }

    }

    public void on_page_removed (Gtk.Widget child, uint page_num) {

        for (int i = 0 ; i < nb_chart_container.get_n_pages () ; i++) {
            if (i > 0) {
                var item = (TradeSim.Widgets.CanvasContainer)nb_chart_container.get_nth_page (i);
                item.set_page (i);
            }
        }
    }

    public void add_operation (int _id, string _provider_name, string _ticker_name
                               , DateTime _date_time, int _state, string _obs
                               , double _volume, double _price, double _tp_price
                               , double _sl_price, int _operation_type) {

        var new_operation = new TradeSim.Objects.OperationItem (
            _id
            , _provider_name
            , _ticker_name
            , _date_time
            , _state
            , _obs
            , _volume
            , _price
            , _tp_price
            , _sl_price
            , _operation_type);

        current_canvas.operations_manager.add_operation (new_operation);

        current_canvas.draw_operation_info (new_operation);

        current_canvas.need_save = true;

        operations_panel.update_operations ();

    }

}
