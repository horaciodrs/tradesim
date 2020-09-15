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
    private Gtk.TreeStore list_store_operations;
    private Gtk.TreeIter add_iter_operations;
    private Gtk.TreeView tree_view_operations;

    public TradeSim.Services.QuotesManager qm;

    public enum OperationColumns{
         ID
        ,PROVIDER
        ,TICKER
        ,DATE
        ,STATE
        ,OBSERVATIONS
        ,VOLUME
        ,BUY_PRICE
        ,TP_PRICE
        ,SL_PRICE
        ,PROFIT
        ,N_COLUMNS
    }

    public OperationsPanel (TradeSim.MainWindow window) {

        main_window = window;

    }

    construct {

        qm = new TradeSim.Services.QuotesManager ();

        tree_view_operations = new Gtk.TreeView ();

        configure_operations ();

        attach (scroll_prviders, 0, 0);

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
                                                 , typeof (string));
        add_iter_operations = Gtk.TreeIter ();

        
        list_store_operations.append (out add_iter_operations, null);
        list_store_operations.set (add_iter_operations
                                 , OperationColumns.ID, "1"
                                 , OperationColumns.PROVIDER, "EODATA"
                                 , OperationColumns.TICKER, "EURUSD"
                                 , OperationColumns.DATE, "2020/01/01"
                                 , OperationColumns.STATE , "Open"
                                 , OperationColumns.OBSERVATIONS , "Obs..."
                                 , OperationColumns.VOLUME, "0.1"
                                 , OperationColumns.BUY_PRICE, "1.12352"
                                 , OperationColumns.TP_PRICE, "1.32352"
                                 , OperationColumns.SL_PRICE, "1.02352"
                                 , OperationColumns.PROFIT, "$53.05", -1);

        tree_view_operations = new Gtk.TreeView ();

        tree_view_operations.set_model (list_store_operations);

        Gtk.CellRendererText id_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText provider_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText ticker_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText state_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText observations_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText date_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText volume_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText buy_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText tp_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText stop_cell = new Gtk.CellRendererText ();
        Gtk.CellRendererText profit_cell = new Gtk.CellRendererText ();

        tree_view_operations.insert_column_with_attributes (-1, "Code", id_cell, "text", OperationColumns.ID, null);
        tree_view_operations.insert_column_with_attributes (-1, "Provider", provider_cell, "text", OperationColumns.PROVIDER, null);
        tree_view_operations.insert_column_with_attributes (-1, "Ticker", ticker_cell, "text", OperationColumns.TICKER, null);
        tree_view_operations.insert_column_with_attributes (-1, "Date Time", date_cell, "text", OperationColumns.DATE, null);

        tree_view_operations.insert_column_with_attributes (-1, "State", state_cell, "text", OperationColumns.STATE, null);
        tree_view_operations.insert_column_with_attributes (-1, "Observations", observations_cell, "text", OperationColumns.OBSERVATIONS, null);

        tree_view_operations.insert_column_with_attributes (-1, "Volume", volume_cell, "text", OperationColumns.VOLUME, null);
        tree_view_operations.insert_column_with_attributes (-1, "Buy/Sell price", buy_cell, "text", OperationColumns.BUY_PRICE, null);
        tree_view_operations.insert_column_with_attributes (-1, "Take Proffit", tp_cell, "text", OperationColumns.TP_PRICE, null);
        tree_view_operations.insert_column_with_attributes (-1, "Stop Loss", stop_cell, "text", OperationColumns.SL_PRICE, null);
        tree_view_operations.insert_column_with_attributes (-1, "Proffit/Loss", profit_cell, "text", OperationColumns.PROFIT, null);

        tree_view_operations.get_column(OperationColumns.OBSERVATIONS).set_expand(true);

        scroll_prviders.add (tree_view_operations);
        scroll_prviders.set_vexpand (true);
        scroll_prviders.set_hexpand (true);

    }

}