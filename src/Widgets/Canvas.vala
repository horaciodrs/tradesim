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


/*
   TEMA DE COLORES

   PARA CAMBIAR EL COLOR SEGUN SI SE USA EL TEMA OSCURO O NO...
   UTILIZO UN ARRAY DONDE GUARDO POR RGB CADA TEMA.

   theme_type {0, 1}   0: Normal, 1: DarkVariant

   canvas_background_theme_red[theme_type]
   canvas_background_theme_green[theme_type]
   canvas_background_theme_blue[theme_type]

   canvas_candle_up_bg_theme_red[theme_type]
   canvas_candle_up_bg_theme_green[theme_type]
   canvas_candle_up_bg_theme_blue[theme_type]

   canvas_candle_up_brd_theme_red[theme_type]
   canvas_candle_up_brd_theme_green[theme_type]
   canvas_candle_up_brd_theme_blue[theme_type]

   canvas_candle_down_bg_theme_red[theme_type]
   canvas_candle_down_bg_theme_green[theme_type]
   canvas_candle_down_bg_theme_blue[theme_type]

   canvas_candle_down_brd_theme_red[theme_type]
   canvas_candle_down_brd_theme_green[theme_type]
   canvas_candle_down_brd_theme_blue[theme_type]

 */

public class TradeSim.Widgets.Canvas : Gtk.DrawingArea {

    public weak TradeSim.MainWindow main_window;

    public int _width;
    public int _height;
    public int mouse_x;
    public int mouse_y;

    public bool show_cross_lines;

    public Canvas (TradeSim.MainWindow window) {

        main_window = window;

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);

        motion_notify_event.connect (this.on_mouse_over);

        leave_notify_event.connect (this.on_mouse_out);

    }

    construct {
        set_size_request (640, 480);

        show_cross_lines = false;
    }

    public bool on_mouse_over (Gdk.EventMotion event) {

        mouse_x = (int) event.x;
        mouse_y = (int) event.y;
        show_cross_lines = true;

        return true;

    }

    public bool on_mouse_out (Gdk.EventCrossing event) {

        show_cross_lines = false;

        return true;

    }

    public void draw_cross_lines (Cairo.Context ctext) {

        if (!show_cross_lines) {
            return;
        }

        // horizontal
        ctext.set_dash({5.0}, 0);
        ctext.set_line_width (0.2);
        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (0, mouse_y);
        ctext.line_to (_width, mouse_y);
        ctext.stroke ();

        // vertical
        ctext.set_line_width (0.2);
        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (mouse_x, 0);
        ctext.line_to (mouse_x, _height);
        ctext.stroke ();

    }

    public void draw_candle (Cairo.Context ctext, int x, int y) {

        int ancho = 10;
        int alto = 40;

        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void draw_candle_up (Cairo.Context ctext, int x, int y) {

        int ancho = 10;
        int alto = 40;

        // left_border
        ctext.set_line_width (1.0);
        ctext.set_source_rgba (0, 0, 0, 1.0);
        ctext.move_to (x, y);
        ctext.line_to (x, y + alto);
        ctext.stroke ();

        // right_border
        ctext.set_line_width (1.0);
        ctext.set_source_rgba (0, 0, 0, 1.0);
        ctext.move_to (x + ancho, y);
        ctext.line_to (x + ancho, y + alto);
        ctext.stroke ();

        // top_border
        ctext.set_line_width (1.0);
        ctext.set_source_rgba (0, 0, 0, 1.0);
        ctext.move_to (x - 1, y);
        ctext.line_to (x + ancho + 1, y);
        ctext.stroke ();

        // bottom_border
        ctext.set_line_width (1.0);
        ctext.set_source_rgba (0, 0, 0, 1.0);
        ctext.move_to (x - 1, y + alto);
        ctext.line_to (x + ancho + 1, y + alto);
        ctext.stroke ();

        ctext.set_source_rgba (255, 255, 255, 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void draw_candle_down (Cairo.Context ctext, int x, int y) {

        int ancho = 10;
        int alto = 40;

        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void write_text (Cairo.Context ctext, int x, int y, string txt) {

        Pango.Layout layout;

        layout = create_pango_layout (txt);

        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (x, y);
        Pango.cairo_update_layout (ctext, layout);
        Pango.cairo_show_layout (ctext, layout);

        queue_draw ();

    }

    public void draw_vertical_scale (Cairo.Context ctext) {

        int i = 0;
        int pos_y = 10;
        double precio = 1.1521;
        double step = 0.0001;
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        ctext.set_source_rgba (255, 255, 255, 1);
        ctext.rectangle (_width - 55, 5, 60, _height - 3);
        ctext.fill ();
        ctext.stroke ();

        for (i = 0 ; i < 20 ; i++) {

            write_text (ctext, _width - 50, pos_y, precio.format (buf, "%g"));
            precio -= step;
            pos_y += 15;

        }

    }

    public void draw_chart (Cairo.Context ctext) {

        draw_candle (ctext, 20, 20);
        draw_candle_up (ctext, 35, 30);
        draw_candle (ctext, 50, 40);
        draw_candle_up (ctext, 65, 35);

    }

    public override bool draw (Cairo.Context cr) {

        _width = get_allocated_width ();
        _height = get_allocated_height ();

        // print("hoa");

        /*
           cr.set_line_width (1.0);
           cr.set_source_rgba (0, 0, 0, 1.0);
           cr.move_to (3, 3);
           cr.line_to (3, height - 3);

           cr.move_to (width - 3, 3);
           cr.line_to (width - 3, height - 3);

           cr.stroke ();
         */

        draw_chart (cr);

        draw_vertical_scale (cr);

        draw_cross_lines (cr);

        cr.restore ();
        cr.save ();

        return true;
    }

    public override void size_allocate (Gtk.Allocation allocation) {

        // cuando cambia el tamaño
        base.size_allocate (allocation);

    }

}