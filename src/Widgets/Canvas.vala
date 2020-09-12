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

public class TradeSim.Widgets.Canvas : Gtk.DrawingArea {

    public weak TradeSim.MainWindow main_window;

    public int _width;
    public int _height;
    public int mouse_x;
    public int mouse_y;
    public int _available_height;
    public int _horizontal_scale_height;
    public int _horizontal_scroll_height;
    public int _horizontal_scroll_x;
    public int _horizontal_scroll_width;
    public int _horizontal_scroll_distancia;

    public bool _horizontal_scroll_moving;
    public bool _horizontal_scroll_active;

    private double zoom_factor;
    private int vertical_scale_width;
    private int min_candles;
    private int max_candles;
    private int min_price;
    private int max_price;
    private int candle_width;
    private int vertical_scale;
    private int scale_step;
    private int scale_label_step;
    private DateTime date_inicial;
    private DateTime date_from;
    private DateTime date_to;
    private string provider_name;
    private string time_frame;
    private string ticker;

    public bool end_simulation;

    private double candles_cola_size;

    public bool show_cross_lines;
    public bool show_horizontal_scale_label;
    public bool show_vertical_scale_label;

    public TradeSim.Services.QuotesManager data;

    public Canvas (TradeSim.MainWindow window, string _provider_name, string _ticker, string _time_frame) {

        main_window = window;

        ticker = _ticker;
        time_frame = _time_frame;
        provider_name = _provider_name;
        end_simulation = true;

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);

        motion_notify_event.connect (this.on_mouse_over);

        leave_notify_event.connect (this.on_mouse_out);

        button_press_event.connect (this.on_mouse_down);

        button_release_event.connect (this.on_mouse_up);

        init ();

    }

    private void init () {

        set_size_request (640, 480);
        show_cross_lines = false;
        show_horizontal_scale_label = false;
        show_vertical_scale_label = false;
        _horizontal_scroll_active = false;

        _horizontal_scroll_x = 0;
        _horizontal_scroll_distancia = 0;
        _horizontal_scroll_width = 1;
        _horizontal_scroll_moving = false;

        candles_cola_size = 0.8;


        data = new TradeSim.Services.QuotesManager ();

        date_from = data.db.get_min_date (provider_name, ticker, time_frame);
        date_inicial = date_from;

        change_zoom_level (1.000);

        data.init (provider_name, ticker, time_frame, date_from, date_to);

        min_candles = 100;
        max_candles = 200;
        update_extreme_prices ();
        candle_width = 10;
        vertical_scale_width = 55;

        _horizontal_scale_height = 24;
        _horizontal_scroll_height = 12;


        vertical_scale_calculation ();
        horizontal_scale_calculation ();
    }

    public void simulate () {


        if (end_simulation) {

            end_simulation = false;

            Timeout.add (1000, play, GLib.Priority.HIGH);

        } else {

            end_simulation = true;

        }


    }

    public bool play () {

        // carga una vela y avanza una vela.

        if (!end_simulation) {

            data.load_next_quote ();

            date_from = date_add_int_by_time_frame (date_from, time_frame, 1); // date_from = fecha_inicial.add_minutes (velas_step);

            change_zoom_level (zoom_factor);

            _horizontal_scroll_x = _width - vertical_scale_width - _horizontal_scroll_width;

            return true;

        }

        return false;

    }

    private void update_extreme_prices () {

        min_price = (int) (0.99 * data.get_min_price_by_datetimes (date_from, date_to));
        max_price = (int) (1.002 * data.get_max_price_by_datetimes (date_from, date_to));

        /*print("DateFrom:" + date_from.to_string() + " DateTo:" + date_to.to_string() + "\n");
           print("Min: " + min_price.to_string() + "\n");
           print("Max: " + max_price.to_string() + "\n");*/

    }

    public void change_zoom_level (double factor) {

        int total_candles_size = 1;

        zoom_factor = factor;

        if (factor == 1.000) {
            total_candles_size = 45;
        } else if (factor == 0.750) {
            total_candles_size = 65;
        } else if (factor == 0.500) {
            total_candles_size = 90;
        } else if (factor == 0.250) {
            total_candles_size = 120;
        } else if (factor == 0.125) {
            total_candles_size = 150;
        } else if (factor == 1.125) {
            total_candles_size = 35;
        } else if (factor == 1.250) {
            total_candles_size = 25;
        } else if (factor == 1.500) {
            total_candles_size = 15;
        } else if (factor == 1.750) {
            total_candles_size = 10;
        }

        date_to = date_add_int_by_time_frame (date_from, time_frame, total_candles_size); // date_to = date_from.add_minutes (total_candles_size);

        if (data != null) {
            update_extreme_prices ();
        }

    }

    private DateTime get_date_time_fecha_by_pos_x (int pos_x) {


        // int candles = get_candle_count_betwen_dates (date_from, date_time);
        DateTime candle_date_time = date_from;
        int candles = 1;
        int candle_spacing = 5;
        int test_value = candle_spacing + candle_width;

        if (test_value != 0) {

            candles = (int) pos_x / (test_value);

            candle_date_time = date_add_int_by_time_frame (candle_date_time, time_frame, candles); // candle_date_time = candle_date_time.add_minutes (candles);

        }

        return candle_date_time;

    }

    private string get_date_time_by_pos_x (int pos_x) {

        string return_value = "";


        // int candles = get_candle_count_betwen_dates (date_from, date_time);
        DateTime candle_date_time = date_from;
        int candles = 1;
        int candle_spacing = 5;
        int test_value = candle_spacing + candle_width;

        if (test_value != 0) {

            candles = (int) pos_x / (test_value);

            candle_date_time = date_add_int_by_time_frame (candle_date_time, time_frame, candles); // candle_date_time = candle_date_time.add_minutes (candles);

            return_value = candle_date_time.to_string ();

            return_value = return_value.substring (0, 16) + "hs";

        }

        return return_value;

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

            aux_date = date_add_int_by_time_frame (aux_date, time_frame, 1); // aux_date = aux_date.add_minutes (1);

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

        // si 10 es vertical_scale cuanto es aux

        return (int) (aux * vertical_scale) / cont_value;

    }

    private int get_price_by_pos_y (int y) {

        /* ES LA FUNCION INVERSA DE "get_pos_y_by_price" */

        var aux_max_price = get_media_figura_up (max_price);
        var cont_value = 1000;

        return (int) aux_max_price - (y * cont_value) / vertical_scale;

    }

    private string get_str_price_by_pos_y (int y) {

        int a = get_price_by_pos_y (y);
        char[] buf = new char[double.DTOSTR_BUF_SIZE];
        double show_price = a / 100000.00;

        return show_price.format (buf, "%g").concat ("0000").substring (0, 7);

    }

    private void vertical_scale_calculation () {

        // buscar cantidad de medias figuras...
        var cont_value = 1000;
        var aux_max_price = get_media_figura_up (max_price);
        var aux_min_price = get_media_figura (min_price);

        var cantidad = (int) ((aux_max_price - aux_min_price) / cont_value);

        vertical_scale = _available_height / cantidad;

        scale_step = cont_value;
        scale_label_step = vertical_scale;

    }

    private void horizontal_scale_calculation () {

        int candles = get_candle_count_betwen_dates (date_from, date_to);
        int candle_spacing = 5;
        int available_width = _width - vertical_scale_width;

        if (candles != 0) {
            candle_width = (int) (available_width / (candles + 2)) - candle_spacing;
        } else {
            candle_width = 10;
        }

    }

    public bool on_mouse_over (Gdk.EventMotion event) {

        mouse_x = (int) event.x;
        mouse_y = (int) event.y;


        if (mouse_y > _available_height) {
            show_cross_lines = false;
            show_horizontal_scale_label = false;
            show_vertical_scale_label = false;
            get_window ().set_cursor (new Gdk.Cursor (Gdk.CursorType.ARROW));
        } else {
            show_cross_lines = true;
            show_horizontal_scale_label = true;
            show_vertical_scale_label = true;
            get_window ().set_cursor (new Gdk.Cursor (Gdk.CursorType.CROSS));
        }

        if ((_horizontal_scroll_moving) && (_horizontal_scroll_active) && (mouse_y > (_height - _horizontal_scroll_height))) {

            _horizontal_scroll_x = mouse_x - _horizontal_scroll_distancia;

            if (_horizontal_scroll_x < 0) {
                _horizontal_scroll_x = 0;
            }

            var max_x = mouse_x - _horizontal_scroll_distancia + _horizontal_scroll_width;

            if (max_x > _width - vertical_scale_width) {
                _horizontal_scroll_x = _width - vertical_scale_width - _horizontal_scroll_width;
            }

            DateTime fecha_inicial = date_inicial;

            int pixeles_por_recorrer = (_width - vertical_scale_width) - _horizontal_scroll_width;
            int pixeles_recorridos = _horizontal_scroll_x;
            var porcentaje = (double) (1.00 * pixeles_recorridos / pixeles_por_recorrer);
            var velas_entre_fechas = get_candle_count_betwen_dates (date_from, date_to);

            var velas_step = (int) (velas_entre_fechas * porcentaje);

            date_from = date_add_int_by_time_frame (fecha_inicial, time_frame, velas_step); // date_from = fecha_inicial.add_minutes (velas_step);

            change_zoom_level (zoom_factor);

        }

        return true;

    }

    public bool on_mouse_down (Gdk.EventButton event) {

        _horizontal_scroll_distancia = mouse_x - _horizontal_scroll_x;

        _horizontal_scroll_moving = true;

        return true;
    }

    public bool on_mouse_up (Gdk.EventButton event) {

        _horizontal_scroll_moving = false;

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
        ctext.line_to (mouse_x, _available_height);
        ctext.stroke ();

    }

    public void draw_candle (Cairo.Context ctext, TradeSim.Services.QuoteItem candle_data) {

        if (candle_data.date_time == null) {
            return;
        }

        int posy = get_pos_y_by_price (candle_data.open_price);
        int posy2 = get_pos_y_by_price (candle_data.close_price);
        int posx = get_pos_x_by_date (candle_data.date_time);

        int cola_up_posy;
        int cola_up_posy2;

        int cola_down_posy;
        int cola_down_posy2;

        int cola_x;

        if (candle_data.open_price < candle_data.close_price) {

            draw_candle_up (ctext, posx, posy, posy2 - posy);

            cola_x = posx + (int) (candle_width / 2);
            cola_up_posy = posy;
            cola_up_posy2 = get_pos_y_by_price (candle_data.max_price);

            // cola arriba
            ctext.set_dash ({}, 0);
            ctext.set_line_width (candles_cola_size);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_up_posy2);
            ctext.line_to (cola_x, posy2);
            ctext.stroke ();

            cola_down_posy = get_pos_y_by_price (candle_data.open_price);
            cola_down_posy2 = get_pos_y_by_price (candle_data.min_price);

            // cola abajo
            ctext.set_dash ({}, 0);
            ctext.set_line_width (candles_cola_size);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_down_posy);
            ctext.line_to (cola_x, cola_down_posy2);
            ctext.stroke ();

        } else {

            draw_candle_down (ctext, posx, posy, posy2 - posy);

            cola_x = posx + (int) (candle_width / 2);
            cola_up_posy = posy;
            cola_up_posy2 = get_pos_y_by_price (candle_data.max_price);

            // cola arriba
            ctext.set_dash ({}, 0);
            ctext.set_line_width (candles_cola_size);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_up_posy2);
            ctext.line_to (cola_x, cola_up_posy);
            ctext.stroke ();

            cola_down_posy = get_pos_y_by_price (candle_data.close_price);
            cola_down_posy2 = get_pos_y_by_price (candle_data.min_price);

            // cola abajo
            ctext.set_dash ({}, 0);
            ctext.set_line_width (candles_cola_size);
            ctext.set_source_rgba (0, 0, 0, 1);
            ctext.move_to (cola_x, cola_down_posy);
            ctext.line_to (cola_x, cola_down_posy2);
            ctext.stroke ();

        }

    }

    public void draw_candle_up (Cairo.Context ctext, int x, int y, int sizev) {

        int ancho = candle_width;
        int alto = sizev;

        draw_candle_border (ctext, x, y, sizev);

        ctext.set_source_rgba (_r (104), _g (183), _b (35), 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void draw_candle_down (Cairo.Context ctext, int x, int y, int sizev) {

        int ancho = candle_width;
        int alto = sizev;

        draw_candle_border (ctext, x, y, sizev);

        ctext.set_source_rgba (_r (192), _g (38), _b (46), 1);
        ctext.rectangle (x, y, ancho, alto);
        ctext.fill ();

    }

    public void draw_candle_border (Cairo.Context ctext, int x, int y, int sizev) {

        int ancho = candle_width;
        int alto = sizev;

        ctext.set_dash ({}, 0);

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

    public void draw_line (Cairo.Context ctext, int x1, int y1, int x2, int y2, double size, int r, int g, int b, bool dash = false, double dash_type = 5.0) {

        ctext.set_dash ({}, 0);

        if (dash) {
            ctext.set_dash ({ dash_type }, 0);
        }

        ctext.set_line_width (size);
        ctext.set_source_rgba (_r (r), _g (g), _b (b), 1);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }

    public void draw_bg (Cairo.Context ctext) {

        ctext.set_source_rgba (_r (255), _g (243), _b (148), 1);
        ctext.rectangle (0, 0, _width, _height);
        ctext.fill ();
        ctext.stroke ();

    }

    public void draw_horizontal_scrollbar (Cairo.Context ctext) {

        int displayed_size = get_candle_count_betwen_dates (date_from, date_to);
        uint display_size = data.quotes.length;
        double scrollbar_size_factor = displayed_size * 1.00 / display_size; // por ejemplo si es 0.5 la barra tiene la mitad de available_width;
        double aux = (_width - vertical_scale_width - 1.00) * scrollbar_size_factor;

        _horizontal_scroll_width = int.parse (aux.to_string ());

        if (_horizontal_scroll_width < _width - vertical_scale_width - 1.00) {

            _horizontal_scroll_active = true;

            ctext.set_source_rgba (_r (212), _g (142), _b (21), 1);
            ctext.rectangle (_horizontal_scroll_x, _height - _horizontal_scroll_height + 2, _horizontal_scroll_width, _horizontal_scroll_height - 4);
            ctext.fill ();

        } else {
            _horizontal_scroll_active = false;
        }


    }

    public void draw_cursor_datetime_label (Cairo.Context ctext) {

        if (!show_horizontal_scale_label) {
            return;
        }

        ctext.set_dash ({}, 0);

        ctext.set_source_rgba (_r (173), _g (95), _b (0), 1);
        ctext.rectangle (mouse_x - 70, _available_height, 140, _horizontal_scale_height);
        ctext.fill ();

        ctext.move_to (mouse_x, _available_height);
        ctext.rel_line_to (-10, 0);
        ctext.rel_line_to (10, -10);
        ctext.rel_line_to (10, 10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        ctext.set_source_rgb (_r (173), _g (95), _b (0));
        ctext.fill_preserve ();
        ctext.stroke ();

        write_text (ctext, mouse_x - 56, _available_height + 4, get_date_time_by_pos_x (mouse_x));

    }

    public void draw_cursor_price_label (Cairo.Context ctext) {

        if (!show_vertical_scale_label) {
            return;
        }

        ctext.set_dash ({}, 0);

        ctext.set_source_rgba (_r (173), _g (95), _b (0), 1);
        ctext.rectangle (_width - vertical_scale_width, mouse_y - 10, vertical_scale_width, 20);
        ctext.fill ();

        ctext.move_to (_width - vertical_scale_width, mouse_y + 10);
        ctext.rel_line_to (-10, -10);
        ctext.rel_line_to (10, -10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        ctext.set_source_rgb (_r (173), _g (95), _b (0));
        ctext.fill_preserve ();
        ctext.stroke ();

        write_text (ctext, _width - (vertical_scale_width - 5), mouse_y - 9, get_str_price_by_pos_y (mouse_y));

    }

    public void draw_horizontal_scale (Cairo.Context ctext) {

        ctext.set_source_rgba (_r (255), _g (225), _b (107), 1);
        ctext.rectangle (0, _available_height, _width, _available_height);
        ctext.fill ();

        ctext.set_line_width (0.7);
        ctext.set_source_rgba (_r (212), _g (142), _b (21), 1);
        ctext.move_to (0, _available_height);
        ctext.line_to (_width, _available_height);
        ctext.stroke ();

    }

    public void draw_vertical_scale (Cairo.Context ctext) {

        int precio_inicial = get_media_figura_up (max_price);
        int precio_final = get_media_figura (min_price);

        int pos_y = 0;
        double precio = precio_inicial;
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        ctext.set_source_rgba (_r (255), _g (225), _b (107), 1);
        ctext.rectangle (_width - vertical_scale_width, 0, 60, _available_height);
        ctext.fill ();
        ctext.stroke ();

        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (212), _g (142), _b (21), 1);
        ctext.move_to (_width - vertical_scale_width, 0);
        ctext.line_to (_width - vertical_scale_width, _available_height);
        ctext.stroke ();

        while (precio >= precio_final) {

            double show_price = precio / 100000;

            draw_line (ctext, 0, pos_y, _width - vertical_scale_width, pos_y, 0.3, 212, 142, 21, false);

            write_text (ctext, _width - (vertical_scale_width - 5), pos_y, show_price.format (buf, "%g").concat ("0000").substring (0, 7));

            precio -= scale_step;
            pos_y += scale_label_step;

        }

    }

    public void draw_chart (Cairo.Context ctext) {

        // dibujar solo la cantidad fecha desde hasta....

        DateTime cursor_date = date_from;

        while (cursor_date.compare (date_to) < 0) {

            draw_candle (ctext, data.get_quote_by_time (cursor_date));

            cursor_date = date_add_int_by_time_frame (cursor_date, time_frame, 1); // cursor_date = cursor_date.add_minutes (1);

        }

    }

    public override bool draw (Cairo.Context cr) {

        _width = get_allocated_width ();
        _height = get_allocated_height ();

        _available_height = _height - _horizontal_scroll_height - _horizontal_scale_height;

        vertical_scale_calculation ();
        horizontal_scale_calculation ();

        draw_bg (cr);

        draw_vertical_scale (cr);
        draw_horizontal_scale (cr);

        draw_chart (cr);

        draw_cross_lines (cr);

        draw_cursor_price_label (cr);
        draw_cursor_datetime_label (cr);

        draw_horizontal_scrollbar (cr);

        cr.restore ();
        cr.save ();

        return true;

    }

    public override void size_allocate (Gtk.Allocation allocation) {

        // cuando cambia el tamaño
        base.size_allocate (allocation);

    }

}