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

 public class TradeSim.Drawings.Indicators.RsiDataItem {
    
    private double ? rsi;

    public RsiDataItem () {
    }

    public string to_string () {
        return "testing...\n";
    }

    public void set_rsi (double ? _rsi) {
        rsi = _rsi;
    }

    public double ? get_rsi () {

        return rsi;
    }

 }

 public class TradeSim.Drawings.Indicators.Rsi : TradeSim.Drawings.Indicators.Indicator {

    private Array<TradeSim.Drawings.Indicators.RsiDataItem> data;  //El indice se corresponde con la vela (fecha) y el valor es el promedio calculado para ser representado.
    private int periods;

    public Rsi (TradeSim.Widgets.Canvas canvas, TradeSim.Widgets.OscilatorCanvas _oscilator_canvas, string _id, Array<TradeSim.Drawings.Indicators.IndicatorProperty> _properties) {

        base (canvas, _oscilator_canvas, _id, _properties);

        periods = properties.get_int ("period");

        data = new Array<TradeSim.Drawings.Indicators.RsiDataItem> ();

        calculate ();

    }

    public Rsi.default () {
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

            int x1 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i - 1).date_time);
            int x2 = ref_canvas.get_pos_x_by_date (ref_canvas.data.quotes.index(i).date_time);            
            int y1 = ref_oscilator_canvas.get_posy_by_p100 (data.index(i-1).get_rsi ());
            int y2 = ref_oscilator_canvas.get_posy_by_p100 (data.index(i).get_rsi ());

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

        periods = properties.get_int ("period");

        data.remove_range (0, data.length);

        for (int i = 0; i < ref_canvas.data.quotes.length; i++) {
            
            var new_item = new TradeSim.Drawings.Indicators.RsiDataItem ();
            
            double rsi = 1.00;

            if (periods > i){
                rsi = 0.00;
            }else {

                int start = i - periods;
                int end = start + periods;

                double precio_actual_up = ref_canvas.data.quotes.index (start).close_price;
                double precio_actual_down = ref_canvas.data.quotes.index (start).close_price;
                double sum_up = 0.00;
                double sum_down = 0.00;
                double avg_up = 0.00;
                double avg_down = 0.00;
                double rs = 0.00;

                for (int z = start; z < end; z++){
                    if(ref_canvas.data.quotes.index (z).close_price > precio_actual_up){
                        sum_up += ref_canvas.data.quotes.index (z).close_price - precio_actual_up;
                        precio_actual_up = ref_canvas.data.quotes.index (z).close_price;
                    }

                    if(ref_canvas.data.quotes.index (z).close_price < precio_actual_down){
                        sum_down += precio_actual_down - ref_canvas.data.quotes.index (z).close_price;
                        precio_actual_down = ref_canvas.data.quotes.index (z).close_price;
                    }
                }

                avg_up = sum_up / periods;
                avg_down = sum_down / periods;
                rs = avg_up / avg_down;
                rsi = 100.00 - 100.00 / (1.00 + rs);

            }

            new_item.set_rsi (rsi);

            data.append_val (new_item);
            
        }

    }

}
