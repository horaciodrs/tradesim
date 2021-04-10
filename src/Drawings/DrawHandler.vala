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

public class TradeSim.Drawings.DrawHandler {

    public weak TradeSim.Drawings.Line parent;

    public enum Position {
        TOP,
        BOTTOM
    }

    public TradeSim.Widgets.Canvas ref_canvas;

    private bool visible;

    public DrawHandler (TradeSim.Drawings.Line _line){
        parent = _line;
        ref_canvas = parent.ref_canvas;
        visible = true;
    }

    public void draw (Cairo.Context ctext) {

        if (!visible) {
            return;
        }

        var circle_color = new TradeSim.Utils.Color (54, 134, 230);
        var x1c = parent.get_x1 ();
        var y1c = ref_canvas.get_pos_y_by_price (parent.get_y1 ());
        var radius = 10;

        circle_color.apply_to (ctext);
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1.0);
        ctext.arc (x1c, y1c, radius, 0, 2 * Math.PI);
        ctext.fill ();

        var x2c = parent.get_x2 ();
        var y2c = ref_canvas.get_pos_y_by_price (parent.get_y2 ());

        circle_color.apply_to (ctext);
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1.0);
        ctext.arc (x2c, y2c, radius, 0, 2 * Math.PI);
        ctext.fill ();

    }

    public void set_visible ( bool _visible) {
        visible = _visible;
    }

    public bool get_visible () {
        return visible;
    }

    public bool collision_check (int _position = 0){

        int radius = 10;

        if (visible == false) {
            return false;
        }

        switch(_position){
            case TradeSim.Drawings.DrawHandler.Position.TOP:
                var x1c = parent.get_x1 ();
                var y1c = ref_canvas.get_pos_y_by_price (parent.get_y1 ());
                if ((ref_canvas.mouse_x > x1c -radius) && (ref_canvas.mouse_x < x1c + radius)){
                    if ((ref_canvas.mouse_y > y1c -radius) && (ref_canvas.mouse_y < y1c + radius)){
                        return true;
                    }
                }
                break;
            case TradeSim.Drawings.DrawHandler.Position.BOTTOM:
                var x2c = parent.get_x2 ();
                var y2c = ref_canvas.get_pos_y_by_price (parent.get_y2 ());
                if ((ref_canvas.mouse_x > x2c -radius) && (ref_canvas.mouse_x < x2c + radius)){
                    if ((ref_canvas.mouse_y > y2c -radius) && (ref_canvas.mouse_y < y2c + radius)){
                        return true;
                    }
                }
                break;
        }

        return false;

    }

}
