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

public class TradeSim.Drawings.Indicators.IndicatorProperty {

    public string name;
    public Value value;

    public IndicatorProperty (string _name, Value _value) {
        name = _name;
        value = _value;
    }



}

public class TradeSim.Drawings.Indicators.PropertyManager {

    public Array<TradeSim.Drawings.Indicators.IndicatorProperty> properties;

    public PropertyManager (Array<TradeSim.Drawings.Indicators.IndicatorProperty> _properties) {
        properties = _properties;
    }

    public int get_int (string _name) {

        int return_value = 0;

        for(int i=0; i < properties.length; i++){
            if (properties.index (i).name == _name){
                return_value  = properties.index (i).value.get_int ();
                break;
            }
        }

        return return_value;

    }

    public double get_double (string _name) {

        double return_value = 0;

        for(int i=0; i < properties.length; i++){
            if (properties.index (i).name == _name){
                return_value  = properties.index (i).value.get_double ();
                break;
            }
        }

        return return_value;

    }

    public void set_int (string _name, int _value) {

        for(int i=0; i < properties.length; i++){
            if (properties.index (i).name == _name){
                properties.index (i).value.set_int (_value);
                return;
            }
        }

    }

    public void set_double (string _name, double _value) {

        for(int i=0; i < properties.length; i++){
            if (properties.index (i).name == _name){
                properties.index (i).value.set_double (_value);
                return;
            }
        }

    }

}

public class TradeSim.Drawings.Indicators.Indicator {

    public enum Type {
        SMA
        , EMA
        , BOLLINGER_BANDS
        , RSI
        , MACD
    }

    public weak TradeSim.Widgets.Canvas ? ref_canvas;
    public weak TradeSim.Widgets.OscilatorCanvas ? ref_oscilator_canvas;

    public string id;
    public TradeSim.Drawings.Indicators.PropertyManager properties;

    protected TradeSim.Utils.Color color;
    protected int thickness;

    protected bool visible;
    protected bool enabled;

    public Indicator (TradeSim.Widgets.Canvas _canvas, TradeSim.Widgets.OscilatorCanvas _oscilator_canvas, string _id, Array<TradeSim.Drawings.Indicators.IndicatorProperty> _properties) {
        id = _id;
        ref_canvas = _canvas;
        ref_oscilator_canvas = _oscilator_canvas;
        properties = new TradeSim.Drawings.Indicators.PropertyManager (_properties);
        color = new TradeSim.Utils.Color.with_alpha (properties.get_int("color_red"), properties.get_int("color_green"), properties.get_int("color_blue"), properties.get_double("color_alpha"));
        thickness = properties.get_int("thickness");
        visible = true;
        enabled = true;
    }

    public Indicator.default () {

    }

    public virtual void calculate () {

    }

    public virtual void calculate_last_candle () {
        
    }

    public virtual void render_by_candle (Cairo.Context ctext, int i) {
        
    }

    public virtual void render (Cairo.Context ctext) {

    }

    public void set_ref_canvas (TradeSim.Widgets.Canvas _canvas) {
        ref_canvas = _canvas;
    }

    public void set_id (string _id) {
        id = _id;
    }

    public void set_thickness (int _thicness) {
        thickness = _thicness;
    }

    public void set_color (TradeSim.Utils.Color _color) {
        color = _color;
    }

    public TradeSim.Utils.Color get_color () {
        return color;
    }

    public int get_thicness () {
        return thickness;
    }

    public void set_alpha (double _alpha) {
        color.alpha = _alpha;
    }

    public double get_alpha () {
        return color.alpha;
    }

    public bool get_visible () {
        return visible;
    }

    public void set_visible (bool _state) {
        visible = _state;
    }

    public bool get_enabled () {
        return enabled;
    }

    public void set_enabled (bool _enabled) {
        enabled = _enabled;
    }

}