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

        var fecha_desde = new DateTime.local (2011, 2, 21, 10, 0, 0);
        var fecha_hasta = new DateTime.local (2011, 2, 21, 10, 5, 0);

        data = new TradeSim.Services.QuotesManager ("EURUSD", "M1", fecha_desde, fecha_hasta);

        min_candles = 100;
        max_candles = 200;
        min_price = 114590; // precios convertidos a entero de 6 digitos.
        max_price = 114700;
        candle_width = 10;

        vertical_scale_calculation ();

    }

    private int get_media_figura (int _price) {

        string price = _price.to_string ();

        price = price.substring (0, 4) + "00";

        return int.parse (price);

    }

    private int get_pos_y_by_price (double precio) {

        var aux_max_price = get_media_figura (max_price);
        int aux_precio = (int) (precio * 100000);

        var aux = aux_max_price - aux_precio;

        print("aux_max_price=" + aux_max_price.to_string() + "\n");
        print("aux_precio=" + aux_precio.to_string() + "\n");
        print("aux_max_price - aux_precio" + aux.to_string() + "\n");
        print("------\n");
        //print("vertical_scale=" + vertical_scale.to_string() + "\n");

        //si 10 es vertical_scale cuanto es aux

        return (int) (aux*vertical_scale) / 10;

    }

    private void vertical_scale_calculation () {

        // buscar cantidad de medias figuras...
        var cont_value = 10;
        var aux_max_price = get_media_figura (max_price);
        var aux_min_price = get_media_figura (min_price);

        var cantidad = (int) (aux_max_price - aux_min_price) / cont_value;

        // print(cantidad.to_string() + "\n");

        vertical_scale = _height / cantidad;

        scale_step = cont_value;
        scale_label_step = vertical_scale;

        // print("scale_step=" + scale_step.to_string() + "\n");

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

        int ancho = 10;
        int alto = 40;

        ctext.set_source_rgba (0, 0, 0, 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void draw_candle_up (Cairo.Context ctext, int x, int y, int sizev) {

        int ancho = 10;
        int alto = sizev;

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

    public void draw_candle_down (Cairo.Context ctext, int x, int y,int sizev) {

        int ancho = 10;
        int alto = sizev;

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

        int precio_inicial = get_media_figura (max_price);
        int precio_final = get_media_figura (min_price);

        int pos_y = 0;
        double precio = precio_inicial;
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        ctext.set_source_rgba (255, 255, 255, 1);
        ctext.rectangle (_width - 55, 0, 60, _height);
        ctext.fill ();
        ctext.stroke ();

        // print("precio=" +precio.to_string() + "\n" );
        // print("precio_final=" +precio_final.to_string() + "\n" );
        // print("------\n");

        //print("precio(1.14700):" + get_pos_y_by_price(1.14700).to_string() + "\n");
        //print("precio(1.14590):" + get_pos_y_by_price(1.14590).to_string() + "\n");

        while (precio >= precio_final) {

            double show_price = precio / 100000;

            write_text (ctext, _width - 50, pos_y, show_price.format (buf, "%g").concat ("0000").substring (0, 7));

            precio -= scale_step;
            pos_y += scale_label_step;

        }

    }

    public void draw_chart (Cairo.Context ctext) {

        // recorremos los datos y vamos creando las velas al alza o a la baja segun corresponda.
        // tenemos una funcion que dado un precio nos devuelve una posición vertical.
        // tenemos una función que dado un date_time nos devuelve una posicion horizontal.
        // Estas funciones tienen en cuenta la escala establecida en base a los precios maximos y minimos
        // y a la cantidad de velas a representar.

        for(int i=0; i<data.quotes.length; i++){

            if(data.quotes.index(i).open_price < data.quotes.index(i).close_price){
                draw_candle_up (ctext, 35 + i*15, get_pos_y_by_price(data.quotes.index(i).open_price), 40);
            }else{
                draw_candle_down (ctext, 35 + i*15, get_pos_y_by_price(data.quotes.index(i).open_price), 40);
            }

        }

        /*draw_candle (ctext, 20, 20);
        draw_candle_up (ctext, 35, 30);
        draw_candle (ctext, 50, 40);
        draw_candle_up (ctext, 65, 35);*/

    }

    public override bool draw (Cairo.Context cr) {

        _width = get_allocated_width ();
        _height = get_allocated_height ();

        vertical_scale_calculation ();


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