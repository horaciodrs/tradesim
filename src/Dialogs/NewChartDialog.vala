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

public class TradeSim.Dialogs.NewChartDialog : Gtk.Dialog {
    public weak TradeSim.MainWindow main_window { get; construct; }

    public Gtk.Button acept_button;
    public Gtk.Button cancel_button;

    private Gtk.Label header_title;

    private Gtk.Label label_name;
    private Gtk.Label label_provider;
    private Gtk.Label label_ticker;
    private Gtk.Label label_amount;
    private Gtk.Label label_date;

    private Gtk.Entry txt_name;
    private Gtk.Entry txt_amount;

    private Gtk.ComboBox cbo_provider;
    private Gtk.ComboBox cbo_ticker;

    private string aux_provider_name;
    private string aux_time_frame_name;
    private string aux_ticker_name;

    private Granite.Widgets.DatePicker entry_date;

    private Gtk.InfoBar info_alert;
    private Gtk.Label info_label;

    private TradeSim.Services.Database db;

    enum Action {
        OK,
        CANCEL
    }

    public NewChartDialog (TradeSim.MainWindow ? parent, string _provider_name, string _ticker_name) {
        Object (
            border_width: 5,
            deletable: false,
            resizable: false,
            title: _ ("New Simulation"),
            transient_for: parent,
            main_window: parent
            );

        aux_provider_name = _provider_name;
        aux_ticker_name = _ticker_name;
        aux_time_frame_name = "H1";

        init ();

    }

    public void init () {

        db = new TradeSim.Services.Database ();

        build_content ();

        response.connect (on_response);

    }

    private bool validate_time_frame (string ? v) {

        if (v == null) {
            return false;
        }

        if (v == "") {
            return false;
        }

        string[] valid_time_frames = { "M1", "M5", "M15", "M30", "H1", "H4", "D1", "M1" };

        for (int i = 0 ; i < valid_time_frames.length ; i++) {
            if (valid_time_frames[i] == v) {
                return true;
            }
        }

        return false;

    }

    private void refresh_date () {

        if (aux_provider_name == "") {
            return;
        }

        if (aux_ticker_name == "") {
            return;
        }

        if (validate_time_frame (aux_time_frame_name) == false) {
            return;
        }

        entry_date.date = db.get_min_date (aux_provider_name, aux_ticker_name, aux_time_frame_name);

    }

    private void build_content () {

        var body = get_content_area ();

        var header_grid = new Gtk.Grid ();
        header_grid.margin_start = 30;
        header_grid.margin_end = 30;
        header_grid.margin_bottom = 10;

        var image = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.DIALOG);
        image.margin_end = 10;

        header_title = new Gtk.Label (_ ("New Simulation"));
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

        label_name = new Gtk.Label (_ ("Simulation Name:"));
        txt_name = new Gtk.Entry ();
        txt_name.set_text (_ ("Unnamed Simulation"));
        label_name.halign = Gtk.Align.END;

        form_grid.attach (label_name, 0, 0, 1, 1);
        form_grid.attach (txt_name, 1, 0, 1, 1);

        label_provider = new Gtk.Label (_ ("Data Provider:"));
        build_cbo_provider ();
        label_provider.halign = Gtk.Align.END;

        label_ticker = new Gtk.Label (_ ("Ticker:"));
        build_cbo_ticker ();
        label_ticker.halign = Gtk.Align.END;

        label_amount = new Gtk.Label (_ ("Initial Balance:"));
        txt_amount = new Gtk.Entry ();
        txt_amount.set_text ("1000");
        label_amount.halign = Gtk.Align.END;

        label_date = new Gtk.Label (_ ("Date:"));
        entry_date = new Granite.Widgets.DatePicker ();
        label_date.halign = Gtk.Align.END;

        entry_date.date_changed.connect (() => {

            string str_validation = date_validation ();

            if(str_validation.length > 0){
                info_label.set_text (str_validation);
                info_alert.set_revealed (true);
            }else{
                info_alert.set_revealed (false);
            }

        });

        info_label = new Gtk.Label ("");

        info_alert = new Gtk.InfoBar ();
        info_alert.set_message_type (Gtk.MessageType.WARNING);
        info_alert.get_content_area ().add (info_label);



        form_grid.attach (label_provider, 0, 1, 1, 1);
        form_grid.attach (cbo_provider, 1, 1, 1, 1);

        form_grid.attach (label_ticker, 0, 2, 1, 1);
        form_grid.attach (cbo_ticker, 1, 2, 1, 1);


        form_grid.attach (label_amount, 0, 3, 1, 1);
        form_grid.attach (txt_amount, 1, 3, 1, 1);

        form_grid.attach (label_date, 0, 4, 1, 1);
        form_grid.attach (entry_date, 1, 4, 1, 1);

        // form_grid.attach (info_alert, 0, 6, 2, 1);

        info_alert.set_revealed (false);

        // form_grid.set_baseline_row(6);

        body.add (info_alert);
        body.add (form_grid);

        acept_button = new Gtk.Button.with_label (_ ("Ok"));
        acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        cancel_button = new Gtk.Button.with_label (_ ("Cancel"));

        add_action_widget (acept_button, Action.OK);
        add_action_widget (cancel_button, Action.CANCEL);

    }

    private void build_cbo_provider () {

        Array<TradeSim.Objects.Provider> providers = db.get_providers_with_data ();

        var list_store_providers = new Gtk.ListStore (1, typeof (string));

        for (int i = 0 ; i < providers.length ; i++) {
            Gtk.TreeIter iter;
            list_store_providers.append (out iter);
            list_store_providers.set (iter, 0, providers.index (i).name);
        }

        cbo_provider = new Gtk.ComboBox.with_model (list_store_providers);
        var cell = new Gtk.CellRendererText ();
        cbo_provider.pack_start (cell, false);

        cbo_provider.set_attributes (cell, "text", 0);
        cbo_provider_select_by_text (aux_provider_name);
        cbo_provider.changed.connect (cbo_provider_changed);

    }

    public void cbo_provider_select_by_text (string txt) {

        Array<TradeSim.Objects.Provider> providers = db.get_providers_with_data ();

        for (int i = 0 ; i < providers.length ; i++) {
            if (providers.index (i).name == txt) {
                cbo_provider.set_active (i);
            }
        }

    }

    public void cbo_provider_changed () {

        var modelo = cbo_provider.get_model ();
        Gtk.TreeIter selected_item;
        GLib.Value selected_provider;

        cbo_provider.get_active_iter (out selected_item);
        modelo.get_value (selected_item, 0, out selected_provider);

        aux_provider_name = selected_provider.get_string ();

        reload_cbo_ticker ();

        refresh_date ();

    }

    private void build_cbo_ticker () {

        var list_store_ticker = new Gtk.ListStore (1, typeof (string));

        if (aux_provider_name != "") {

            Array<string> tickers = db.get_tickers_with_data (aux_provider_name);

            for (int i = 0 ; i < tickers.length ; i++) {
                Gtk.TreeIter iter;
                list_store_ticker.append (out iter);
                list_store_ticker.set (iter, 0, tickers.index (i));
            }

        }

        cbo_ticker = new Gtk.ComboBox.with_model (list_store_ticker);
        var cell = new Gtk.CellRendererText ();
        cbo_ticker.pack_start (cell, false);

        cbo_ticker.set_attributes (cell, "text", 0);
        cbo_ticker_select_by_text (aux_ticker_name);
        cbo_ticker.changed.connect (cbo_ticker_changed);

        // cbo_ticker.set_active(-1);

    }

    public void cbo_ticker_changed () {

        var modelo = cbo_ticker.get_model ();
        Gtk.TreeIter selected_item;
        GLib.Value selected_ticker;

        cbo_ticker.get_active_iter (out selected_item);
        modelo.get_value (selected_item, 0, out selected_ticker);

        aux_ticker_name = selected_ticker.get_string ();

        refresh_date ();

    }

    public void reload_cbo_ticker () {

        var list_store_ticker = new Gtk.ListStore (1, typeof (string));

        if (aux_provider_name != "") {

            Array<string> tickers = db.get_tickers_with_data (aux_provider_name);

            for (int i = 0 ; i < tickers.length ; i++) {
                Gtk.TreeIter iter;
                list_store_ticker.append (out iter);
                list_store_ticker.set (iter, 0, tickers.index (i));
            }

        }

        cbo_ticker.set_model (list_store_ticker);
        cbo_ticker.set_active (-1);

    }

    public void cbo_ticker_select_by_text (string txt) {

        Array<string> tickers = db.get_tickers_with_data (aux_provider_name);

        for (int i = 0 ; i < tickers.length ; i++) {
            if (tickers.index (i) == txt) {
                cbo_ticker.set_active (i);
            }
        }

    }

    private string date_validation(){

        string return_value = "";
        int count = db.get_available_quotes (aux_provider_name, aux_ticker_name, aux_time_frame_name, entry_date.date);
        const uint MIN_ALERT_QUOTES = 100;

        if (count == 0) {
            return_value = _ ("There is not imported data to the selected date.");
        } else if ((count > 0) && (count < MIN_ALERT_QUOTES)) {
            return_value = _ ("There are not engouth imported data to run a simulation.");
        }else if(!is_valid_market_date(entry_date.date)){
            return_value = _ ("Market closed. Please select another date.");
        }else if (!db.exists_quotes_in_date(aux_provider_name, aux_ticker_name, aux_time_frame_name, entry_date.date)){
            return_value = _ ("There are not imported quotes for the selected date.");
        }

        return return_value;

    }

    private string validate_data () {

        if (txt_name.get_text ().length < 1) {
            return _ ("Please enter the simulation name");
        }

        if (aux_provider_name.length < 1) {
            return _ ("Please enter the provider");
        }

        if (aux_ticker_name.length < 1) {
            return _ ("Please enter the ticker");
        }

        if (aux_time_frame_name.length < 1) {
            return _ ("Please enter the timeframe");
        }

        if (txt_amount.get_text ().length < 1) {
            return _ ("Please enter the initial balance");
        } else if (double.parse (txt_amount.get_text ()) == 0) {
            return _ ("Please enter a valid initial balance");
        }

        string str_validation = date_validation ();

        if(str_validation.length > 0){
            return str_validation;
        }

        return "";
    }

    private void on_response (Gtk.Dialog source, int response_id) {

        if (response_id == Action.OK) {

            string msg = validate_data ();

            if (msg.length > 0) {

                var dialog = new Gtk.MessageDialog (this, 0, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK_CANCEL, msg);
                dialog.run ();
                dialog.destroy ();
                return;

            }

        }

        switch (response_id) {
        case Action.OK:

            TradeSim.Dialogs.NewChartDialog dialogo = ((TradeSim.Dialogs.NewChartDialog)source);

            var objetivo = dialogo.main_window.main_layout;

            objetivo.new_chart (aux_provider_name, aux_ticker_name, aux_time_frame_name, txt_name.get_text (), double.parse (txt_amount.get_text ()), entry_date.date);

            destroy ();

            break;

        case Action.CANCEL:
            destroy ();
            break;
        }
    }

}
