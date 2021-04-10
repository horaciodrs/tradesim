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
 * along with TradeSim. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Horacio Daniel Ros <horaciodrs@gmail.com>
 */

public class TradeSim.Objects.CanvasData {

    public string simulation_name;
    public double simulation_initial_balance;
    public DateTime date_inicial;
    public DateTime date_from;
    public DateTime date_to;
    public DateTime last_candle_date;

    public double last_candle_price;
    public double last_candle_max_price;
    public double last_candle_min_price;
    public string provider_name;
    public string time_frame;
    public string ticker;

    public CanvasData () {

    }

    public void print_data () {
        print ("simulation_name:" + simulation_name + "\n");
        print ("simulation_initial_balance:" + simulation_initial_balance.to_string () + "\n");
        print ("date_inicial:" + date_inicial.to_string () + "\n");
        print ("date_from:" + date_from.to_string () + "\n");
        print ("date_to:" + date_to.to_string () + "\n");
        print ("last_candle_date:" + last_candle_date.to_string () + "\n");

        print ("last_candle_price:" + last_candle_price.to_string () + "\n");
        print ("last_candle_max_price:" + last_candle_max_price.to_string () + "\n");
        print ("last_candle_min_price:" + last_candle_min_price.to_string () + "\n");
        print ("provider_name:" + provider_name + "\n");
        print ("time_frame:" + time_frame + "\n");
        print ("ticker:" + ticker + "\n");
    }

}
