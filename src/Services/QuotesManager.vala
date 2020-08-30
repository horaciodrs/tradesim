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

    public id string; // ticker

    public DateTime start_date;
    public DateTime end_date;
    public string time_frame;

    public string db_file_location;

    public Array<TradeSim.Services.QuoteItem> quotes;

    public QuotesManager (string ticker, string _time_frame, DateTime _start_date, DateTime _end_date) {
        id = ticker;
        time_frame = _time_frame;
        start_date = _start_date;
        end_date = _end_date;
    }

    construct {

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

        while (actual_date < end_date) {

            var new_quote = new TradeSim.Services.QuoteItem ();

            new_quote.set_date_time (actual_date);

            /*
               Se cargan los datos para esa fecha.
               Si no hay datos se toman los de la fecha mas proxima anterior.
             */

            new_quote.set_open_price (1);
            new_quote.set_close_price (1);
            new_quote.set_min_price (1);
            new_quote.set_max_price (1);

            quotes.append_val (new_quote);

            switch (time_frame) {
            case "M1":
                actual_date.add_minutes (1);
                break;
            case "M5":
                actual_date.add_minutes (5);
                break;
            case "M15":
                actual_date.add_minutes (15);
                break;
            default:
                break;
            }

        }

    }

    public void add_quote (TradeSim.Services.QuoteItem quote_item) {

        quotes.append_val (quote_item);

    }

    public TradeSim.Services.QuoteItem get_quote_by_time (DateTime cuote_time) {

        TradeSim.Services.QuoteItem return_value;

        for (int i = 0 ; i < quotes.length ; i++) {

            if (quotes.index (i).datetime == cuote_time) {
                return_value = quotes.index (i);
                break;
            }

        }

        return return_value;

    }

}