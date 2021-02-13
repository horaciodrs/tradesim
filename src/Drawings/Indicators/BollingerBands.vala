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

 public class TradeSim.Drawings.Indicators.BollingerBandsDataItem {
    
    private double ? avg;
    private double ? std;

    public BollingerBandsDataItem () {
    }

    public void set_avg (double ? _avg) {
        avg = _avg;
    }

    public void set_std (double ? _std) {
        std = _std;
    }

    public double ? get_avg () {
        return avg;
    }

    public double ? get_std () {
        return std;
    }

 }

 public class TradeSim.Drawings.Indicators.BollingerBands : TradeSim.Drawings.Indicators.Indicator {

    private Array<TradeSim.Drawings.Indicators.BollingerBandsDataItem> data;
    private int periods;
    private int dvs;

    public BollingerBands (TradeSim.Widgets.Canvas canvas, string _id, Array<TradeSim.Drawings.Indicators.IndicatorProperty> _properties) {

        base (canvas, _id, _properties);

        periods = properties.get_int ("period");
        dvs = properties.get_int ("dvs");

        data = new Array<TradeSim.Drawings.Indicators.BollingerBandsDataItem> ();

        calculate ();

    }

    public BollingerBands.default () {
        base.default ();
    }

    public override void render (Cairo.Context ctext) {

        if (!visible){
            return;
        }

        int from = ref_canvas.data.get_quote_index_by_time (ref_canvas.date_from);
        int to = from + ref_canvas.drawed_candles;

        for (int i = from; i < to; i++) {

            if(i > 1){

                if (data.index(i - 1).get_avg () == 0){
                    continue;
                }

                //banda central.

                int x1 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i - 1).date_time);
                int x2 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i).date_time);
                int y1 = ref_canvas.get_pos_y_by_price (data.index(i-1).get_avg ());
                int y2 = ref_canvas.get_pos_y_by_price (data.index(i).get_avg ());

                if ((x1 > ref_canvas._width) || (x2 > ref_canvas._width)) {
                    break;
                }

                ctext.set_dash ({}, 0);
                ctext.set_line_width (thickness);
                color.apply_to (ctext);
                ctext.move_to (x1, y1);
                ctext.line_to (x2, y2);
                ctext.stroke ();

                //banda superior

                y1 = ref_canvas.get_pos_y_by_price (data.index(i-1).get_avg () - data.index(i-1).get_std ());
                y2 = ref_canvas.get_pos_y_by_price (data.index(i).get_avg () - data.index(i).get_std ());

                ctext.set_dash ({}, 0);
                ctext.set_line_width (thickness);
                color.apply_to (ctext);
                ctext.move_to (x1, y1);
                ctext.line_to (x2, y2);
                ctext.stroke ();

                //banda inferior

                y1 = ref_canvas.get_pos_y_by_price (data.index(i-1).get_avg () + data.index(i-1).get_std ());
                y2 = ref_canvas.get_pos_y_by_price (data.index(i).get_avg () + data.index(i).get_std ());

                ctext.set_dash ({}, 0);
                ctext.set_line_width (thickness);
                color.apply_to (ctext);
                ctext.move_to (x1, y1);
                ctext.line_to (x2, y2);
                ctext.stroke ();


            }
            
        }

    }

    public override void calculate_last_candle () {

        periods = properties.get_int ("period");
        dvs = properties.get_int ("dvs");

        int i = (int) (ref_canvas.data.quotes.length - 1);

        double avg = get_average (i);
        double std = get_standard_desviation (i, avg);

        var new_item = new TradeSim.Drawings.Indicators.BollingerBandsDataItem ();

        new_item.set_avg (avg);
        new_item.set_std (std);

        data.append_val (new_item);
        
    }

    public override void calculate () {

        //Esta función toma todas las velas cargadas en memoria
        //y calcula la media movil simple en el array avg.

        periods = properties.get_int ("period");
        dvs = properties.get_int ("dvs");

        data.remove_range (0, data.length);

        for (int i = 0; i < ref_canvas.data.quotes.length; i++) {
            double avg = get_average (i);
            double std = get_standard_desviation (i, avg);
            var new_item = new TradeSim.Drawings.Indicators.BollingerBandsDataItem ();
            new_item.set_avg (avg);
            new_item.set_std (std);
            data.append_val (new_item);
        }

    }

    private double get_average (int a) {

        if (periods < 1){
            return 0.0;
        }

        double return_value = 1.0;
        double suma = 0.0;
        int start = a - periods;
        int end = start + periods;

        if(start >= 0){
            for (int i = start; i < end; i++) {
                suma += ref_canvas.data.quotes.index (i).close_price;
            }
        }

        return_value = suma / periods;

        return return_value;
    }

    private double get_standard_desviation (int a, double avg) {

        if (periods < 1){
            return 0.0;
        }

        double return_value = 1.0;
        double suma = 0.0;
        int start = a - periods;
        int end = start + periods;

        if(start >= 0){
            for (int i = start; i < end; i++) {
                double aux = ref_canvas.data.quotes.index (i).close_price - avg;
                suma += Math.pow (aux, 2);
            }
        }

        return_value = Math.sqrt(suma / periods) * dvs;

        return return_value;
    }

}
