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

    private Gtk.ScrolledWindow scroll_prviders;
    private Gtk.TreeStore list_store_providers;
    private Gtk.TreeIter add_iter_providers;
    private Gtk.TreeIter add_iter_ticker;
    private Gtk.TreeView tree_view_providers;

    public TradeSim.Services.QuotesManager qm;

    public OperationsPanel (TradeSim.MainWindow window) {

        main_window = window;

    }

    construct {

        qm = new TradeSim.Services.QuotesManager ();

        tree_view_providers = new Gtk.TreeView ();

        configure_providers ();

        attach (scroll_prviders, 0, 0);

    }

    public void configure_providers () {

        scroll_prviders = new Gtk.ScrolledWindow (null, null);
        scroll_prviders.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        list_store_providers = new Gtk.TreeStore (9, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
        add_iter_providers = Gtk.TreeIter ();

        
        list_store_providers.append (out add_iter_providers, null);
        list_store_providers.set (add_iter_providers, 0, "1", 1, "EODATA", 2, "EURUSD", 3, "2020/01/01", 4, "0.1", 5, "1.12352", 6, "1.32352", 7 , "1.02352", 8, "$53.05", -1);

        list_store_providers.append (out add_iter_providers, null);
        list_store_providers.set (add_iter_providers, 0, "1", 1, "EODATA", 2, "EURUSD", 3, "2020/01/01", 4, "0.1", 5, "1.12352", 6, "1.32352", 7 , "1.02352", 8, "$53.05", -1);

        list_store_providers.append (out add_iter_providers, null);
        list_store_providers.set (add_iter_providers, 0, "1", 1, "EODATA", 2, "EURUSD", 3, "2020/01/01", 4, "0.1", 5, "1.12352", 6, "1.32352", 7 , "1.02352", 8, "$53.05", -1);

        list_store_providers.append (out add_iter_providers, null);
        list_store_providers.set (add_iter_providers, 0, "1", 1, "EODATA", 2, "EURUSD", 3, "2020/01/01", 4, "0.1", 5, "1.12352", 6, "1.32352", 7 , "1.02352", 8, "$53.05", -1);

        tree_view_providers = new Gtk.TreeView ();

        tree_view_providers.set_model (list_store_providers);

        Gtk.CellRendererText id_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText provider_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText ticker_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText date_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText lote_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText buy_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText tp_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText stop_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText profit_cell = new Gtk.CellRendererText ();

        tree_view_providers.insert_column_with_attributes (-1, "Code", id_cell, "text", 0, null);
        tree_view_providers.insert_column_with_attributes (-1, "Provider", provider_cell, "text", 1, null);
        tree_view_providers.insert_column_with_attributes (-1, "Ticker", ticker_cell, "text", 2, null);
        tree_view_providers.insert_column_with_attributes (-1, "Date Time", date_cell, "text", 3, null);
        tree_view_providers.insert_column_with_attributes (-1, "Lote", lote_cell, "text", 4, null);
        tree_view_providers.insert_column_with_attributes (-1, "Buy/Sell price", buy_cell, "text", 5, null);
        tree_view_providers.insert_column_with_attributes (-1, "Take Proffit", tp_cell, "text", 6, null);
        tree_view_providers.insert_column_with_attributes (-1, "Stop Loss", stop_cell, "text", 7, null);
        tree_view_providers.insert_column_with_attributes (-1, "Proffit/Loss", profit_cell, "text", 8, null);

        tree_view_providers.get_column(2).set_expand(true);

        scroll_prviders.add (tree_view_providers);
        scroll_prviders.set_vexpand (true);
        scroll_prviders.set_hexpand (true);

    }

}