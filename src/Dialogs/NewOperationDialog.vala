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

public class TradeSim.Dialogs.NewOperationDialog : Gtk.Dialog {

    public weak TradeSim.MainWindow main_window { get; construct; }

    private Gtk.Label header_title;

    private Gtk.Label label_volume;
    private Gtk.SpinButton spin_volume;

    private Gtk.Label label_price;
    private Gtk.SpinButton spin_price;

    private Gtk.Label label_tp;
    private Gtk.SpinButton entry_tp; // En pips.
    private Gtk.SpinButton entry_tp_price; // En precio.
    private Gtk.SpinButton entry_tp_amount; // En dinero ($$$).

    private Gtk.Label label_sl;
    private Gtk.SpinButton entry_sl; // En pips.
    private Gtk.SpinButton entry_sl_price; // En precio.
    private Gtk.SpinButton entry_sl_amount; // En dinero ($$$).

    public Gtk.Button acept_button;
    public Gtk.Button cancel_button;

    public double default_lote;
    private int operation_type;

    public int op_id;
    public string op_provider_name;
    public string op_ticker_name;
    public DateTime op_datetime;

    enum Action {
        OK,
        CANCEL
    }

    public NewOperationDialog (TradeSim.MainWindow ? parent, int otype) {

        Object (
            border_width: 5,
            deletable: true,
            resizable: false,
            title: _ ("New Operation"),
            transient_for: parent,
            main_window: parent
            );

        default_lote = 100000.00;
        operation_type = otype;

        var canvas = main_window.main_layout.current_canvas;

        op_id = canvas.operations_manager.get_code_for_new_operation ();;
        op_provider_name = canvas.provider_name;
        op_ticker_name = canvas.ticker;
        op_datetime = canvas.last_candle_date;

        init ();

    }

    public void init () {

        build_content ();

        response.connect (on_response);

        destroy.connect (() => {
            main_window.dialog_new_operation_is_open = false;
        });

    }

    public void build_content () {

        int spin_width = 165;
        string provider_name = op_provider_name;
        string ticker_name = op_ticker_name;
        string time_frame = main_window.main_layout.current_canvas.time_frame;
        string titulo = provider_name + " - " + ticker_name + ", " + time_frame;
        string simulation_name = main_window.main_layout.current_canvas.simulation_name;
        string operation_code = op_id.to_string ();
        string operation_date = get_fecha (main_window.main_layout.current_canvas.last_candle_date);
        string operation_data = _ ("Code: ") + operation_code + _ (", Date: ") + operation_date;

        var body = get_content_area ();

        var header_grid = new Gtk.Grid ();
        header_title = new Gtk.Label (titulo);
        header_title.get_style_context ().add_class ("dialog-title");
        header_title.halign = Gtk.Align.START;
        header_grid.margin_start = 30;
        header_grid.margin_top = 0;
        header_grid.margin_end = 30;
        header_grid.margin_bottom = 0;

        var label_simulation = new Gtk.Label (simulation_name);
        label_simulation.halign = Gtk.Align.START;

        var label_simulation_data = new Gtk.Label (operation_data);
        label_simulation.halign = Gtk.Align.START;

        header_grid.attach (header_title, 0, 0);
        header_grid.attach (label_simulation, 0, 1);
        header_grid.attach (label_simulation_data, 0, 2);

        body.add (header_grid);

        var grid_price = new Gtk.Grid ();
        label_price = new Gtk.Label (_ ("Price:"));
        label_price.halign = Gtk.Align.START;
        label_price.margin_bottom = 7;
        spin_price = new Gtk.SpinButton.with_range (0, 9999, 0.00001);
        spin_price.halign = Gtk.Align.START;
        spin_price.hexpand = true;
        spin_price.width_request = 400;
        grid_price.attach (label_price, 0, 0);
        grid_price.attach (spin_price, 0, 1);
        grid_price.column_spacing = 12;

        var grid_volume = new Gtk.Grid ();
        label_volume = new Gtk.Label (_ ("Volume:"));
        label_volume.halign = Gtk.Align.START;
        label_volume.margin_bottom = 7;
        spin_volume = new Gtk.SpinButton.with_range (0, 10, 0.01);
        spin_volume.halign = Gtk.Align.START;
        spin_volume.hexpand = true;
        spin_volume.set_max_length (4);
        spin_volume.width_request = 400;
        spin_volume.set_max_width_chars (4);
        grid_volume.attach (label_volume, 0, 0);
        grid_volume.attach (spin_volume, 0, 1);
        grid_volume.column_spacing = 12;

        var grid_tp = new Gtk.Grid ();
        grid_tp.row_spacing = 12;
        grid_tp.column_spacing = 20;
        label_tp = new Gtk.Label (_ ("Take Profit:"));
        label_tp.halign = Gtk.Align.END;
        entry_tp = new Gtk.SpinButton.with_range (0, 99999, 10);
        entry_tp.halign = Gtk.Align.START;
        entry_tp.width_request = spin_width;
        entry_tp.hexpand = false;
        entry_tp_amount = new Gtk.SpinButton.with_range (0, 99999, 1.00);
        entry_tp_amount.halign = Gtk.Align.START;
        entry_tp_amount.width_request = spin_width;
        entry_tp_price = new Gtk.SpinButton.with_range (0, 99999, 0.00001);
        entry_tp_price.halign = Gtk.Align.START;
        entry_tp_price.width_request = spin_width;
        grid_tp.attach (new Gtk.Label (_ ("Take Profit")), 0, 0);
        grid_tp.attach (entry_tp, 0, 1);
        grid_tp.attach (entry_tp_amount, 0, 2);
        grid_tp.attach (entry_tp_price, 0, 3);

        grid_tp.attach (new Gtk.Label (_ ("Points")), 1, 1);
        grid_tp.attach (new Gtk.Label ("USD"), 1, 2);
        grid_tp.attach (new Gtk.Label (_ ("Price")), 1, 3);


        var grid_sl = new Gtk.Grid ();
        grid_sl.row_spacing = 12;
        grid_sl.column_spacing = 20;
        label_sl = new Gtk.Label (_ ("Stop Loss:"));
        label_sl.halign = Gtk.Align.END;
        entry_sl = new Gtk.SpinButton.with_range (0, 99999, 10);
        entry_sl.halign = Gtk.Align.START;
        entry_sl.width_request = spin_width;
        entry_sl.hexpand = false;
        entry_sl_amount = new Gtk.SpinButton.with_range (0, 9999, 1.00);
        entry_sl_amount.halign = Gtk.Align.START;
        entry_sl_amount.width_request = spin_width;
        entry_sl_price = new Gtk.SpinButton.with_range (0, 9999, 0.00001);
        entry_sl_price.halign = Gtk.Align.START;
        entry_sl_price.width_request = spin_width;
        grid_sl.attach (new Gtk.Label (_ ("Stop Loss")), 0, 0);
        grid_sl.attach (entry_sl, 0, 1);
        grid_sl.attach (entry_sl_amount, 0, 2);
        grid_sl.attach (entry_sl_price, 0, 3);

        // ----

        var form_grid = new Gtk.Grid ();
        form_grid.margin_start = 30;
        form_grid.margin_end = 30;
        form_grid.margin_bottom = 30;
        form_grid.margin_top = 15;
        form_grid.row_spacing = 12;
        form_grid.column_spacing = 20;

        form_grid.attach (grid_price, 0, 0, 2);
        form_grid.attach (grid_volume, 0, 1, 2);

        form_grid.attach (grid_tp, 0, 2);
        form_grid.attach (grid_sl, 1, 2);

        // Initial values.

        var price = main_window.main_layout.current_canvas.last_candle_price;

        spin_price.set_value (price);
        spin_volume.set_value (0.25);
        entry_tp.set_value (800);
        entry_tp_amount.set_value (285.50);
        entry_tp_price.set_value (1.15012);
        entry_sl.set_value (200);
        entry_sl_amount.set_value (75.23);
        entry_sl_price.set_value (1.05012);

        configure_events ();

        body.add (form_grid);

        acept_button = new Gtk.Button.with_label (_ ("Buy"));

        if (operation_type == TradeSim.Objects.OperationItem.Type.BUY) {
            acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            acept_button.set_label (_ ("Buy"));
        } else if (operation_type == TradeSim.Objects.OperationItem.Type.SELL) {
            acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            acept_button.set_label (_ ("Sell"));
        }

        cancel_button = new Gtk.Button.with_label (_ ("Cancel"));

        add_action_widget (acept_button, Action.OK);
        add_action_widget (cancel_button, Action.CANCEL);

    }

    private void configure_events () {

        if (operation_type == TradeSim.Objects.OperationItem.Type.BUY) {

            buy_update_tp_by_pips ();
            buy_update_sl_by_pips ();

            spin_price.value_changed.connect (() => {
                buy_update_tp_by_pips ();
                buy_update_sl_by_pips ();
            });

            spin_volume.value_changed.connect (() => {
                buy_update_tp_by_pips ();
                buy_update_sl_by_pips ();
            });

            entry_tp.value_changed.connect (buy_update_tp_by_pips);
            entry_tp_amount.value_changed.connect (buy_update_tp_by_amount);
            entry_tp_price.value_changed.connect (buy_update_tp_by_price);

            entry_sl.value_changed.connect (buy_update_sl_by_pips);
            entry_sl_amount.value_changed.connect (buy_update_sl_by_amount);
            entry_sl_price.value_changed.connect (buy_update_sl_by_price);

        } else if (operation_type == TradeSim.Objects.OperationItem.Type.SELL) {

            sell_update_tp_by_pips ();
            sell_update_sl_by_pips ();

            spin_price.value_changed.connect (() => {
                sell_update_tp_by_pips ();
                sell_update_sl_by_pips ();
            });

            spin_volume.value_changed.connect (() => {
                sell_update_tp_by_pips ();
                sell_update_sl_by_pips ();
            });

            entry_tp.value_changed.connect (sell_update_tp_by_pips);
            entry_tp_amount.value_changed.connect (sell_update_tp_by_amount);
            entry_tp_price.value_changed.connect (sell_update_tp_by_price);

            entry_sl.value_changed.connect (sell_update_sl_by_pips);
            entry_sl_amount.value_changed.connect (sell_update_sl_by_amount);
            entry_sl_price.value_changed.connect (sell_update_sl_by_price);
        }

    }

    private void buy_update_tp_by_amount () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_amount = entry_tp_amount.get_value ();
        double price_tp = calc_amount / operation_value + price;
        double calc_pips = (price_tp - price) * 100000;

        entry_tp_price.set_value (price_tp);
        entry_tp.set_value (calc_pips);

    }

    private void buy_update_tp_by_pips () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_costo = operation_value * price;
        double calc_pips = entry_tp.get_value ();
        double price_tp = price + calc_pips / 100000;
        double calc_profit = operation_value * price_tp;
        double calc_amount = calc_profit - calc_costo; // usd

        entry_tp_price.set_value (price_tp);
        entry_tp_amount.set_value (calc_amount);

    }

    private void buy_update_tp_by_price () {

        double price = spin_price.get_value ();
        double price_tp = entry_tp_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_pips = (price_tp - price) * 100000;
        double calc_costo = operation_value * price;
        double calc_profit = operation_value * price_tp;
        double calc_amount = calc_profit - calc_costo;

        entry_tp.set_value (calc_pips);
        entry_tp_amount.set_value (calc_amount);

    }

    private void buy_update_sl_by_price () {

        double price = spin_price.get_value ();
        double price_sl = entry_sl_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_pips = (price - price_sl) * 100000;
        double calc_costo = operation_value * price;
        double calc_profit = operation_value * price_sl;
        double calc_amount = calc_costo - calc_profit;

        entry_sl.set_value (calc_pips);
        entry_sl_amount.set_value (calc_amount);

    }

    private void buy_update_sl_by_pips () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_costo = operation_value * price;
        double calc_pips = entry_sl.get_value ();
        double price_sl = price - calc_pips / 100000;
        double calc_profit = operation_value * price_sl;
        double calc_amount = calc_costo - calc_profit; // usd

        entry_sl_price.set_value (price_sl);
        entry_sl_amount.set_value (calc_amount);

    }

    private void buy_update_sl_by_amount () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_amount = entry_sl_amount.get_value ();
        double price_sl = price - calc_amount / operation_value;
        double calc_pips = (price - price_sl) * 100000;

        entry_sl_price.set_value (price_sl);
        entry_sl.set_value (calc_pips);

    }

    // VENTA

    private void sell_update_sl_by_amount () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_amount = entry_sl_amount.get_value ();
        double price_sl = calc_amount / operation_value + price;
        double calc_pips = (price_sl - price) * 100000;

        entry_sl_price.set_value (price_sl);
        entry_sl.set_value (calc_pips);

    }

    private void sell_update_sl_by_pips () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_costo = operation_value * price;
        double calc_pips = entry_sl.get_value ();
        double price_sl = price + calc_pips / 100000;
        double calc_profit = operation_value * price_sl;
        double calc_amount = calc_profit - calc_costo; // usd

        entry_sl_price.set_value (price_sl);
        entry_sl_amount.set_value (calc_amount);

    }

    private void sell_update_sl_by_price () {

        double price = spin_price.get_value ();
        double price_sl = entry_sl_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_pips = (price_sl - price) * 100000;
        double calc_costo = operation_value * price;
        double calc_profit = operation_value * price_sl;
        double calc_amount = calc_profit - calc_costo;

        entry_sl.set_value (calc_pips);
        entry_sl_amount.set_value (calc_amount);

    }

    private void sell_update_tp_by_price () {

        double price = spin_price.get_value ();
        double price_tp = entry_tp_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_pips = (price - price_tp) * 100000;
        double calc_costo = operation_value * price;
        double calc_profit = operation_value * price_tp;
        double calc_amount = calc_costo - calc_profit;

        entry_tp.set_value (calc_pips);
        entry_tp_amount.set_value (calc_amount);

    }

    private void sell_update_tp_by_pips () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_costo = operation_value * price;
        double calc_pips = entry_tp.get_value ();
        double price_tp = price - calc_pips / 100000;
        double calc_profit = operation_value * price_tp;
        double calc_amount = calc_costo - calc_profit; // usd

        entry_tp_price.set_value (price_tp);
        entry_tp_amount.set_value (calc_amount);

    }

    private void sell_update_tp_by_amount () {

        double price = spin_price.get_value ();
        double volume = spin_volume.get_value ();
        double operation_value = volume * default_lote;
        double calc_amount = entry_tp_amount.get_value ();
        double price_tp = price - calc_amount / operation_value;
        double calc_pips = (price - price_tp) * 100000;

        entry_tp_price.set_value (price_tp);
        entry_tp.set_value (calc_pips);

    }

    private void on_response (Gtk.Dialog source, int response_id) {

        if (response_id == Action.OK) {

            TradeSim.Dialogs.NewOperationDialog dialogo = ((TradeSim.Dialogs.NewOperationDialog)source);

            var objetivo = dialogo.main_window.main_layout;

            objetivo.add_operation (op_id
                                    , op_provider_name
                                    , op_ticker_name
                                    , op_datetime
                                    , TradeSim.Objects.OperationItem.State.OPEN
                                    , ""
                                    , spin_volume.get_value ()
                                    , spin_price.get_value ()
                                    , entry_tp_price.get_value ()
                                    , entry_sl_price.get_value ()
                                    , operation_type);

            destroy ();

        } else if (response_id == Action.CANCEL) {
            destroy ();
        }

        destroy ();
    }

}
