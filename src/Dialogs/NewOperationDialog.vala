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

    private Gtk.Label label_id;
    private Gtk.Label label_id_value;

    private Gtk.Label label_date;
    private Gtk.Label label_date_value;

    private Gtk.Label label_volume;
    private Gtk.SpinButton spin_volume;
    private Gtk.Label label_volume_amount;

    private Gtk.Label label_price;
    private Gtk.SpinButton spin_price;

    private Gtk.Label label_tp;
    private Gtk.SpinButton entry_tp; //En pips.
    private Gtk.SpinButton entry_tp_price; //En precio.
    private Gtk.SpinButton entry_tp_amount; //En dinero ($$$).

    private Gtk.Label label_sl;
    private Gtk.SpinButton entry_sl; //En pips.
    private Gtk.SpinButton entry_sl_price; //En precio.
    private Gtk.SpinButton entry_sl_amount; //En dinero ($$$).

    public Gtk.Button acept_button;
    public Gtk.Button cancel_button;

    enum Action {
        OK,
        CANCEL
    }

    public NewOperationDialog (TradeSim.MainWindow ? parent) {
        Object (
            border_width: 5,
            deletable: false,
            resizable: false,
            title: "New Operation",
            transient_for: parent,
            main_window: parent
            );

        init ();

    }

    public void init(){

        build_content();

    }

    public void build_content(){

        int spin_width = 165;

        var body = get_content_area ();

        var header_grid = new Gtk.Grid ();
        header_title = new Gtk.Label("TRADESIM - EURUSD, H1");
        header_title.get_style_context().add_class("dialog-title");
        header_grid.margin_start = 30;
        header_grid.margin_top = 0;
        header_grid.margin_end = 30;
        header_grid.margin_bottom = 10;
        header_grid.attach (header_title, 0, 3, 2);

        body.add (header_grid);

        

        label_id = new Gtk.Label("Code:");
        label_id.halign = Gtk.Align.END;
        label_id_value = new Gtk.Label("1");
        label_id_value.halign = Gtk.Align.START;

        label_date = new Gtk.Label("Date:");
        label_date.halign = Gtk.Align.END;
        label_date_value = new Gtk.Label("21 Jan 2011 at 10:04am.");
        label_date_value.halign = Gtk.Align.START;

        
        var grid_price = new Gtk.Grid();
        label_price = new Gtk.Label("Price:");
        label_price.halign = Gtk.Align.START;
        spin_price = new Gtk.SpinButton.with_range(0,10,0.01);
        spin_price.halign = Gtk.Align.START;
        spin_price.hexpand = true;
        spin_price.set_max_length(4);
        spin_price.width_request = 400;
        spin_price.set_max_width_chars(4);
        grid_price.attach(label_price, 0, 0);
        grid_price.attach(spin_price, 0, 1);
        grid_price.column_spacing = 12;

        var grid_volume = new Gtk.Grid();
        label_volume = new Gtk.Label("Volume:");
        label_volume.halign = Gtk.Align.START;
        spin_volume = new Gtk.SpinButton.with_range(0,10,0.01);
        spin_volume.halign = Gtk.Align.START;
        spin_volume.hexpand = true;
        spin_volume.set_max_length(4);
        spin_volume.width_request = 400;
        spin_volume.set_max_width_chars(4);
        grid_volume.attach(label_volume, 0, 0);
        grid_volume.attach(spin_volume, 0, 1);
        grid_volume.column_spacing = 12;

        var grid_tp = new Gtk.Grid();
        grid_tp.row_spacing = 12;
        grid_tp.column_spacing = 20;
        label_tp = new Gtk.Label("Take Profit:");
        label_tp.halign = Gtk.Align.END;
        entry_tp = new Gtk.SpinButton.with_range(0, 99999, 1);
        entry_tp.halign = Gtk.Align.START;
        entry_tp.width_request = spin_width;
        entry_tp.hexpand = false;
        entry_tp.set_max_length(4);
        entry_tp.set_max_width_chars(4);
        entry_tp_amount = new Gtk.SpinButton.with_range(0, 99999, 1);
        entry_tp_amount.halign = Gtk.Align.START;
        entry_tp_amount.width_request = spin_width;
        entry_tp_price = new Gtk.SpinButton.with_range(0, 99999, 1);
        entry_tp_price.halign = Gtk.Align.START;
        entry_tp_price.width_request = spin_width;
        grid_tp.attach(new Gtk.Label("Take Profit"), 0, 0);
        grid_tp.attach(entry_tp, 0, 1);
        grid_tp.attach(entry_tp_amount, 0, 2);
        grid_tp.attach(entry_tp_price, 0, 3);

        grid_tp.attach(new Gtk.Label("Pips"), 1, 1);
        grid_tp.attach(new Gtk.Label("Price"), 1, 2);
        grid_tp.attach(new Gtk.Label("USD"), 1, 3);

        //----

        var grid_sl = new Gtk.Grid();
        grid_sl.row_spacing = 12;
        grid_sl.column_spacing = 20;
        label_sl = new Gtk.Label("Stop Loss:");
        label_sl.halign = Gtk.Align.END;
        entry_sl = new Gtk.SpinButton.with_range(0, 99999, 1);
        entry_sl.halign = Gtk.Align.START;
        entry_sl.width_request = spin_width;
        entry_sl.hexpand = false;
        entry_sl.set_max_length(4);
        entry_sl.set_max_width_chars(4);
        entry_sl_amount = new Gtk.SpinButton.with_range(0,9999,0.01);
        entry_sl_amount.halign = Gtk.Align.START;
        entry_sl_amount.width_request = spin_width;
        entry_sl_price = new Gtk.SpinButton.with_range(0,9999,0.01);
        entry_sl_price.halign = Gtk.Align.START;
        entry_sl_price.width_request = spin_width;
        grid_sl.attach(new Gtk.Label("Stop Loss"), 0, 0);
        grid_sl.attach(entry_sl, 0, 1);
        grid_sl.attach(entry_sl_amount, 0, 2);
        grid_sl.attach(entry_sl_price, 0, 3);

        //----

        var form_grid = new Gtk.Grid ();
        form_grid.margin = 30;
        form_grid.row_spacing = 12;
        form_grid.column_spacing = 20;

        form_grid.attach(grid_price, 0, 0, 2);
        form_grid.attach(grid_volume, 0, 1, 2);

        form_grid.attach(grid_tp, 0, 2);
        form_grid.attach(grid_sl, 1, 2);


        body.add (form_grid);

        acept_button = new Gtk.Button.with_label ("Buy");

        //Si es compra...
        acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        //Si es venta...
        //acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

        cancel_button = new Gtk.Button.with_label ("Cancel");

        add_action_widget (acept_button, Action.OK);
        add_action_widget (cancel_button, Action.CANCEL);

    }

}