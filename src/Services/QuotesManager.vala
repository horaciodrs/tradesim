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

        global_open_price = { 1.145980, 1.145980, 1.146070, 1.146060, 1.146190 };

        global_close_price = { 1.145990, 1.146070, 1.146070, 1.146210, 1.146660 };

        global_min_price = { 1.145980, 1.145980, 1.146060, 1.146060, 1.146040 };

        global_max_price = { 1.145980, 1.146070, 1.146060, 1.146210, 1.146650 };

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

        for(int i = 0; i < 4; i++){

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