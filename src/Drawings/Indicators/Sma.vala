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

 public class TradeSim.Drawings.Indicators.SmaDataItem {
    
    private double ? avg;

    public SmaDataItem (double ? _avg) {
        avg = _avg;
    }

    public void set_data (double _avg) {
        avg = _avg;
    }

    public double ? get_data () {
        return avg;
    }

 }

 public class TradeSim.Drawings.Indicators.Sma : TradeSim.Drawings.Indicators.Indicator {

    private Array<TradeSim.Drawings.Indicators.SmaDataItem> data;  //El indice se corresponde con la vela (fecha) y el valor es el promedio calculado para ser representado.
    private int periods;

    public Sma (TradeSim.Widgets.Canvas canvas, TradeSim.Widgets.OscilatorCanvas _oscilator_canvas, string _id, Array<TradeSim.Drawings.Indicators.IndicatorProperty> _properties) {

        base (canvas, _oscilator_canvas, _id, _properties);

        periods = properties.get_int ("period");

        data = new Array<TradeSim.Drawings.Indicators.SmaDataItem> ();

        calculate ();

    }

    public Sma.default () {
        base.default ();
    }

    public override void render_by_candle (Cairo.Context ctext, int i) {

        if (!visible){
            return;
        }

        if(i > 1){

            if (data.index(i - 1).get_data () == 0){
                return;
            }

            int x1 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i - 1).date_time);
            int x2 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i).date_time);
            int y1 = ref_canvas.get_pos_y_by_price (data.index(i-1).get_data ());
            int y2 = ref_canvas.get_pos_y_by_price (data.index(i).get_data ());

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

        int from = ref_canvas.data.get_quote_index_by_time (ref_canvas.date_from);
        int to = from + ref_canvas.drawed_candles;

        for (int i = from; i < to; i++) {

            render_by_candle (ctext, i);
            
        }

    }

    public override void calculate_last_candle () {

        periods = properties.get_int ("period");

        int i = (int) (ref_canvas.data.quotes.length - 1);

        var new_item = new TradeSim.Drawings.Indicators.SmaDataItem (get_average (i));
        data.append_val (new_item);
        
    }

    public override void calculate () {

        //Esta función toma todas las velas cargadas en memoria
        //y calcula la media movil simple en el array avg.

        periods = properties.get_int ("period");

        data.remove_range (0, data.length);

        for (int i = 0; i < ref_canvas.data.quotes.length; i++) {
            var new_item = new TradeSim.Drawings.Indicators.SmaDataItem (get_average (i));
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

}
