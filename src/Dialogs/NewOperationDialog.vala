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

    private Gtk.Label label_type; //Buy/Sell
    private Gtk.Label label_type_value;

    private Gtk.Label label_sim_data; //SimulationName - Provider - Ticker.
    private Gtk.Label label_sim_data_value;

    private Gtk.Label label_volume;
    private Gtk.SpinButton spin_volume;
    private Gtk.Label label_volume_amount;

    private Gtk.Label label_price;
    private Gtk.Label label_price_value;

    private Gtk.Label label_tp;
    private Gtk.SpinButton entry_tp; //En pips.
    private Gtk.Entry entry_tp_price; //En precio.
    private Gtk.Entry entry_tp_amount; //En dinero ($$$).

    private Gtk.Label label_sl;
    private Gtk.SpinButton entry_sl; //En pips.
    private Gtk.Entry entry_sl_price; //En precio.
    private Gtk.Entry entry_sl_amount; //En dinero ($$$).

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

        var body = get_content_area ();

        var header_grid = new Gtk.Grid ();
        header_grid.margin_start = 30;
        header_grid.margin_end = 30;
        header_grid.margin_bottom = 10;

        var image = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.DIALOG);
        image.margin_end = 10;

        header_title = new Gtk.Label ("New Operation");
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.halign = Gtk.Align.START;
        header_title.ellipsize = Pango.EllipsizeMode.END;
        header_title.margin_end = 10;
        header_title.set_line_wrap (true);
        header_title.hexpand = true;

        header_grid.attach (image, 0, 0, 1, 2);
        header_grid.attach (header_title, 1, 0, 1, 2);

        body.add (header_grid);

        var form_grid = new Gtk.Grid ();
        form_grid.margin = 30;
        form_grid.row_spacing = 12;
        form_grid.column_spacing = 20;

        label_id = new Gtk.Label("Code:");
        label_id.halign = Gtk.Align.END;
        label_id_value = new Gtk.Label("1");
        label_id_value.halign = Gtk.Align.START;

        label_date = new Gtk.Label("Date:");
        label_date.halign = Gtk.Align.END;
        label_date_value = new Gtk.Label("21 Jan 2011 at 10:04am.");
        label_date_value.halign = Gtk.Align.START;

        label_type = new Gtk.Label("Type:");
        label_type.halign = Gtk.Align.END;
        label_type_value = new Gtk.Label("Buy");
        label_type_value.halign = Gtk.Align.START;

        label_sim_data = new Gtk.Label("Simulation:");
        label_sim_data.halign = Gtk.Align.END;
        label_sim_data_value = new Gtk.Label("Martingala, TRADESIM - EURUSD, H1.");
        label_sim_data_value.halign = Gtk.Align.START;

        label_price = new Gtk.Label("Price:");
        label_price.halign = Gtk.Align.END;
        label_price_value = new Gtk.Label("1.12345");
        label_price_value.halign = Gtk.Align.START;

        var grid_volume = new Gtk.Grid();
        label_volume = new Gtk.Label("Volume:");
        label_volume.halign = Gtk.Align.END;
        spin_volume = new Gtk.SpinButton.with_range(0,10,0.01);
        spin_volume.halign = Gtk.Align.START;
        spin_volume.hexpand = false;
        spin_volume.set_max_length(4);
        spin_volume.set_max_width_chars(4);
        label_volume_amount = new Gtk.Label(" = $50.000,00");
        label_volume_amount.halign = Gtk.Align.START;
        grid_volume.attach(spin_volume, 0, 0);
        grid_volume.attach(label_volume_amount, 1, 0);
        grid_volume.column_spacing = 12;

        var grid_tp = new Gtk.Grid();
        label_tp = new Gtk.Label("Take Profit:");
        label_tp.halign = Gtk.Align.END;
        entry_tp = new Gtk.SpinButton.with_range(0, 99999, 1);
        entry_tp.halign = Gtk.Align.START;
        entry_tp.hexpand = false;
        entry_tp.set_max_length(4);
        entry_tp.set_max_width_chars(4);
        entry_tp_amount = new Gtk.Entry();
        entry_tp_amount.halign = Gtk.Align.START;
        entry_tp_price = new Gtk.Entry();
        entry_tp_price.halign = Gtk.Align.START;
        grid_tp.attach(entry_tp, 0, 0);
        grid_tp.attach(new Gtk.Label(" pips.  "), 1, 0);
        grid_tp.attach(entry_tp_amount, 2, 0);
        grid_tp.attach(new Gtk.Label(" $.  "), 3, 0);
        grid_tp.attach(entry_tp_price, 4, 0);

        //----

        var grid_sl = new Gtk.Grid();
        label_sl = new Gtk.Label("Stop Loss:");
        label_sl.halign = Gtk.Align.END;
        entry_sl = new Gtk.SpinButton.with_range(0, 99999, 1);
        entry_sl.halign = Gtk.Align.START;
        entry_sl.hexpand = false;
        entry_sl.set_max_length(4);
        entry_sl.set_max_width_chars(4);
        entry_sl_amount = new Gtk.Entry();
        entry_sl_amount.halign = Gtk.Align.START;
        entry_sl_price = new Gtk.Entry();
        entry_sl_price.halign = Gtk.Align.START;
        grid_sl.attach(entry_sl, 0, 0);
        grid_sl.attach(new Gtk.Label(" pips.  "), 1, 0);
        grid_sl.attach(entry_sl_amount, 2, 0);
        grid_sl.attach(new Gtk.Label(" $.  "), 3, 0);
        grid_sl.attach(entry_sl_price, 4, 0);

        //----

        form_grid.attach(label_id, 0, 0);
        form_grid.attach(label_id_value, 1, 0);

        form_grid.attach(label_date, 0, 1);
        form_grid.attach(label_date_value, 1, 1);

        form_grid.attach(label_type, 0, 2);
        form_grid.attach(label_type_value, 1, 2);

        form_grid.attach(label_sim_data, 0, 3);
        form_grid.attach(label_sim_data_value, 1, 3);

        form_grid.attach(label_price, 0, 4);
        form_grid.attach(label_price_value, 1, 4);

        form_grid.attach(label_volume, 0, 5);
        form_grid.attach(grid_volume, 1, 5);

        form_grid.attach(label_tp, 0, 6);
        form_grid.attach(grid_tp, 1, 6);

        form_grid.attach(label_sl, 0, 7);
        form_grid.attach(grid_sl, 1, 7);


        body.add (form_grid);

        acept_button = new Gtk.Button.with_label ("Ok");
        acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        cancel_button = new Gtk.Button.with_label ("Cancel");

        add_action_widget (acept_button, Action.OK);
        add_action_widget (cancel_button, Action.CANCEL);

    }

}