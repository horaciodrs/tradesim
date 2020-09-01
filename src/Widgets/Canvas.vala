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

    private int min_candles;
    private int max_candles;
    private int min_price;
    private int max_price;
    private int candle_width;
    private int vertical_scale;
    private int scale_step;
    private int scale_label_step;
    private DateTime date_from;
    private DateTime date_to;
    private string time_frame;
    private string ticker;

    public bool show_cross_lines;

    public TradeSim.Services.QuotesManager data;

    public Canvas (TradeSim.MainWindow window) {

        main_window = window;

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);

        motion_notify_event.connect (this.on_mouse_over);

        leave_notify_event.connect (this.on_mouse_out);

    }

    construct {
        set_size_request (640, 480);
        show_cross_lines = false;

        date_from = new DateTime.local (2011, 2, 21, 10, 0, 0);
        date_to = new DateTime.local (2011, 2, 21, 10, 5, 0);
        ticker = "EURUSD";
        time_frame = "M1";

        data = new TradeSim.Services.QuotesManager (ticker, time_frame, date_from, date_to);

        min_candles = 100;
        max_candles = 200;
        min_price = 105000; // precios convertidos a entero de 6 digitos.
        max_price = 117000;
        candle_width = 10;

        vertical_scale_calculation ();

    }

    private int get_media_figura_up (int _price) {

        return get_media_figura (_price + 100);

    }

    private int get_media_figura (int _price) {

        string price = _price.to_string ();

        price = price.substring (0, 4) + "00";

        return int.parse (price);

    }

    private int get_candle_count_betwen_dates (DateTime d1, DateTime d2) {

        DateTime aux_date = d1;
        bool exit = false;
        int return_value = 0;

        while (!exit) {

            aux_date = aux_date.add_minutes (1);

            if (aux_date.compare (d2) > 0) {
                exit = true;
            } else {
                return_value++;
            }

        }

        return return_value;

    }

    private int get_pos_x_by_date (DateTime date_time) {

        int candles = get_candle_count_betwen_dates (date_from, date_time);
        int candle_spacing = 5;

        return candle_spacing * candles + candle_width * candles;

    }

    private int get_pos_y_by_price (double precio) {

        var aux_max_price = get_media_figura_up (max_price);
        int aux_precio = (int) (precio * 100000);
        var cont_value = 1000;

        var aux = aux_max_price - aux_precio;

        // print ("aux_max_price=" + aux_max_price.to_string () + "\n");
        // print ("aux_precio=" + aux_precio.to_string () + "\n");
        // print ("aux_max_price - aux_precio" + aux.to_string () + "\n");
        // print ("------\n");

        // print("vertical_scale=" + vertical_scale.to_string() + "\n");

        // si 10 es vertical_scale cuanto es aux

        return (int) (aux * vertical_scale) / cont_value;

    }

    private void vertical_scale_calculation () {

        // buscar cantidad de medias figuras...
        var cont_value = 1000;
        var aux_max_price = get_media_figura_up (max_price);
        var aux_min_price = get_media_figura (min_price);

        var cantidad = (int) (aux_max_price - aux_min_price) / cont_value;

        // print(cantidad.to_string() + "\n");

        vertical_scale = _height / cantidad;

        scale_step = cont_value;
        scale_label_step = vertical_scale;

        // print("scale_step=" + scale_step.to_string() + "\n");

    }

    private void horizontal_scale_calculation () {

        int candles = get_candle_count_betwen_dates (date_from, date_to);
        int candle_spacing = 5;
        int price_scale_width = 50; // debe ser globar. es el ancho de la escala de precios.
        int available_width = _width - price_scale_width;

        if (candles != 0) {
            if (candles < 50) {
                candles = 50;
            }
            candle_width = (available_width - available_width / (candle_spacing * candles)) / candles;
        } else {
            candle_width = 10;
        }

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
        ctext.set_dash ({ 5.0 }, 0);
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

    public void draw_candle (Cairo.Context ctext, TradeSim.Services.QuoteItem candle_data) {

        int posy = get_pos_y_by_price (candle_data.open_price);
        int posy2 = get_pos_y_by_price (candle_data.close_price);
        int posx = get_pos_x_by_date (candle_data.date_time);

        int cola_up_posy;
        int cola_up_posy2;

        int cola_down_posy;
        int cola_down_posy2;

        int cola_x;

        if (candle_data.open_price < candle_data.close_price) {
            /*print("candle up " + candle_data.date_time.to_string() +": \n");
               print("posx:" + posx.to_string() + "\n");
               print("--------\n");*/

            draw_candle_up (ctext, posx, posy, posy2 - posy);

            cola_x = posx + (int) (candle_width / 2);
            cola_up_posy = posy;
            cola_up_posy2 = get_pos_y_by_price (candle_data.max_price);

            // cola arriba
            ctext.set_line_width (1);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_up_posy2);
            ctext.line_to (cola_x, posy2);
            ctext.stroke ();

            cola_down_posy = get_pos_y_by_price (candle_data.open_price);
            cola_down_posy2 = get_pos_y_by_price (candle_data.min_price);

            // cola abajo
            ctext.set_line_width (1);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_down_posy);
            ctext.line_to (cola_x, cola_down_posy2);
            ctext.stroke ();

        } else {
            /*print("candle down " + candle_data.date_time.to_string() +": \n");
               print("open_price:" + candle_data.open_price.to_string() + "\n");
               print("close_price:" + candle_data.close_price.to_string() + "\n");
               print("posx:" + posx.to_string() + "\n");
               print("posy:" + posy.to_string() + "\n");
               print("posy2:" + posy2.to_string() + "\n");
               print("--------\n");*/

            draw_candle_down (ctext, posx, posy, posy2 - posy);

            cola_x = posx + (int) (candle_width / 2);
            cola_up_posy = posy;
            cola_up_posy2 = get_pos_y_by_price (candle_data.max_price);

            /*print("candle down " + candle_data.date_time.to_string() +": \n");
               print("open_price:" + candle_data.open_price.to_string() + "\n");
               print("max_price:" + candle_data.max_price.to_string() + "\n");
               print("min_price:" + candle_data.min_price.to_string() + "\n");
               print("posx:" + posx.to_string() + "\n");
               print("cola_x:" + cola_x.to_string() + "\n");
               print("canlde_width:" + candle_width.to_string() + "\n");
               print("cola_up_posy:" + cola_up_posy.to_string() + "\n");
               print("cola_up_posy2:" + cola_up_posy2.to_string() + "\n");
               print("--------\n");*/

            // cola arriba
            ctext.set_line_width (1);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_up_posy2);
            ctext.line_to (cola_x, cola_up_posy);
            ctext.stroke ();

            cola_down_posy = get_pos_y_by_price (candle_data.close_price);
            cola_down_posy2 = get_pos_y_by_price (candle_data.min_price);

            // cola abajo
            ctext.set_line_width (1);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_down_posy);
            ctext.line_to (cola_x, cola_down_posy2);
            ctext.stroke ();

        }

    }

    public void draw_candle_up (Cairo.Context ctext, int x, int y, int sizev) {

        int ancho = candle_width;
        int alto = sizev;

        // left_border
        ctext.set_line_width (1);
        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (x, y);
        ctext.line_to (x, y + alto);
        ctext.stroke ();

        // right_border
        ctext.set_line_width (1);
        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (x + ancho, y);
        ctext.line_to (x + ancho, y + alto);
        ctext.stroke ();

        // top_border
        ctext.set_line_width (1);
        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (x - 1, y);
        ctext.line_to (x + ancho + 1, y);
        ctext.stroke ();

        // bottom_border
        ctext.set_line_width (1);
        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (x - 1, y + alto);
        ctext.line_to (x + ancho + 1, y + alto);
        ctext.stroke ();

        ctext.set_source_rgba (_r (104), _g (183), _b (35), 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void draw_candle_down (Cairo.Context ctext, int x, int y, int sizev) {

        int ancho = candle_width;
        int alto = sizev;

        ctext.set_source_rgba (_r (192), _g (38), _b (46), 1);
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

    public void draw_bg (Cairo.Context ctext) {

        ctext.set_source_rgba (_r (255), _g (243), _b (148), 1);
        ctext.rectangle (0, 0, _width, _height);
        ctext.fill ();
        ctext.stroke ();

    }

    public void draw_vertical_scale (Cairo.Context ctext) {

        int precio_inicial = get_media_figura_up (max_price);
        int precio_final = get_media_figura (min_price);

        int pos_y = 0;
        double precio = precio_inicial;
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        ctext.set_source_rgba (_r (255), _g (225), _b (107), 1);
        ctext.rectangle (_width - 55, 0, 60, _height);
        ctext.fill ();
        ctext.stroke ();

        ctext.set_line_width (1);
        ctext.set_source_rgba (_r(212), _g(142), _b(21), 1);
        ctext.move_to (_width - 55, 0);
        ctext.line_to (_width - 55, _height);
        ctext.stroke ();

        // print("precio=" +precio.to_string() + "\n" );
        // print("precio_final=" +precio_final.to_string() + "\n" );
        // print("------\n");

        // print("precio(1.14700):" + get_pos_y_by_price(1.14700).to_string() + "\n");
        // print("precio(1.14590):" + get_pos_y_by_price(1.14590).to_string() + "\n");

        while (precio >= precio_final) {

            double show_price = precio / 100000;

            write_text (ctext, _width - 50, pos_y, show_price.format (buf, "%g").concat ("0000").substring (0, 7));

            precio -= scale_step;
            pos_y += scale_label_step;

        }

    }

    public void draw_chart (Cairo.Context ctext) {

        for (int i = 0 ; i < data.quotes.length ; i++) {

            draw_candle (ctext, data.quotes.index (i));

        }

    }

    public override bool draw (Cairo.Context cr) {

        _width = get_allocated_width ();
        _height = get_allocated_height ();

        vertical_scale_calculation ();
        horizontal_scale_calculation ();

        draw_bg (cr);

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