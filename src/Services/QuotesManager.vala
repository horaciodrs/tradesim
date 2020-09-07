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

    public TradeSim.Services.Database db;
    public string db_file_location;

    public Array<TradeSim.Services.QuoteItem> quotes;

    /* */

    private double[] global_open_price;
    private double[] global_close_price;
    private double[] global_min_price;
    private double[] global_max_price;

    private double max_price { get; set; }
    private double min_price { get; set; }

    /* */

    public enum ItemCSVColumns {
          TICKER
        , DATE_YEAR
        , DATE_MONTH
        , DATE_DAY
        , DATE_HOURS
        , DATE_MINUTES
        , OPEN
        , HIGH
        , LOW
        , CLOSE
        , VOLUME
        , PROVIDER_NAME
        , TIME_FRAME_NAME
    }

    public QuotesManager () {

        db = new TradeSim.Services.Database ();

        quotes = new Array<TradeSim.Services.QuoteItem> ();

    }

    public void init (string _ticker, string _time_frame, DateTime _start_date, DateTime _end_date) {

        db = new TradeSim.Services.Database ();

        ticker = _ticker;
        time_frame = _time_frame;
        start_date = _start_date;
        end_date = _end_date;

        quotes = new Array<TradeSim.Services.QuoteItem> ();

        // fixed test data...

        global_open_price = { 1.08758, 1.09520, 1.09794, 1.09054, 1.08376, 1.07956, 1.08324, 1.08384, 1.08070, 1.08474, 1.08186, 1.08046, 1.08197, 1.09150, 1.09234, 1.09790, 1.09506, 1.09024, 1.08972, 1.09822, 1.10091, 1.10773, 1.11053, 1.11345, 1.11692, 1.12332, 1.13364, 1.12915, 1.12942, 1.13384, 1.13751, 1.12980, 1.12554, 1.13228, 1.12632, 1.12436, 1.12049, 1.11776, 1.12617, 1.13088, 1.12507, 1.12178, 1.12184, 1.12424, 1.12331, 1.12512, 1.12394, 1.12479, 1.13097, 1.12742, 1.13298, 1.12852, 1.13002, 1.13433, 1.14001, 1.14120, 1.13836, 1.14282, 1.14474 };
        global_max_price = { 1.09725, 1.10192, 1.09794, 1.09258, 1.08460, 1.08342, 1.08755, 1.08506, 1.08852, 1.08965, 1.08240, 1.08510, 1.09271, 1.09761, 1.09991, 1.10084, 1.09538, 1.09146, 1.09960, 1.10310, 1.10938, 1.11454, 1.11541, 1.11961, 1.12579, 1.13624, 1.13839, 1.13200, 1.13638, 1.14222, 1.14036, 1.13406, 1.13327, 1.13534, 1.12942, 1.12615, 1.12544, 1.12700, 1.13487, 1.13260, 1.12598, 1.12395, 1.12878, 1.12620, 1.12751, 1.13026, 1.12518, 1.13455, 1.13325, 1.13516, 1.13708, 1.13248, 1.13750, 1.14088, 1.14520, 1.14418, 1.14438, 1.14679, 1.15398 };
        global_min_price = { 1.08330, 1.09346, 1.08957, 1.08261, 1.07820, 1.07666, 1.08150, 1.08006, 1.07845, 1.08117, 1.07750, 1.07890, 1.07998, 1.09022, 1.09190, 1.09372, 1.08854, 1.08706, 1.08925, 1.09338, 1.09917, 1.10698, 1.11004, 1.11154, 1.11668, 1.11946, 1.12784, 1.12682, 1.12410, 1.13217, 1.12886, 1.12126, 1.12266, 1.12277, 1.12070, 1.11855, 1.11684, 1.11684, 1.12333, 1.12483, 1.11906, 1.11953, 1.12176, 1.11910, 1.11848, 1.12234, 1.12194, 1.12430, 1.12590, 1.12624, 1.12803, 1.12548, 1.13002, 1.13254, 1.13910, 1.13705, 1.13778, 1.14024, 1.14230 };
        global_close_price = { 1.09520, 1.09794, 1.09054, 1.08376, 1.07956, 1.08324, 1.08384, 1.08070, 1.08474, 1.08186, 1.08046, 1.08197, 1.09150, 1.09234, 1.09790, 1.09506, 1.09024, 1.08972, 1.09822, 1.10091, 1.10773, 1.11053, 1.11345, 1.11692, 1.12332, 1.13364, 1.12915, 1.12942, 1.13384, 1.13751, 1.12980, 1.12554, 1.13228, 1.12632, 1.12436, 1.12049, 1.11776, 1.12617, 1.13088, 1.12507, 1.12178, 1.12184, 1.12424, 1.12331, 1.12512, 1.12394, 1.12479, 1.13097, 1.12742, 1.13298, 1.12852, 1.13002, 1.13433, 1.14001, 1.14120, 1.13826, 1.14282, 1.14474, 1.15268 };


        load ();

    }

    public void insert_cuote_to_db (string _csvline) {

        TradeSim.Services.QuoteItem quote_item = get_cuote_item_by_csvline (_csvline);

        db.insert_quote(quote_item);

    }

    public TradeSim.Services.QuoteItem get_cuote_item_by_csvline (string _csvline) {

        print("csv line.....\n");
        print(_csvline + "\n");

        string[] data = _csvline.split (",");
        

        var return_value = new TradeSim.Services.QuoteItem (data[ItemCSVColumns.TICKER]);


        DateTime item_date = new DateTime.local (data[ItemCSVColumns.DATE_YEAR].to_int()
                                                 , data[ItemCSVColumns.DATE_MONTH].to_int()
                                                 , data[ItemCSVColumns.DATE_DAY].to_int()
                                                 , data[ItemCSVColumns.DATE_HOURS].to_int()
                                                 , data[ItemCSVColumns.DATE_MINUTES].to_int()
                                                 , 0);

        return_value.set_date_time (item_date);

        return_value.set_open_price (data[ItemCSVColumns.OPEN].to_double());
        return_value.set_close_price (data[ItemCSVColumns.CLOSE].to_double());
        return_value.set_min_price (data[ItemCSVColumns.LOW].to_double());
        return_value.set_max_price (data[ItemCSVColumns.HIGH].to_double());
        return_value.set_provider_name(data[ItemCSVColumns.PROVIDER_NAME]);
        return_value.set_time_frame_name(data[ItemCSVColumns.TIME_FRAME_NAME]);

        return return_value;

    }

    public void change_time_frame () {

    }

    public void change_start_date () {

    }

    public void change_end_date () {

    }

    public void load () {

        DateTime actual_date = start_date;

        for (int i = 0 ; i < global_close_price.length ; i++) {

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

            // ATENCION: SOLO TIME_FRAME M1 => IMPLEMENTAR EL RESTO.

            actual_date = actual_date.add_minutes (1);

        }

        calc_max_min_values ();

    }

    private void calc_max_min_values () {


        if (quotes.length > 0) {
            max_price = quotes.index (0).max_price;
            min_price = quotes.index (0).min_price;
        }

        for (int i = 0 ; i < quotes.length ; i++) {
            for (int z = 0 ; z < quotes.length ; z++) {

                if (quotes.index (z).max_price > max_price) {
                    max_price = quotes.index (z).max_price;
                }

                if (quotes.index (z).min_price < min_price) {
                    min_price = quotes.index (z).min_price;
                }

            }
        }

    }

    public int get_max_price_by_datetimes (DateTime dt1, DateTime dt2) {

        double local_max = -1;

        // calc_max_min_values ();
        // return (int) (max_price * 100000);

        if (quotes.length > 0) {
            local_max = quotes.index (0).max_price;
        } else {
            return (int) (local_max * 100000);
        }

        for (int i = 0 ; i < quotes.length ; i++) {
            for (int z = 0 ; z < quotes.length ; z++) {

                if ((quotes.index (z).date_time.compare (dt1) > 0) && (quotes.index (z).date_time.compare (dt2) < 0)) {

                    if (quotes.index (z).max_price > local_max) {
                        local_max = quotes.index (z).max_price * 1.00000;
                    }
                }

            }
        }

        // print ("max:" + local_max.to_string () + "\n");

        return (int) (local_max * 100000);

    }

    public int get_min_price_by_datetimes (DateTime dt1, DateTime dt2) {

        double local_min = 0;

        // calc_max_min_values ();
        // return (int) (min_price * 100000);

        if (quotes.length > 0) {
            local_min = quotes.index (0).min_price;
        } else {
            return (int) local_min;
        }

        for (int i = 0 ; i < quotes.length ; i++) {
            for (int z = 0 ; z < quotes.length ; z++) {

                if ((quotes.index (z).date_time.compare (dt1) > 0) && (quotes.index (z).date_time.compare (dt2) < 0)) {

                    if (quotes.index (z).min_price < local_min) {
                        local_min = quotes.index (z).min_price * 1.00000;
                    }
                }

            }
        }

        // print("min:" + local_min.to_string() + "\n");

        return (int) (local_min * 100000);

    }

    public void add_quote (TradeSim.Services.QuoteItem quote_item) {

        quotes.append_val (quote_item);

    }

    public TradeSim.Services.QuoteItem get_quote_by_time (DateTime cuote_time) {

        var return_value = new TradeSim.Services.QuoteItem (ticker);

        for (int i = 0 ; i < quotes.length ; i++) {

            if (quotes.index (i).date_time.compare (cuote_time) == 0) {
                return_value = quotes.index (i);
                break;
            }

        }

        return return_value;

    }

}