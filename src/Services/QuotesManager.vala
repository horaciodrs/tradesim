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

public class TradeSim.Services.QuotesManager {

    public string ticker; // ticker

    public DateTime start_date;
    public DateTime end_date;
    public string time_frame;

    public string db_file_location;

    public Array<TradeSim.Services.QuoteItem> quotes;

    /* */

    private double[] global_open_price;
    private double[] global_close_price;
    private double[] global_min_price;
    private double[] global_max_price;

    /* */

    public QuotesManager (string _ticker, string _time_frame, DateTime _start_date, DateTime _end_date) {

        ticker = _ticker;
        time_frame = _time_frame;
        start_date = _start_date;
        end_date = _end_date;

        quotes = new Array<TradeSim.Services.QuoteItem> ();

        //fixed test data...

        global_open_price = { 1.08758, 1.09520, 1.09794, 1.09054, 1.08376, 1.07956, 1.08324, 1.08384, 1.08070, 1.08474, 1.08186, 1.08046, 1.08197, 1.09150, 1.09234, 1.09790, 1.09506, 1.09024, 1.08972, 1.09822, 1.10091, 1.10773, 1.11053, 1.11345, 1.11692, 1.12332 };
        global_max_price = { 1.09725, 1.10192, 1.09794, 1.09258, 1.08460, 1.08342, 1.08755, 1.08506, 1.08852, 1.08965, 1.08240, 1.08510, 1.09271, 1.09761, 1.09991, 1.10084, 1.09538, 1.09146, 1.09960, 1.10310, 1.10938, 1.11454, 1.11541, 1.11961, 1.12579, 1.13624 };
        global_min_price = { 1.08330, 1.09346, 1.08957, 1.08261, 1.07820, 1.07666, 1.08150, 1.08006, 1.07845, 1.08117, 1.07750, 1.07890, 1.07998, 1.09022, 1.09190, 1.09372, 1.08854, 1.08706, 1.08925, 1.09338, 1.09917, 1.10698, 1.11004, 1.11154, 1.11668, 1.11946 };
        global_close_price = { 1.09520, 1.09794, 1.09054, 1.08376, 1.07956, 1.08324, 1.08384, 1.08070, 1.08474, 1.08186, 1.08046, 1.08197, 1.09150, 1.09234, 1.09790, 1.09506, 1.09024, 1.08972, 1.09822, 1.10091, 1.10773, 1.11053, 1.11345, 1.11692, 1.12332, 1.13364 };

        load ();

    }


    public void change_time_frame () {

    }

    public void change_start_date () {

    }

    public void change_end_date () {

    }

    public void load () {

        DateTime actual_date = start_date;

        for(int i = 0; i < global_close_price.length; i++){

            /*
               Se cargan los datos para esa fecha.
               Si no hay datos se toman los de la fecha mas proxima anterior.
             */

        
            var new_quote = new TradeSim.Services.QuoteItem (ticker);

            new_quote.set_date_time (actual_date);

            new_quote.set_open_price (global_open_price[i]);
            new_quote.set_close_price (global_close_price[i]);
            new_quote.set_min_price (global_min_price[i]);
            new_quote.set_max_price (global_max_price[i]);

            quotes.append_val (new_quote);

            //ATENCION: SOLO TIME_FRAME M1 => IMPLEMENTAR EL RESTO.

            actual_date = actual_date.add_minutes (1);

        }

    }

    public void add_quote (TradeSim.Services.QuoteItem quote_item) {

        quotes.append_val (quote_item);

    }

    public TradeSim.Services.QuoteItem get_quote_by_time (DateTime cuote_time) {

        var return_value = new TradeSim.Services.QuoteItem (ticker);

        for (int i = 0 ; i < quotes.length ; i++) {

            if (quotes.index (i).date_time == cuote_time) {
                return_value = quotes.index (i);
                break;
            }

        }

        return return_value;

    }

}