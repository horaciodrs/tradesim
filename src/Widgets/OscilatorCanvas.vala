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

 public class TradeSim.Widgets.OscilatorCanvas : Gtk.DrawingArea {

    public weak TradeSim.MainWindow main_window;

    public TradeSim.Utils.ColorPalette color_palette;

    public int _width;
    public int _height;
    public int mouse_x;
    public int mouse_y;

    public int vertical_scale_width;

    public OscilatorCanvas (TradeSim.MainWindow window) {

        main_window = window;

        vertical_scale_width = 55;

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);

        motion_notify_event.connect (on_mouse_over);

        init ();

    }

    public void init () {

        color_palette = new TradeSim.Utils.ColorPalette ();

        if (main_window.settings.get_boolean ("window-dark-theme") == true) {
            color_palette.set_dark_mode ();
        } else {
            color_palette.set_light_mode ();
        }

    }

    public bool on_mouse_over (Gdk.EventMotion event) {

        mouse_x = (int) event.x;
        mouse_y = (int) event.y;

        get_window ().set_cursor (new Gdk.Cursor.for_display (Gdk.Display.get_default (), Gdk.CursorType.CROSS));

        return true;

    }

    public void draw_cross_lines (Cairo.Context ctext) {

        // horizontal
        ctext.set_dash ({ 5.0 }, 0);
        ctext.set_line_width (0.2);
        color_palette.canvas_cross_line.apply_to (ctext);
        ctext.move_to (0, mouse_y);
        ctext.line_to (_width, mouse_y);
        ctext.stroke ();

        // vertical
        ctext.set_line_width (0.2);
        color_palette.canvas_cross_line.apply_to (ctext);
        ctext.move_to (mouse_x, 0);
        ctext.line_to (mouse_x, _height);
        ctext.stroke ();

    }

    public void draw_line_color (Cairo.Context ctext, int x1, int y1, int x2, int y2, double size, TradeSim.Utils.Color line_color, bool dash = false, double dash_type = 5.0) {

        ctext.set_dash ({}, 0);

        if (dash) {
            ctext.set_dash ({ dash_type }, 0);
        }

        ctext.set_line_width (size);
        line_color.apply_to (ctext);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }

    public void write_text_color (Cairo.Context ctext, int x, int y, string txt, TradeSim.Utils.Color txt_color) {

        Pango.Layout layout;

        layout = create_pango_layout (txt);

        txt_color.apply_to (ctext);
        ctext.move_to (x, y);
        Pango.cairo_update_layout (ctext, layout);
        Pango.cairo_show_layout (ctext, layout);

        queue_draw ();

    }

    public void draw_vertical_scale (Cairo.Context ctext) {

        ctext.set_dash ({}, 0);

        color_palette.canvas_vertical_scale_bg.apply_to (ctext);
        ctext.rectangle (_width - vertical_scale_width, 0, vertical_scale_width, _height);
        ctext.fill ();
        ctext.stroke ();

        ctext.set_line_width (1);
        color_palette.canvas_border.apply_to (ctext);
        ctext.move_to (_width - vertical_scale_width, 0);
        ctext.line_to (_width - vertical_scale_width, _height);
        ctext.stroke ();

    }

    public int get_posy_by_p100 (double p100) {

        double p = 100 - p100;
        int padding = 20;
        int available_height = _height - padding * 2;

        return (int) (padding + available_height * p / 100.00);

    }

    public int get_posy_by_range (double value, double min, double max) {

        //Pensado para el macd donde el centro del espacio vertical representa el cero.

        int padding = 20;
        int available_height = _height - padding * 2;
        int center = (int)(available_height / 2); //Tambien representa el recorrido positivo y negativo.

        int center_dy = 0;

        if (value >= 0) {
            center_dy = (int) (value * center / max);
            return padding + center - center_dy;
        }else{
            center_dy = (int) (value * center / min);
            return padding + center + center_dy;
        }

    }

    public int get_range_center (){

        int padding = 20;
        int available_height = _height - padding * 2;
        int center = (int)(available_height / 2);

        return center + padding;

    }

    public void draw_bg (Cairo.Context ctext) {

        color_palette.canvas_bg.apply_to (ctext);
        ctext.rectangle (0, 0, _width, _height);
        ctext.fill ();
        ctext.stroke ();

    }

    /*public void draw_bg (Cairo.Context ctext) {

    }*/

    public override bool draw (Cairo.Context ctext) {

        _width = get_allocated_width ();
        _height = get_allocated_height ();

        draw_bg (ctext);
        draw_vertical_scale (ctext);

        var canvas = main_window.main_layout.current_canvas;

        if (canvas != null) {
            var dm = canvas.draw_manager;
            dm.render_oscilators_by_candle (ctext, canvas.drawed_candle_position-1);
            canvas.queue_draw ();
        }

        draw_cross_lines (ctext);

        return true;

    }

}