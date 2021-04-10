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

public class TradeSim.Services.Drawings {

    public weak TradeSim.Widgets.Canvas ref_canvas;
    public weak TradeSim.Widgets.OscilatorCanvas ref_oscilator_canvas;

    public enum Type {
        LINE
        , HLINE
        , RECTANGLE
        , FIBONACCI
        , OPERATION_INFO
        , INDICATOR
    }

    public enum Thickness {
        EXTRA_FINE
        , VERY_FINE
        , FINE
        , THICK
        , VERY_THICK
    }

    public bool drawing_mode; // Indica si se esta dibujando algo.

    public Array<TradeSim.Drawings.Line> lines;
    public Array<TradeSim.Drawings.Fibonacci> fibonacci;
    public Array<TradeSim.Drawings.Rectangle> rectangles;
    public Array<TradeSim.Drawings.HLine> hlines;
    public Array<TradeSim.Drawings.OperationInfo> operations;
    public Array<TradeSim.Drawings.Indicators.Indicator> indicators;

    public Drawings (TradeSim.Widgets.Canvas _canvas, TradeSim.Widgets.OscilatorCanvas _oscilator_canvas) {

        ref_canvas = _canvas;
        ref_oscilator_canvas = _oscilator_canvas;

        lines = new Array<TradeSim.Drawings.Line> ();
        fibonacci = new Array<TradeSim.Drawings.Fibonacci> ();
        rectangles = new Array<TradeSim.Drawings.Rectangle> ();
        hlines = new Array<TradeSim.Drawings.HLine> ();
        operations = new Array<TradeSim.Drawings.OperationInfo> ();
        indicators = new Array<TradeSim.Drawings.Indicators.Indicator> ();

    }

    public void show_all (Cairo.Context ctext) {

        for (int i = 0 ; i < lines.length ; i++) {
            lines.index (i).render (ctext);
        }

        for (int z = 0 ; z < fibonacci.length ; z++) {
            fibonacci.index (z).render (ctext);
        }

        for (int z = 0 ; z < rectangles.length ; z++) {
            rectangles.index (z).render (ctext);
        }

        for (int z = 0 ; z < hlines.length ; z++) {
            hlines.index (z).render (ctext);
        }

        for (int z = 0 ; z < operations.length ; z++) {
            operations.index (z).render (ctext);
        }

    }

    public void render_indicators_by_candle (Cairo.Context ctext, int i) {

        for (int z = 0 ; z < indicators.length ; z++) {

            var indicator_type = indicators.index (z).properties;

            if (indicator_type.get_int("type") <= TradeSim.Drawings.Indicators.Indicator.Type.BOLLINGER_BANDS){
                indicators.index (z).render_by_candle (ctext, i);
            }
            
        }
        
    }

    public void render_oscilators_by_candle (Cairo.Context ctext, int i) {

        for (int z = 0 ; z < indicators.length ; z++) {

            var indicator_type = indicators.index (z).properties;

            if (indicator_type.get_int("type") > TradeSim.Drawings.Indicators.Indicator.Type.BOLLINGER_BANDS){
                //indicators.index (z).render_by_candle (ctext, i);
                indicators.index (z).render (ctext);
            }
            
        }
        
    }

    public void indicators_calculate_last_candle () {

        for (int z = 0 ; z < indicators.length ; z++) {

            indicators.index (z).calculate_last_candle ();

        }

    }

    public void show_all_in_vertical_scale (Cairo.Context ctext) {

        for (int z = 0 ; z < hlines.length ; z++) {
            hlines.index (z).render_vertical_scale (ctext);
        }

        for (int z = 0 ; z < operations.length ; z++) {
            operations.index (z).render_vertical_scale (ctext);
        }

    }

    public void check_handlers_on_mouse_down (){

        // Esta función es llamada desde el canvas cuando el mouse es precionado.
        // Se encarga de verificar si el puntero del mouse fue presionado
        // de tal manera que se active el handler correspondiente a un dibujo determinado.
        // En caso de detectarse esa situación ese dibujo debe recibir las coordenadas
        // del mouse para redibujarse nuevamente según lo indica el puntero del mouse.

        // Para esto vamos a utilizar una variable(re_draw=true) que se encuentra en cada tipo
        // de dibujo para determinar si este se tiene o no que redibujar.

        // Luego otra función se encargara de recorrer todos los dibujos
        // y redibujar los que corresponda desde la funcion on_mouse_over del canvas.
        // y por ultimo la funcion on_mouse_up del canvas pondra todos los dibujos
        // en el estado en que no se redibujan (re_draw=false).

        for (int i = 0 ; i < lines.length ; i++) {
            if(lines.index (i).get_handler_collision_check (TradeSim.Drawings.DrawHandler.Position.TOP) == true){
                lines.index (i).set_re_draw (true);
                lines.index (i).set_re_draw_bottom (false);
            }else if(lines.index (i).get_handler_collision_check (TradeSim.Drawings.DrawHandler.Position.BOTTOM) == true){
                lines.index (i).set_re_draw (false);
                lines.index (i).set_re_draw_bottom (true);
            }
        }

        for (int i = 0 ; i < fibonacci.length ; i++) {
            if(fibonacci.index (i).get_handler_collision_check (TradeSim.Drawings.DrawHandler.Position.TOP) == true){
                fibonacci.index (i).set_re_draw (true);
                fibonacci.index (i).set_re_draw_bottom (false);
            }else if(fibonacci.index (i).get_handler_collision_check (TradeSim.Drawings.DrawHandler.Position.BOTTOM) == true){
                fibonacci.index (i).set_re_draw (false);
                fibonacci.index (i).set_re_draw_bottom (true);
            }
        }

        for (int i = 0 ; i < rectangles.length ; i++) {
            if(rectangles.index (i).get_handler_collision_check (TradeSim.Drawings.DrawHandler.Position.TOP) == true){
                rectangles.index (i).set_re_draw (true);
                rectangles.index (i).set_re_draw_bottom (false);
            }else if(rectangles.index (i).get_handler_collision_check (TradeSim.Drawings.DrawHandler.Position.BOTTOM) == true){
                rectangles.index (i).set_re_draw (false);
                rectangles.index (i).set_re_draw_bottom (true);
            }
        }

    }

    public void handlers_on_mouse_over (DateTime d1, double p1) {

        for (int i = 0 ; i < lines.length ; i++) {
            if(lines.index (i).get_re_draw () == true) {
                lines.index (i).set_x1 (d1);
                lines.index (i).set_y1 (p1);
            }else if(lines.index (i).get_re_draw_bottom () == true) {
                lines.index (i).set_x2 (d1);
                lines.index (i).set_y2 (p1);
            }
        }

        for (int i = 0 ; i < fibonacci.length ; i++) {
            if(fibonacci.index (i).get_re_draw () == true) {
                fibonacci.index (i).set_x1 (d1);
                fibonacci.index (i).set_y1 (p1);
            }else if(fibonacci.index (i).get_re_draw_bottom () == true) {
                fibonacci.index (i).set_x2 (d1);
                fibonacci.index (i).set_y2 (p1);
            }
        }

        for (int i = 0 ; i < rectangles.length ; i++) {
            if(rectangles.index (i).get_re_draw () == true) {
                rectangles.index (i).set_x1 (d1);
                rectangles.index (i).set_y1 (p1);
            }else if(rectangles.index (i).get_re_draw_bottom () == true) {
                rectangles.index (i).set_x2 (d1);
                rectangles.index (i).set_y2 (p1);
            }
        }

    }

    public void handlers_on_mouse_up () {

        for (int i = 0 ; i < lines.length ; i++) {
            lines.index (i).set_re_draw (false);
            lines.index (i).set_re_draw_bottom (false);

            if (lines.index (i).get_handler_visible () == true){
                if (lines.index (i).mouse_over (ref_canvas.mouse_x, ref_canvas.mouse_y) == false){
                    lines.index (i).set_handler_visible (false);
                }
            }else{
                if (lines.index (i).mouse_over (ref_canvas.mouse_x, ref_canvas.mouse_y) == true){
                    lines.index (i).set_handler_visible (true);
                }
            }

        }

        for (int i = 0 ; i < fibonacci.length ; i++) {

            fibonacci.index (i).set_re_draw (false);
            fibonacci.index (i).set_re_draw_bottom (false);

            if (fibonacci.index (i).get_handler_visible () == true){
                if (fibonacci.index (i).mouse_over (ref_canvas.mouse_x, ref_canvas.mouse_y) == false){
                    fibonacci.index (i).set_handler_visible (false);
                }
            }else{
                if (fibonacci.index (i).mouse_over (ref_canvas.mouse_x, ref_canvas.mouse_y) == true){
                    fibonacci.index (i).set_handler_visible (true);
                }
            }
        }

        for (int i = 0 ; i < rectangles.length ; i++) {

            rectangles.index (i).set_re_draw (false);
            rectangles.index (i).set_re_draw_bottom (false);

            if (rectangles.index (i).get_handler_visible () == true){
                if (rectangles.index (i).mouse_over (ref_canvas.mouse_x, ref_canvas.mouse_y) == false){
                    rectangles.index (i).set_handler_visible (false);
                }
            }else{
                if (rectangles.index (i).mouse_over (ref_canvas.mouse_x, ref_canvas.mouse_y) == true){
                    rectangles.index (i).set_handler_visible (true);
                }
            }

        }

    }

    public void draw_operation (TradeSim.Objects.OperationItem _op) {

        // Esta función debe ser llamada cada vez que se crea o modifica
        // una operación.

        string _id = "operation" + _op.id.to_string ();
        var new_operation = operation_exists (_id);
        bool is_new_operation = false;

        if (new_operation == null) {
            new_operation = new TradeSim.Drawings.OperationInfo (ref_canvas, _id);
            is_new_operation = true;
        }

        new_operation.set_data (_op);

        if (is_new_operation) {
            operations.append_val (new_operation);
        }

    }

    public void draw_hline (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_hline = hline_exists (_id);
        bool is_new_hline = false;

        if (new_hline == null) {
            new_hline = new TradeSim.Drawings.HLine (ref_canvas, _id);
            is_new_hline = true;
        }

        if (new_hline.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_hline.set_x1 (d1);
            new_hline.set_x2 (d1);
            new_hline.set_y1 (p1);
            new_hline.set_y2 (p1);
        } else {
            new_hline.set_x2 (d2);
            new_hline.set_y2 (p2);
        }

        if (is_new_hline) {
            hlines.append_val (new_hline);
        }

    }

    public void draw_rectangle (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_rectangle = rectangle_exists (_id);
        bool is_new_rectangle = false;

        if (new_rectangle == null) {
            new_rectangle = new TradeSim.Drawings.Rectangle (ref_canvas, _id);
            is_new_rectangle = true;
        }

        if (new_rectangle.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_rectangle.set_x1 (d1);
            new_rectangle.set_x2 (d1);
            new_rectangle.set_y1 (p1);
            new_rectangle.set_y2 (p1);
        } else {
            new_rectangle.set_x2 (d2);
            new_rectangle.set_y2 (p2);
        }

        if (is_new_rectangle) {
            rectangles.append_val (new_rectangle);
        }

    }

    public void draw_fibonacci (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_fibo = fibo_exists (_id);
        bool is_new_fibo = false;

        if (new_fibo == null) {
            new_fibo = new TradeSim.Drawings.Fibonacci (ref_canvas, _id);
            is_new_fibo = true;
        }



        if (new_fibo.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_fibo.set_x1 (d1);
            new_fibo.set_x2 (d1);
            new_fibo.set_y1 (p1);
            new_fibo.set_y2 (p1);
        } else {
            new_fibo.set_x2 (d2);
            new_fibo.set_y2 (p2);
        }

        if (is_new_fibo) {
            fibonacci.append_val (new_fibo);
        }

    }

    public void draw_line (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_line = line_exists (_id);
        bool is_new_line = false;

        if (new_line == null) {
            new_line = new TradeSim.Drawings.Line (ref_canvas, _id);
            is_new_line = true;
        }

        if (new_line.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_line.set_x1 (d1);
            new_line.set_x2 (d1);
            new_line.set_y1 (p1);
            new_line.set_y2 (p1);
        } else {
            new_line.set_x2 (d2);
            new_line.set_y2 (p2);
        }

        if (is_new_line) {
            lines.append_val (new_line);
        }

    }

    public void draw_indicator (string _id, Array<TradeSim.Drawings.Indicators.IndicatorProperty> properties) {

        var new_indicator = indicator_exists (_id);
        bool is_new_indicator = false;

        if (new_indicator == null) {

            var Propiedades = new TradeSim.Drawings.Indicators.PropertyManager (properties);

            if (Propiedades.get_int ("type") == TradeSim.Drawings.Indicators.Indicator.Type.SMA) {
                new_indicator = new TradeSim.Drawings.Indicators.Sma (ref_canvas, ref_oscilator_canvas, _id, properties);
            } else if (Propiedades.get_int ("type") == TradeSim.Drawings.Indicators.Indicator.Type.BOLLINGER_BANDS) {
                new_indicator = new TradeSim.Drawings.Indicators.BollingerBands (ref_canvas, ref_oscilator_canvas, _id, properties);
            } else if (Propiedades.get_int ("type") == TradeSim.Drawings.Indicators.Indicator.Type.RSI) {
                new_indicator = new TradeSim.Drawings.Indicators.Rsi (ref_canvas, ref_oscilator_canvas, _id, properties);
            } else if (Propiedades.get_int ("type") == TradeSim.Drawings.Indicators.Indicator.Type.MACD) {
                new_indicator = new TradeSim.Drawings.Indicators.MacD (ref_canvas, ref_oscilator_canvas, _id, properties);
            }

            new_indicator.calculate ();

            is_new_indicator = true;

        }

        if (is_new_indicator) {
            indicators.append_val (new_indicator);
        }

    }

    public TradeSim.Drawings.Line ? line_exists (string _id) {

        for (int i = 0 ; i < lines.length ; i++) {
            if (lines.index (i).id == _id) {
                return lines.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.Fibonacci ? fibo_exists (string _id) {

        for (int i = 0 ; i < fibonacci.length ; i++) {
            if (fibonacci.index (i).id == _id) {
                return fibonacci.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.Rectangle ? rectangle_exists (string _id) {

        for (int i = 0 ; i < rectangles.length ; i++) {
            if (rectangles.index (i).id == _id) {
                return rectangles.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.HLine ? hline_exists (string _id) {

        for (int i = 0 ; i < hlines.length ; i++) {
            if (hlines.index (i).id == _id) {
                return hlines.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.OperationInfo ? operation_exists (string _id) {

        for (int i = 0 ; i < operations.length ; i++) {
            if (operations.index (i).id == _id) {
                return operations.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.Indicators.Indicator ? indicator_exists (string _id) {

        for (int i = 0 ; i < lines.length ; i++) {
            if (indicators.index (i).id == _id) {
                return indicators.index (i);
            }
        }

        return null;

    }

    public void set_draw_color (string _id, int _type, Gdk.RGBA _c) {

        var _color = new TradeSim.Utils.Color.with_rgba (_c);

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.index (i).set_color (_color);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.index (i).set_color (_color);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.index (i).set_color (_color);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.index (i).set_color (_color);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.index (i).set_color (_color);
                    break;
                }
            }
        }
    }

    public TradeSim.Utils.Color get_draw_color (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    return lines.index (i).get_color ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    return hlines.index (i).get_color ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    return fibonacci.index (i).get_color ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    return rectangles.index (i).get_color ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    return indicators.index (i).get_color ();
                }
            }
        }

        return new TradeSim.Utils.Color.default ();
    }

    public TradeSim.Drawings.Indicators.PropertyManager get_indicator_properties (string _id, int _type) {

        var return_value = new TradeSim.Drawings.Indicators.PropertyManager(new Array<TradeSim.Drawings.Indicators.IndicatorProperty>());

        for (int i = 0 ; i < indicators.length ; i++) {

            if (indicators.index (i).id == _id) {
                return_value = indicators.index (i).properties;
                break;
            }

        }

        return return_value;

    }

    public void set_draw_thickness (string _id, int _type, int _thicness) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.index (i).set_thickness (_thicness);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.index (i).set_thickness (_thicness);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.index (i).set_thickness (_thicness);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.index (i).set_thickness (_thicness);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.index (i).set_thickness (_thicness);
                    break;
                }
            }
        }
    }

    public int get_draw_thicness (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    return lines.index (i).get_thicness ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    return hlines.index (i).get_thicness ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    return fibonacci.index (i).get_thicness ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    return rectangles.index (i).get_thicness ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    return indicators.index (i).get_thicness ();
                }
            }
        }

        return TradeSim.Services.Drawings.Thickness.FINE;

    }

    public void set_draw_name (string _id, int _type, string _new_name) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.index (i).id = _new_name;
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.index (i).id = _new_name;
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.index (i).id = _new_name;
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.index (i).id = _new_name;
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.index (i).id = _new_name;
                    break;
                }
            }
        }
    }

    public double get_draw_alpha (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    return lines.index (i).get_alpha ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    return hlines.index (i).get_alpha ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    return fibonacci.index (i).get_alpha ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    return rectangles.index (i).get_alpha ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    return indicators.index (i).get_alpha ();
                }
            }
        }

        return 1.0;

    }

    public void set_draw_alpha (string _id, int _type, double _alpha) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.index (i).set_alpha (_alpha);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.index (i).set_alpha (_alpha);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.index (i).set_alpha (_alpha);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.index (i).set_alpha (_alpha);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.index (i).set_alpha (_alpha);
                    break;
                }
            }
        }
    }

    public void set_draw_visible (string _id, int _type, bool _visible) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.index (i).set_visible (_visible);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.index (i).set_visible (_visible);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.index (i).set_visible (_visible);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.index (i).set_visible (_visible);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.index (i).set_visible (_visible);
                    break;
                }
            }
        }
    }

    public bool get_draw_visible (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    return lines.index (i).get_visible ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    return hlines.index (i).get_visible ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    return fibonacci.index (i).get_visible ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    return rectangles.index (i).get_visible ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    return indicators.index (i).get_visible ();
                }
            }
        }

        return false;

    }

    // -------------------------------------->

    public void set_draw_enabled (string _id, int _type, bool _enabled) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.index (i).set_enabled (_enabled);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.index (i).set_enabled (_enabled);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.index (i).set_enabled (_enabled);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.index (i).set_enabled (_enabled);
                    break;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.index (i).set_enabled (_enabled);
                    break;
                }
            }
        }
    }

    public bool get_draw_enabled (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    return lines.index (i).get_enabled ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    return hlines.index (i).get_enabled ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    return fibonacci.index (i).get_enabled ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    return rectangles.index (i).get_enabled ();
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    return indicators.index (i).get_enabled ();
                }
            }
        }

        return false;

    }

    // --------------------------------------<

    public void delete_draw (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    lines.remove_index (i);
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    hlines.remove_index (i);
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    fibonacci.remove_index (i);
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    rectangles.remove_index (i);
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    indicators.remove_index (i);
                }
            }
        }
    }

    public void write_file (Xml.TextWriter writer) throws FileError {

        writer.start_element ("drawings");

        writer.start_element ("fibonaccies");
        for (int i = 0 ; i < fibonacci.length ; i++) {
            fibonacci.index (i).write_file (writer);
        }
        writer.end_element ();

        writer.start_element ("hlines");
        for (int i = 0 ; i < hlines.length ; i++) {
            hlines.index (i).write_file (writer);
        }
        writer.end_element ();

        writer.start_element ("lines");
        for (int i = 0 ; i < lines.length ; i++) {
            lines.index (i).write_file (writer, true);
        }
        writer.end_element ();

        writer.start_element ("rectangles");
        for (int i = 0 ; i < rectangles.length ; i++) {
            rectangles.index (i).write_file (writer);
        }
        writer.end_element ();

        writer.end_element ();

    }

    public bool exists_handler_visible () {

        for (int i = 0 ; i < lines.length ; i++) {
            if(lines.index (i).get_handler_visible ()) {
                return true;
            }
        }

        for (int i = 0 ; i < hlines.length ; i++) {
            if(hlines.index (i).get_handler_visible ()) {
                return true;
            }
        }

        for (int i = 0 ; i < fibonacci.length ; i++) {
            if(fibonacci.index (i).get_handler_visible ()) {
                return true;
            }
        }

        for (int i = 0 ; i < rectangles.length ; i++) {
            if(rectangles.index (i).get_handler_visible ()) {
                return true;
            }
        }

        return false;

    }

    public void set_handler_visible_toggle (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    if(lines.index (i).get_handler_visible ()) {
                        lines.index (i).set_handler_visible (false);
                    }else{
                        lines.index (i).set_handler_visible (true);
                    }
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    if(hlines.index (i).get_handler_visible ()) {
                        hlines.index (i).set_handler_visible (false);
                    }else{
                        hlines.index (i).set_handler_visible (true);
                    }
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    if(fibonacci.index (i).get_handler_visible ()) {
                        fibonacci.index (i).set_handler_visible (false);
                    }else{
                        fibonacci.index (i).set_handler_visible (true);
                    }
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    if(rectangles.index (i).get_handler_visible ()) {
                        rectangles.index (i).set_handler_visible (false);
                    }else{
                        rectangles.index (i).set_handler_visible (true);
                    }
                }
            }
        }

    }

    public bool exists (string _id, int _type) {

        if (_type == TradeSim.Services.Drawings.Type.LINE) {
            for (int i = 0 ; i < lines.length ; i++) {
                if (lines.index (i).id == _id) {
                    return true;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.HLINE) {
            for (int i = 0 ; i < hlines.length ; i++) {
                if (hlines.index (i).id == _id) {
                    return true;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            for (int i = 0 ; i < fibonacci.length ; i++) {
                if (fibonacci.index (i).id == _id) {
                    return true;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            for (int i = 0 ; i < rectangles.length ; i++) {
                if (rectangles.index (i).id == _id) {
                    return true;
                }
            }
        } else if (_type == TradeSim.Services.Drawings.Type.INDICATOR) {
            for (int i = 0 ; i < indicators.length ; i++) {
                if (indicators.index (i).id == _id) {
                    return true;
                }
            }
        }

        return false;

    }

}
