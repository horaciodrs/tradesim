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

public class TradeSim.Widgets.ProvidersPanel : Gtk.Grid {

    public weak TradeSim.MainWindow main_window;

    private Gtk.ScrolledWindow scroll_prviders;
    private Gtk.TreeStore list_store_providers;
    private Gtk.TreeIter add_iter_providers;
    private Gtk.TreeIter add_iter_ticker;
    private Gtk.TreeView tree_view_providers;

    public TradeSim.Services.QuotesManager qm;

    public enum TreeViewProviderColumns {
        PROVIDER_NAME
        , TICKER_ID
        , TICKER_NAME
        , SPREAD
        , N_COLUMNS
    }

    public ProvidersPanel (TradeSim.MainWindow window) {

        main_window = window;

    }

    construct {

        qm = new TradeSim.Services.QuotesManager ();

        tree_view_providers = new Gtk.TreeView ();

        configure_providers ();

        attach (scroll_prviders, 0, 0);

    }

    public void load_providers () {

        Array<TradeSim.Objects.Provider> db_providers = qm.db.get_providers_with_data ();

        list_store_providers.clear ();

        add_iter_providers = Gtk.TreeIter ();
        add_iter_ticker = Gtk.TreeIter ();

        for (int i = 0 ; i < db_providers.length ; i++) {

            list_store_providers.append (out add_iter_providers, null);
            list_store_providers.set (add_iter_providers, 0, db_providers.index (i).name, -1);

            Array<TradeSim.Objects.ProviderTicker> db_imported_tickers = qm.db.get_providers_tickers (db_providers.index (i).name);

            for (int z = 0 ; z < db_imported_tickers.length ; z++) {

                list_store_providers.append (out add_iter_ticker, add_iter_providers);
                list_store_providers.set (add_iter_ticker, 0, db_imported_tickers.index (z).ticker_name, 1, "1.12352", 2, db_imported_tickers.index (z).provider_id.to_string (), 3, db_imported_tickers.index (z).ticker_id.to_string (), 4, db_imported_tickers.index (z).provider_name.to_string (), -1);

            }

        }

    }

    public void refresh_providers () {
        qm = new TradeSim.Services.QuotesManager ();
        tree_view_providers.get_selection ().unselect_all ();
        load_providers ();
        tree_view_providers.expand_all ();
    }

    public void configure_providers () {

        scroll_prviders = new Gtk.ScrolledWindow (null, null);
        scroll_prviders.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_providers = new Gtk.TreeStore (5, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));

        load_providers ();

        tree_view_providers = new Gtk.TreeView ();

        tree_view_providers.set_model (list_store_providers);

        Gtk.CellRendererText ticker_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText ticker_price = new Gtk.CellRendererText ();
        Gtk.CellRendererText ticker_provider_name = new Gtk.CellRendererText ();

        tree_view_providers.get_selection ().changed.connect ((sel) => {

            if (sel.count_selected_rows () < 1) {
                return;
            }

            Gtk.TreeIter edited_iter;
            Gtk.TreeModel model;
            GLib.Value nombre;
            GLib.Value ticker_nombre;

            sel.get_selected (out model, out edited_iter);

            model.get_value (edited_iter, 4, out nombre);
            model.get_value (edited_iter, 0, out ticker_nombre);

            main_window.main_layout.add_canvas (nombre.get_string (), ticker_nombre.get_string (), "H1");

            tree_view_providers.get_selection ().unselect_all ();

        });

        tree_view_providers.insert_column_with_attributes (-1, _ ("Ticker"), ticker_cell, "text", 0, null);
        tree_view_providers.insert_column_with_attributes (-1, _ ("Price"), ticker_price, "text", 1, null);
        tree_view_providers.insert_column_with_attributes (-1, "ProviderId", ticker_price, "text", 2, null);
        tree_view_providers.insert_column_with_attributes (-1, "TickerId", ticker_price, "text", 3, null);
        tree_view_providers.insert_column_with_attributes (-1, "Provider", ticker_provider_name, "text", 4, null);

        tree_view_providers.get_column (0).set_expand (true);

        tree_view_providers.get_column (2).set_visible (false);
        tree_view_providers.get_column (3).set_visible (false);
        tree_view_providers.get_column (4).set_visible (false);

        tree_view_providers.expand_all ();

        scroll_prviders.add (tree_view_providers);
        scroll_prviders.set_vexpand (true);
        scroll_prviders.set_hexpand (true);

    }

}
