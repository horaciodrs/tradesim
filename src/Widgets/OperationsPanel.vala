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

public class TradeSim.Widgets.OperationsPanel : Gtk.Grid {

    public weak TradeSim.MainWindow main_window;

    private Gtk.Label label_initial_balance;
    private Gtk.Label label_current_balance;
    private Gtk.Label label_profit;

    private Gtk.Label label_initial_balance_value;
    private Gtk.Label label_current_balance_value;
    private Gtk.Label label_profit_value;

    private Gtk.ScrolledWindow scroll_prviders;
    private Gtk.TreeStore list_store_operations;
    private Gtk.TreeIter add_iter_operations;
    private Gtk.TreeView tree_view_operations;

    private double inicial_balance;
    private double balance;
    private double global_profit;

    //public TradeSim.Services.QuotesManager qm;

    public enum OperationColumns {
          ID
        , ICON_STATE
        , PROVIDER
        , TICKER
        , DATE
        , TYPE
        , STATE
        , OBSERVATIONS
        , VOLUME
        , BUY_PRICE
        , TP_PRICE
        , SL_PRICE
        , PROFIT
        , BTN_CLOSE
        , FOREGROUND
        , N_COLUMNS
    }

    public OperationsPanel (TradeSim.MainWindow window) {

        main_window = window;

    }

    construct {

        //qm = new TradeSim.Services.QuotesManager ();

        tree_view_operations = new Gtk.TreeView ();

        configure_operations ();

        attach (scroll_prviders, 0, 0, 6);
        attach (label_initial_balance, 0, 1);
        attach (label_initial_balance_value, 1, 1);
        attach (label_current_balance, 2, 1);
        attach (label_current_balance_value, 3, 1);
        attach (label_profit, 4, 1);
        attach (label_profit_value, 5, 1);

    }

    public void configure_operations () {

        scroll_prviders = new Gtk.ScrolledWindow (null, null);
        scroll_prviders.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_operations = new Gtk.TreeStore (OperationColumns.N_COLUMNS
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string)
                                                   , typeof (string));
        add_iter_operations = Gtk.TreeIter ();

        tree_view_operations = new Gtk.TreeView ();

        tree_view_operations.set_model (list_store_operations);

        Gtk.CellRendererPixbuf icon_cell = new Gtk.CellRendererPixbuf ();
        Gtk.CellRendererText id_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText provider_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText ticker_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText state_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText observations_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText date_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText type_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText volume_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText buy_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText tp_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText stop_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText profit_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererPixbuf close_cell = new Gtk.CellRendererPixbuf ();
        Gtk.CellRendererText color_cell = new Gtk.CellRendererText ();

        //close_cell.

        tree_view_operations.set_activate_on_single_click(true);

        tree_view_operations.row_activated.connect((path, column) =>{

            if(column.get_title() == " "){

                Gtk.TreeIter iter;
                GLib.Value code;
                list_store_operations.get_iter(out iter, path);
                list_store_operations.get_value (iter, TradeSim.Widgets.OperationsPanel.OperationColumns.ID, out code);

                var canvas = main_window.main_layout.current_canvas;
                var price = canvas.last_candle_price;
                var ops = canvas.operations_manager;

                ops.close_operation_by_id(int.parse(code.get_string()), price);

                update_operations();

            }

        });

        volume_cell.xalign = 1;
        buy_cell.xalign = 1;
        tp_cell.xalign = 1;
        stop_cell.xalign = 1;
        profit_cell.xalign = 1;

        icon_cell.xalign = (float) 0;

        tree_view_operations.insert_column_with_attributes (-1, "", icon_cell, "icon_name", OperationColumns.ICON_STATE, null);
        tree_view_operations.insert_column_with_attributes (-1, "Code", id_cell, "text", OperationColumns.ID, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Provider", provider_cell, "text", OperationColumns.PROVIDER, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Ticker", ticker_cell, "text", OperationColumns.TICKER, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Date Time", date_cell, "text", OperationColumns.DATE, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Type", type_cell, "text", OperationColumns.TYPE, "foreground", OperationColumns.FOREGROUND, null);

        tree_view_operations.insert_column_with_attributes (-1, "State", state_cell, "text", OperationColumns.STATE, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Observations", observations_cell, "text", OperationColumns.OBSERVATIONS, "foreground", OperationColumns.FOREGROUND, null);

        tree_view_operations.insert_column_with_attributes (-1, "Volume", volume_cell, "text", OperationColumns.VOLUME, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Buy/Sell price", buy_cell, "text", OperationColumns.BUY_PRICE, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Take Proffit", tp_cell, "text", OperationColumns.TP_PRICE, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Stop Loss", stop_cell, "text", OperationColumns.SL_PRICE, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, "Proffit/Loss", profit_cell, "text", OperationColumns.PROFIT, "foreground", OperationColumns.FOREGROUND, null);
        tree_view_operations.insert_column_with_attributes (-1, " ", close_cell, "icon_name", OperationColumns.BTN_CLOSE, null);
        tree_view_operations.insert_column_with_attributes (-1, "", color_cell, "text", OperationColumns.FOREGROUND, null);

        tree_view_operations.get_column (OperationColumns.OBSERVATIONS).set_expand (true);

        tree_view_operations.get_column (OperationColumns.FOREGROUND).set_visible (false);

        scroll_prviders.get_style_context ().add_class ("scrolled-window-data");

        scroll_prviders.add (tree_view_operations);
        scroll_prviders.set_vexpand (true);
        scroll_prviders.set_hexpand (true);

        label_initial_balance = new Gtk.Label("Initial Balance:");
        label_current_balance = new Gtk.Label("Current Balance:");
        label_profit = new Gtk.Label("Profit:");

        label_initial_balance_value = new Gtk.Label("$0.00");
        label_current_balance_value = new Gtk.Label("$0.00");
        label_profit_value = new Gtk.Label("$0.00");

        label_initial_balance.get_style_context().add_class("h4");
        label_current_balance.get_style_context().add_class("h4");
        label_profit.get_style_context().add_class("h4");

        label_initial_balance.halign = Gtk.Align.END;
        label_current_balance.halign = Gtk.Align.END;
        label_profit.halign = Gtk.Align.END;

        label_initial_balance_value.halign = Gtk.Align.END;
        label_current_balance_value.halign = Gtk.Align.END;
        label_profit_value.halign = Gtk.Align.END;

        label_initial_balance.hexpand = true;
        label_current_balance.hexpand = false;
        label_profit.hexpand = false;

        label_initial_balance_value.hexpand = false;
        label_current_balance_value.hexpand = false;
        label_profit_value.hexpand = false;

        label_current_balance.width_request = 1;
        label_profit.width_request = 1;
        label_initial_balance_value.width_request = 200;
        label_current_balance_value.width_request = 200;
        label_profit_value.width_request = 200;

        /*label_initial_balance_value.
        label_current_balance_value.
        label_profit_value.*/

    }

    public void update_bottom_info(){

        inicial_balance = main_window.main_layout.current_canvas.simulation_initial_balance;

        balance = inicial_balance + global_profit;

        label_initial_balance_value.set_text("$" + get_money(inicial_balance * 1.00));
        label_current_balance_value.set_text("$" + get_money(balance * 1.00));
        label_profit_value.set_text("$" + get_money(global_profit * 1.00));
        
    }

    public void update_operations_profit () {

        var canvas = main_window.main_layout.current_canvas;
        var ops = canvas.operations_manager;
        bool seguir;

        if (ops.operations.length <= 0) {
            return;
        }

        Gtk.TreeIter row;
        GLib.Value cell_value;
        GLib.Value cell_code;
        GLib.Value cell_icon;
        GLib.Value cell_color;
        GLib.Value cell_type;
        GLib.Value cell_close;
        GLib.Value cell_state;

        seguir = list_store_operations.get_iter_first (out row);

        list_store_operations.get_value (row, OperationColumns.ICON_STATE, out cell_icon);
        list_store_operations.get_value (row, OperationColumns.ID, out cell_code);
        list_store_operations.get_value (row, OperationColumns.PROFIT, out cell_value);
        list_store_operations.get_value (row, OperationColumns.FOREGROUND, out cell_color);
        list_store_operations.get_value (row, OperationColumns.TYPE, out cell_type);
        list_store_operations.get_value (row, OperationColumns.BTN_CLOSE, out cell_close);
        list_store_operations.get_value (row, OperationColumns.STATE, out cell_state);

        global_profit = 0;

        while (seguir) {

            var op_id = int.parse (cell_code.get_string ());
            var price = canvas.last_candle_price;
            var profit = ops.get_operation_profit_by_id (op_id, price);

            global_profit = global_profit + profit;

            cell_value.set_string (get_money (profit)); // obtener_profit_por

            if(profit>0){
                //if(cell_type.get_string() == "Buy"){
                    cell_color.set_string("green");
                    cell_icon.set_string("view-sort-descending");
                //}else{
                  //  cell_color.set_string("red");
                   // cell_icon.set_string("view-sort-ascending");
                //}
                
            }else{
                //if(cell_type.get_string() == "Buy"){
                    cell_color.set_string("red");
                    cell_icon.set_string("view-sort-ascending");
                //}else{
                  //  cell_color.set_string("green");
                   // cell_icon.set_string("view-sort-descending");
                //}
            }

            if(cell_state.get_string() == "Closed"){
                cell_close.set_string("");
                cell_color.set_string("black");
            }

            list_store_operations.set_value (row, OperationColumns.PROFIT, cell_value);
            list_store_operations.set_value (row, OperationColumns.ICON_STATE, cell_icon);
            list_store_operations.set_value (row, OperationColumns.FOREGROUND, cell_color);
            list_store_operations.set_value (row, OperationColumns.BTN_CLOSE, cell_close);

            seguir = list_store_operations.iter_next (ref row);

            if (seguir) {
                list_store_operations.get_value (row, OperationColumns.ICON_STATE, out cell_icon);
                list_store_operations.get_value (row, OperationColumns.ID, out cell_code);
                list_store_operations.get_value (row, OperationColumns.PROFIT, out cell_value);
                list_store_operations.get_value (row, OperationColumns.FOREGROUND, out cell_color);
                list_store_operations.get_value (row, OperationColumns.TYPE, out cell_type);
                list_store_operations.get_value (row, OperationColumns.BTN_CLOSE, out cell_close);
                list_store_operations.get_value (row, OperationColumns.STATE, out cell_state);
            }

        }

        tree_view_operations.set_model (list_store_operations);

        update_bottom_info();

    }

    public void update_operations () {

        list_store_operations.clear ();

        var canvas = main_window.main_layout.current_canvas;
        var ops = canvas.operations_manager.operations;

        if (canvas != null) {

            for (int i = 0 ; i < ops.length ; i++) {

                // print("d. ops.length:" + ops.length.to_string() + "\n");
                list_store_operations.append (out add_iter_operations, null);
                list_store_operations.set (add_iter_operations
                                           , OperationColumns.ICON_STATE, "list-add"
                                           , OperationColumns.ID, ops.index (i).id.to_string ()
                                           , OperationColumns.PROVIDER, ops.index (i).provider_name
                                           , OperationColumns.TICKER, ops.index (i).ticker_name
                                           , OperationColumns.DATE, get_fecha (ops.index (i).operation_date)
                                           , OperationColumns.TYPE, get_operation_type_desc (ops.index (i).type_op)
                                           , OperationColumns.STATE, get_operation_state_desc (ops.index (i).state)
                                           , OperationColumns.OBSERVATIONS, "Obs..."
                                           , OperationColumns.VOLUME, get_money (ops.index (i).volume)
                                           , OperationColumns.BUY_PRICE, get_money (ops.index (i).price, 5)
                                           , OperationColumns.TP_PRICE, get_money (ops.index (i).tp, 5)
                                           , OperationColumns.SL_PRICE, get_money (ops.index (i).sl, 5)
                                           , OperationColumns.PROFIT, "-1"
                                           , OperationColumns.BTN_CLOSE, "window-close"
                                           , OperationColumns.FOREGROUND, "black"
                                           , -1);
            }

        }

        update_operations_profit ();

    }

    public string get_operation_type_desc (int _type_op) {

        if (_type_op == TradeSim.Objects.OperationItem.Type.SELL) {
            return "Sell";
        } else if (_type_op == TradeSim.Objects.OperationItem.Type.BUY) {
            return "Buy";
        }

        return "Undefined";
    }

    public string get_operation_state_desc (int _type_op) {

        if (_type_op == TradeSim.Objects.OperationItem.State.OPEN) {
            return "Open";
        } else if (_type_op == TradeSim.Objects.OperationItem.State.CLOSED) {
            return "Closed";
        }

        return "Undefined";
    }

}