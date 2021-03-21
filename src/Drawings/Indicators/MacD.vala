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

 public class TradeSim.Drawings.Indicators.MacDDataItem {
    
    private double ? macd;

    public MacDDataItem () {
    }

    public string to_string () {
        return "testing...\n";
    }

    public void set_macd (double ? _macd) {
        macd = _macd;
    }

    public double ? get_macd () {

        return macd;
    }

 }

 public class TradeSim.Drawings.Indicators.MacD : TradeSim.Drawings.Indicators.Indicator {

    private Array<TradeSim.Drawings.Indicators.MacDDataItem> data;  //El indice se corresponde con la vela (fecha) y el valor es el promedio calculado para ser representado.
    private int slow_periods;
    private int fast_periods;

    public double min_macd;
    public double max_macd;

    public MacD (TradeSim.Widgets.Canvas canvas, TradeSim.Widgets.OscilatorCanvas _oscilator_canvas, string _id, Array<TradeSim.Drawings.Indicators.IndicatorProperty> _properties) {

        base (canvas, _oscilator_canvas, _id, _properties);

        slow_periods = properties.get_int ("slow_periods");
        fast_periods = properties.get_int ("fast_periods");

        min_macd = 0.00;
        max_macd = 0.00;

        data = new Array<TradeSim.Drawings.Indicators.MacDDataItem> ();

        calculate ();

    }

    public MacD.default () {
        base.default ();
    }

    public override void render_by_candle (Cairo.Context ctext, int i) {

        if (!visible){
            return;
        }

        if(i > 1){

            if (i > ref_canvas.data.quotes.length - 1){
                return;
            }

            int x = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i).date_time);
            int y = ref_oscilator_canvas.get_posy_by_range (data.index(i).get_macd (), min_macd, max_macd);
            int canvas_center = ref_oscilator_canvas.get_range_center ();

            if (y < canvas_center){
                ref_canvas.color_palette.candle_up.apply_to (ctext);
            }else{
                ref_canvas.color_palette.candle_down.apply_to (ctext);
            }

            ctext.rectangle (x, y, ref_canvas.candle_width, canvas_center - y);
            ctext.fill ();

            int x1 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i - 1).date_time);
            int x2 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i).date_time);            
            int y1 = ref_oscilator_canvas.get_posy_by_range (data.index(i-1).get_macd (), min_macd, max_macd);
            int y2 = ref_oscilator_canvas.get_posy_by_range (data.index(i).get_macd (), min_macd, max_macd);

            ctext.set_dash ({}, 0);
            ctext.set_line_width (thickness);
            color.apply_to (ctext);
            ctext.move_to (x1, y1);
            ctext.line_to (x2, y2);
            ctext.stroke ();

        }
        
    }

    public override void render (Cairo.Context ctext) {

        if (!visible){
            return;
        }

        calculate ();

        int from = ref_canvas.data.get_quote_index_by_time (ref_canvas.date_from);
        int to = from + ref_canvas.drawed_candles;

        for (int i = from; i < to; i++) {

            render_by_candle (ctext, i);
            
        }

    }

    public override void calculate_last_candle () {

        return;
        
    }

    public override void calculate () {

        //Esta función toma todas las velas cargadas en memoria
        //y calcula la media movil simple en el array avg.

        slow_periods = properties.get_int ("slow_periods");
        fast_periods = properties.get_int ("fast_periods");

        data.remove_range (0, data.length);

        for (int i = 0; i < ref_canvas.data.quotes.length; i++) {
            
            var new_item = new TradeSim.Drawings.Indicators.MacDDataItem ();
            
            double macd = 1.00;
            double slow_suma = 0.00;
            double fast_suma = 0.00;
            double slow_avg = 0.00;
            double fast_avg = 0.00;

            if (fast_periods > i){
                macd = 0.00;
            }else {

                int start = i - fast_periods;
                int end = start + fast_periods;

                for (int z = start; z < end; z++){

                    fast_suma += ref_canvas.data.quotes.index (z).close_price;

                    if ((end - z) <= slow_periods){
                        slow_suma += ref_canvas.data.quotes.index (z).close_price;
                    }

                }

                slow_avg = slow_suma / slow_periods;
                fast_avg = fast_suma / fast_periods;

                macd = (slow_avg - fast_avg) * 10000.00;

            }

            if ((min_macd == 0) || (min_macd > macd)) {
                min_macd = macd;
            }

            if ((max_macd == 0) || (max_macd < macd)) {
                max_macd = macd;
            }

            new_item.set_macd (macd);

            data.append_val (new_item);
            
        }

    }

}
