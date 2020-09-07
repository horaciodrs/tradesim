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

public class TradeSim.Services.QuoteItem {

    public string ticker;
    public string time_frame_name;
    public string provider_name;

    public DateTime date_time;

    public double open_price;
    public double close_price;
    public double min_price;
    public double max_price;

    public QuoteItem (string _ticker) {
        ticker = _ticker;
    }

    public void set_provider_name(string _name){
        provider_name = _name;
    }

    public void set_time_frame_name(string _name){
        time_frame_name = _name;
    }

    public void set_date_time (DateTime _date_time) {
        date_time = _date_time;
    }

    public void set_open_price (double _open_price) {
        open_price = _open_price;
    }

    public void set_close_price (double _close_price) {
        close_price = _close_price;
    }

    public void set_min_price (double _min_price) {
        min_price = _min_price;
    }

    public void set_max_price (double _max_price) {
        max_price = _max_price;
    }

    private string get_formatted_price (string type) {

        string return_value = "0.00000";
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        switch (type) {
        case "open":
            return_value = open_price.format (buf, "%g").concat ("00000");
            break;
        case "close":
            return_value = close_price.format (buf, "%g").concat ("00000");
            break;
        case "min":
            return_value = min_price.format (buf, "%g").concat ("00000");
            break;
        case "max":
            return_value = max_price.format (buf, "%g").concat ("00000");
            break;
        default:
            break;
        }

        return return_value.substring (0, 5);

    }

    public string get_formatted_date_time () {
        return "21 Feb, 2011 at 10:04hs.";
    }

    public string get_open_price_formatted () {
        return get_formatted_price ("open");
    }

    public string get_close_price_formatted () {
        return get_formatted_price ("close");
    }

    public string get_min_price_formatted () {
        return get_formatted_price ("min");
    }

    public string get_max_price_formatted () {
        return get_formatted_price ("max");
    }

}