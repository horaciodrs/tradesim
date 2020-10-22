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

    public enum Direccion {
        RIGHT
        , LEFT
    }

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

    private bool _vertical_scroll_moving;
    public bool _vertical_scroll_active;
    private int _vertical_scroll_distancia;
    private int _vertical_scroll_current_max;
    private int _vertical_scroll_current_min;
    private int _vertical_scroll_current_max_visible;
    private int _vertical_scroll_current_min_visible;

    private double zoom_factor;
    public int vertical_scale_width;
    private int min_candles;
    private int max_candles;

    private int min_price;          //Mínimo absoluto de todos los datos.
    private int max_price;          //Máximo absoluto de todos los datos.
    private int min_price_visible;  //Mínimo para visualizar.
    private int max_price_visible;  //Máximo para visualizar.

    public int candle_width;
    private int vertical_scale;
    private int scale_step;
    private int scale_label_step;
    private DateTime date_inicial;
    public DateTime date_from;
    public DateTime date_to;
    public DateTime last_candle_date;
    public double last_candle_price;
    public double last_candle_max_price;
    public double last_candle_min_price;
    public string provider_name;
    public string time_frame;
    public string ticker;

    public bool end_simulation;

    private double candles_cola_size;

    public bool show_cross_lines;
    public bool show_horizontal_scale_label;
    public bool show_vertical_scale_label;

    public bool change_velocity;
    public int simulation_vel;
    public int simulation_velocity_ratio;

    public string simulation_name;
    public double simulation_initial_balance;

    public TradeSim.Services.QuotesManager data;
    public TradeSim.Services.OperationsManager operations_manager;

    private int total_candles_size; // Indica la cantidad de velas que puedo dibujar...
    private int drawed_candles;

    public TradeSim.Services.Drawings draw_manager;

    private int draw_mode_objects;
    private string draw_mode_id;
    private bool draw_mode_line;
    private bool draw_mode_fibo;
    private bool draw_mode_rectangle;
    private bool draw_mode_hline;
    private bool draw_mode;

    public string ? file_url;

    public bool scroll_from_file_setted; // Indica si luego de cargar un archivo se movio el scroll al final.

    public bool need_save; // Indica si es necesario guardar antes de salir.

    public TradeSim.Utils.ColorPalette color_palette;

    public Canvas (TradeSim.MainWindow window, string _provider_name, string _ticker, string _time_frame, string _simulation_name = "Unnamed Simulation", double _simulation_initial_balance = 500.000, DateTime _initial_date, string ? load_file = null) {

        main_window = window;

        ticker = _ticker;
        time_frame = _time_frame;
        provider_name = _provider_name;

        drawed_candles = 0;

        end_simulation = true;
        simulation_vel = 1000;
        change_velocity = false;
        simulation_velocity_ratio = 1;

        simulation_name = _simulation_name;
        simulation_initial_balance = _simulation_initial_balance;
        date_inicial = _initial_date;

        draw_mode_objects = 0;
        draw_mode_line = false;
        draw_mode_fibo = false;
        draw_mode_rectangle = false;
        draw_mode_hline = false;
        draw_mode = false;
        need_save = true;

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);

        motion_notify_event.connect (this.on_mouse_over);

        leave_notify_event.connect (this.on_mouse_out);

        button_press_event.connect (this.on_mouse_down);

        button_release_event.connect (this.on_mouse_up);

        init ();

        if (load_file != null) {
            file_url = load_file;
            init_from_file (file_url);
        }

        scroll_from_file_setted = false;

    }

    public void init_from_file (string file_path) {

        try {

            var simulation_file = new TradeSim.Services.FileReader (file_path, this);

            simulation_file.set_operations_manager (operations_manager);

            simulation_file.set_draw_manager (draw_manager);

            simulation_file.read ();

            simulation_name = simulation_file.canvas_data.simulation_name;
            simulation_initial_balance = simulation_file.canvas_data.simulation_initial_balance;
            date_inicial = simulation_file.canvas_data.date_inicial;
            date_from = simulation_file.canvas_data.date_from;
            date_to = simulation_file.canvas_data.date_to;
            last_candle_date = simulation_file.canvas_data.last_candle_date;

            last_candle_price = simulation_file.canvas_data.last_candle_price;
            last_candle_max_price = simulation_file.canvas_data.last_candle_max_price;
            last_candle_min_price = simulation_file.canvas_data.last_candle_min_price;
            provider_name = simulation_file.canvas_data.provider_name;
            time_frame = simulation_file.canvas_data.time_frame;
            ticker = simulation_file.canvas_data.ticker;

            data.init (provider_name, ticker, time_frame, date_inicial, date_to);

            vertical_scale_calculation ();
            horizontal_scale_calculation ();
            horizontal_scroll_position_end (); // Intento posicionar el scroll en el final.

            need_save = false;

        } catch (Error e) {
            return;
        }

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

        _vertical_scroll_moving = false;
        _vertical_scroll_active = false;
        _vertical_scroll_distancia = 0;

        candles_cola_size = 0.8;

        draw_manager = new TradeSim.Services.Drawings (this);

        operations_manager = new TradeSim.Services.OperationsManager ();

        data = new TradeSim.Services.QuotesManager ();

        color_palette = new TradeSim.Utils.ColorPalette ();

        if(main_window.settings.get_boolean ("window-dark-theme") == true){
            color_palette.set_dark_mode();
        }else {
            color_palette.set_light_mode();
        }

        date_from = date_inicial;

        change_zoom_level (1.000);

        data.init (provider_name, ticker, time_frame, date_from, date_to);

        min_candles = 100;
        max_candles = 200;
        update_extreme_prices ();
        candle_width = 10;
        vertical_scale_width = 55;

        _horizontal_scale_height = 24;
        _horizontal_scroll_height = 12;

        file_url = null;

        vertical_scale_calculation ();
        horizontal_scale_calculation ();
    }

    public void write_file (Xml.TextWriter writer) throws FileError {

        writer.start_element ("simulation");

        writer.start_element ("name");
        writer.write_string (simulation_name);
        writer.end_element ();

        writer.start_element ("initialbalance");
        writer.write_string (simulation_initial_balance.to_string ());
        writer.end_element ();

        writer.start_element ("dateinicial");
        writer.write_string (date_inicial.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("datefrom");
        writer.write_string (date_from.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("dateto");
        writer.write_string (date_to.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("lastcandledate");
        writer.write_string (last_candle_date.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("lastcandleprice");
        writer.write_string (last_candle_price.to_string ());
        writer.end_element ();

        writer.start_element ("lastcandlemaxprice");
        writer.write_string (last_candle_max_price.to_string ());
        writer.end_element ();

        writer.start_element ("lastcandleminprice");
        writer.write_string (last_candle_min_price.to_string ());
        writer.end_element ();

        writer.start_element ("providername");
        writer.write_string (provider_name.to_string ());
        writer.end_element ();

        writer.start_element ("timeframe");
        writer.write_string (time_frame.to_string ());
        writer.end_element ();

        writer.start_element ("ticker");
        writer.write_string (ticker);
        writer.end_element ();

        operations_manager.write_file (writer);
        draw_manager.write_file (writer);

        writer.end_element ();

    }

    public string simulate_fast () {

        string return_value = "Stop";

        if (simulation_vel == 1000) {
            simulation_vel = 750;
            simulation_velocity_ratio = 2;
        } else if (simulation_vel == 750) {
            simulation_vel = 500;
            simulation_velocity_ratio = 3;
        } else if (simulation_vel == 500) {
            simulation_vel = 250;
            simulation_velocity_ratio = 4;
        } else {
            simulation_vel = 250;
            simulation_velocity_ratio = 4;
        }

        change_velocity = true;

        if (simulation_velocity_ratio != 1) {
            return_value = simulation_velocity_ratio.to_string () + "x";
        }

        return return_value;

    }

    public string simulate_slow () {

        string return_value = "Stop";

        if (simulation_vel == 250) {
            simulation_vel = 500;
            simulation_velocity_ratio = 3;
        } else if (simulation_vel == 500) {
            simulation_vel = 750;
            simulation_velocity_ratio = 2;
        } else if (simulation_vel == 750) {
            simulation_vel = 1000;
            simulation_velocity_ratio = 1;
        } else {
            simulation_vel = 1000;
            simulation_velocity_ratio = 1;
        }

        if (simulation_velocity_ratio != 1) {
            return_value = simulation_velocity_ratio.to_string () + "x";
        }

        change_velocity = true;

        return return_value;

    }

    public void stop_simulation () {
        end_simulation = true;
        simulation_vel = 1000;
        simulation_velocity_ratio = 1;

        main_window.headerbar.play.change_icon ("media-playback-start");
        main_window.headerbar.play.label_btn.set_text (_("Play"));

    }

    public void simulate () {

        change_velocity = false;


        if (end_simulation) {

            end_simulation = false;

            Timeout.add (simulation_vel, play, GLib.Priority.HIGH);

        } else {

            stop_simulation ();

        }


    }

    public bool play () {

        // carga una vela y avanza una vela.

        if (!end_simulation) {

            need_save = true;

            data.load_next_quote ();

            // Solo debe cambiar el date_from cuando ya no queda mas espacio para dibujar...

            if (drawed_candles == total_candles_size) {
                date_from = date_add_int_by_time_frame (date_from, time_frame, 1);
            }

            change_zoom_level (zoom_factor);

            horizontal_scroll_position_end ();

            check_operations_tp_and_sl ();
            main_window.main_layout.operations_panel.update_operations_profit ();

            if (change_velocity) {
                Timeout.add (simulation_vel, play, GLib.Priority.HIGH);
                return false; // retorna falso para que frene.... pero tiene que volver a tirar el timeout
            }

            return true;

        }

        return false;

    }

    public void horizontal_scroll_position_end () {
        horizontal_scrollbar_width_calc ();
        _horizontal_scroll_x = _width - vertical_scale_width - _horizontal_scroll_width;
    }

    private void check_operations_tp_and_sl () {

        // Se encarga de cerrar una las operaciones que hallan tocado SL o TP.

        bool need_update = false;

        for (int i = 0 ; i < operations_manager.operations.length ; i++) {

            var item = operations_manager.operations.index (i);

            if (item.state == TradeSim.Objects.OperationItem.State.CLOSED) {
                continue;
            }

            if (item.type_op == TradeSim.Objects.OperationItem.Type.BUY) {

                if (item.tp < last_candle_max_price) {
                    operations_manager.close_operation_by_id (item.id, item.tp, last_candle_date);
                    need_update = true;
                }

                if (item.sl > last_candle_min_price) {
                    operations_manager.close_operation_by_id (item.id, item.sl, last_candle_date);
                    need_update = true;
                }

            } else if (item.type_op == TradeSim.Objects.OperationItem.Type.SELL) {

                if (item.tp > last_candle_min_price) {
                    operations_manager.close_operation_by_id (item.id, item.tp, last_candle_date);
                    need_update = true;
                }

                if (item.sl < last_candle_max_price) {
                    operations_manager.close_operation_by_id (item.id, item.sl, last_candle_date);
                    need_update = true;
                }

            }

        }

        if (need_update) {
            main_window.main_layout.operations_panel.update_operations ();
        }

    }

    private void update_extreme_prices () {

        if(last_candle_date == null){
            min_price = (int) (0.995 * data.get_min_price_by_datetimes (date_from, date_to));
            max_price = (int) (1.001 * data.get_max_price_by_datetimes (date_from, date_to));
            min_price_visible = (int) (0.995 * data.get_min_price_by_datetimes (date_from, date_to));
            max_price_visible = (int) (1.001 * data.get_max_price_by_datetimes (date_from, date_to));
        }

    }

    public double get_zoom_factor () {
        return zoom_factor * 100;
    }

    public void change_zoom_level (double factor) {

        zoom_factor = factor;

        if (factor == 1.000) {
            total_candles_size = 65;
        } else if (factor == 0.750) {
            total_candles_size = 85;
        } else if (factor == 0.500) {
            total_candles_size = 120;
        } else if (factor == 0.250) {
            total_candles_size = 140;
        } else if (factor == 0.125) {
            total_candles_size = 160;
        } else if (factor == 1.125) {
            total_candles_size = 45;
        } else if (factor == 1.250) {
            total_candles_size = 35;
        } else if (factor == 1.500) {
            total_candles_size = 25;
        } else if (factor == 1.750) {
            total_candles_size = 15;
        }

        date_to = date_add_int_by_time_frame (date_from, time_frame, total_candles_size);

        if (data != null) {
            update_extreme_prices ();
        }

    }

    private DateTime get_date_time_fecha_by_pos_x (int pos_x) {

        DateTime candle_date_time = date_from;
        int candles = 1;
        int candle_spacing = 5;
        int test_value = candle_spacing + candle_width;

        if (test_value != 0) {

            candles = (int) pos_x / (test_value);

            candle_date_time = date_add_int_by_time_frame (candle_date_time, time_frame, candles);

        }

        return candle_date_time;

    }

    private string get_date_time_by_pos_x (int pos_x) {

        string return_value = "";

        return_value = get_date_time_fecha_by_pos_x (pos_x).to_string ();

        return_value = return_value.substring (0, 16) + "hs";

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

        if(d1.compare(d2) < 0){
            while (!exit) {

                aux_date = date_add_int_by_time_frame (aux_date, time_frame, 1);

                if (aux_date.compare (d2) > 0) {
                    exit = true;
                } else {
                    return_value++;
                }

            }
        }else{

            aux_date = d2;

            while (!exit) {

                aux_date = date_add_int_by_time_frame (aux_date, time_frame, 1);

                if (aux_date.compare (d1) > 0) {
                    exit = true;
                } else {
                    return_value++;
                }

            }
            return_value = return_value * (-1);
        }

        return return_value;

    }

    public int get_pos_x_by_date (DateTime date_time) {

        int candles = get_candle_count_betwen_dates (date_from, date_time);
        int candle_spacing = 5;

        return candle_spacing * candles + candle_width * candles;

    }

    public int get_pos_y_by_price (double precio) {

        var aux_max_price = get_media_figura_up (max_price_visible);
        int aux_precio = (int) (precio * 100000);
        var cont_value = (int)(1000 * zoom_factor);

        var aux = aux_max_price - aux_precio;

        // si 10 es vertical_scale cuanto es aux

        return (int) (aux * vertical_scale) / cont_value;

    }

    public int get_price_by_pos_y (int y) {

        /* ES LA FUNCION INVERSA DE "get_pos_y_by_price" */

        var aux_max_price = get_media_figura_up (max_price_visible);
        var cont_value = (int)(1000 * zoom_factor);

        return (int) aux_max_price - (y * cont_value) / vertical_scale;

    }

    public string get_str_price_by_pos_y (int y) {

        int a = get_price_by_pos_y (y);
        char[] buf = new char[double.DTOSTR_BUF_SIZE];
        double show_price = a / 100000.00;

        return show_price.format (buf, "%g").concat ("0000").substring (0, 7);

    }

    public string get_str_price_by_double (double price) {

        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        return price.format (buf, "%g").concat ("0000").substring (0, 7);

    }

    private void vertical_scale_calculation () {

        // buscar cantidad de medias figuras...
        var cont_value = (int)(1000 * zoom_factor);
        var aux_max_price = get_media_figura_up (max_price);
        var aux_min_price = get_media_figura (min_price);

        var cantidad = (aux_max_price - aux_min_price) / cont_value;

        if(cantidad == 0){
            cantidad = 1;
        }

        vertical_scale = (int)(_available_height / cantidad);

        scale_step = cont_value;
        scale_label_step = vertical_scale;

    }

    private void horizontal_scale_calculation () {

        int candles = get_candle_count_betwen_dates (date_from, date_to);
        int candle_spacing = 5;
        int available_width = _width - vertical_scale_width;

        if (candles != 0) {
            candle_width = (int) (available_width / candles) - candle_spacing;
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
            get_window ().set_cursor (new Gdk.Cursor.for_display (Gdk.Display.get_default (), Gdk.CursorType.ARROW));
        } else {
            show_cross_lines = true;
            show_horizontal_scale_label = true;
            show_vertical_scale_label = true;
            get_window ().set_cursor (new Gdk.Cursor.for_display (Gdk.Display.get_default (), Gdk.CursorType.CROSS));
        }

        if(mouse_x > _width - vertical_scale_width){
            get_window ().set_cursor (new Gdk.Cursor.for_display (Gdk.Display.get_default (), Gdk.CursorType.DOUBLE_ARROW));
        }

        if ((_vertical_scroll_moving) && (_vertical_scroll_active)) {

            var cont_value = (int)(1000 * zoom_factor);
            var aux_max_price = get_media_figura_up (max_price);
            var aux_min_price = get_media_figura (min_price);
            var cantidad = (int) ((aux_max_price - aux_min_price) / cont_value);
            var cambio = mouse_y - _vertical_scroll_distancia;

            if(mouse_x > _width - vertical_scale_width){
                //Permite el cambio de escala vertical...
                var test_min = min_price - cambio*cantidad;
                var test_max = max_price + cambio*cantidad;
                var test_cont_value = (int)(1000 * zoom_factor);
                var test_aux_max_price = get_media_figura_up (test_max);
                var test_aux_min_price = get_media_figura (test_min);
                var resta = test_aux_max_price - test_aux_min_price;

                if(resta > test_cont_value){
                    //mediante las variables test_* se asegura de que los valores
                    //de max_price y min_price no rompan el calculo de la
                    //escala vertical.
                    min_price = min_price - cambio*cantidad;
                    max_price = max_price + cambio*cantidad;
                }

            }else{
                //Permite el scroll vertical...
                min_price_visible = _vertical_scroll_current_min_visible - cambio*cantidad;
                max_price_visible = _vertical_scroll_current_max_visible + cambio*cantidad;
            }

        }

        if ((_horizontal_scroll_moving) && (_horizontal_scroll_active)) {

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
            var velas_entre_fechas = 0;

            velas_entre_fechas = (int) (data.quotes.length) - total_candles_size;

            var velas_step = (int) (velas_entre_fechas * porcentaje);

            date_from = date_add_int_by_time_frame (fecha_inicial, time_frame, velas_step);

            change_zoom_level (zoom_factor);

        }

        for (int i = 0 ; i < draw_manager.operations.length ; i++) {
            draw_manager.operations.index (i).drag (this, mouse_x, mouse_y);
        }

        user_draw_line ();
        user_draw_fibo ();
        user_draw_rectangle ();
        user_draw_hline ();

        return true;

    }

    public bool on_mouse_down (Gdk.EventButton event) {

        _horizontal_scroll_distancia = mouse_x - _horizontal_scroll_x;

        if (mouse_y > (_height - _horizontal_scroll_height)) {
            _horizontal_scroll_moving = true;
        }

        if(mouse_y < _height - _horizontal_scale_height){
            if((!draw_mode_line) && (!draw_mode_fibo) && (!draw_mode_hline) && (!draw_mode_rectangle)){
                _vertical_scroll_current_max = max_price;
                _vertical_scroll_current_min = min_price;
                _vertical_scroll_current_max_visible = max_price_visible;
                _vertical_scroll_current_min_visible = min_price_visible;
                _vertical_scroll_moving = true;
                _vertical_scroll_active = true;
                _vertical_scroll_distancia = mouse_y;
            }
        }

        if (draw_mode_line == true) {
            // comenzar a dibujar la linea.
            draw_mode = true;
            start_draw_mode (TradeSim.Services.Drawings.Type.LINE);
        }

        if (draw_mode_fibo == true) {
            // comenzar a dibujar la linea.
            draw_mode = true;
            start_draw_mode (TradeSim.Services.Drawings.Type.FIBONACCI);
        }

        if (draw_mode_rectangle == true) {
            // comenzar a dibujar la linea.
            draw_mode = true;
            start_draw_mode (TradeSim.Services.Drawings.Type.RECTANGLE);
        }

        if (draw_mode_hline == true) {
            // comenzar a dibujar la linea.
            draw_mode = true;
            start_draw_mode (TradeSim.Services.Drawings.Type.HLINE);
        }

        for (int i = 0 ; i < draw_manager.operations.length ; i++) {
            draw_manager.operations.index (i).drag_start (mouse_x, mouse_y);
        }



        return true;
    }

    public bool on_mouse_up (Gdk.EventButton event) {

        _horizontal_scroll_moving = false;

        _vertical_scroll_moving = false;
        _vertical_scroll_active = false;

        if (draw_mode == true) {

            var target = main_window.main_layout.drawings_panel;

            if (draw_mode_line == true) {
                target.insert_object (draw_mode_id, TradeSim.Services.Drawings.Type.LINE);
                need_save = true;
            } else if (draw_mode_fibo == true) {
                target.insert_object (draw_mode_id, TradeSim.Services.Drawings.Type.FIBONACCI);
                need_save = true;
            } else if (draw_mode_rectangle == true) {
                target.insert_object (draw_mode_id, TradeSim.Services.Drawings.Type.RECTANGLE);
                need_save = true;
            } else if (draw_mode_hline == true) {
                target.insert_object (draw_mode_id, TradeSim.Services.Drawings.Type.HLINE);
                need_save = true;
            }

        }

        for (int i = 0 ; i < draw_manager.operations.length ; i++) {
            draw_manager.operations.index (i).drag_end ();
        }

        draw_mode_line = false; // Si se estaba dibujando se aborta.
        draw_mode_fibo = false; // Si se estaba dibujando se aborta.
        draw_mode_rectangle = false; // Si se estaba dibujando se aborta.
        draw_mode_hline = false; // Si se estaba dibujando se aborta.
        draw_mode = false;

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
        //ctext.set_source_rgba (0, 0, 0, 1);
        color_palette.canvas_cross_line.apply_to(ctext);
        ctext.move_to (0, mouse_y);
        ctext.line_to (_width, mouse_y);
        ctext.stroke ();

        // vertical
        ctext.set_line_width (0.2);
        color_palette.canvas_cross_line.apply_to(ctext);
        ctext.move_to (mouse_x, 0);
        ctext.line_to (mouse_x, _available_height);
        ctext.stroke ();

    }

    public void draw_candle (Cairo.Context ctext, TradeSim.Services.QuoteItem candle_data) {

        if (candle_data.date_time == null) {
            return;
        }

        drawed_candles++;

        if(last_candle_date == null){
            last_candle_date = candle_data.date_time;
            last_candle_price = candle_data.close_price;
            last_candle_max_price = candle_data.max_price;
            last_candle_min_price = candle_data.min_price;
        }else if(candle_data.date_time.compare(last_candle_date) >= 0){
            last_candle_date = candle_data.date_time;
            last_candle_price = candle_data.close_price;
            last_candle_max_price = candle_data.max_price;
            last_candle_min_price = candle_data.min_price;
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

    public void write_text_color (Cairo.Context ctext, int x, int y, string txt, TradeSim.Utils.Color txt_color) {

        Pango.Layout layout;

        layout = create_pango_layout (txt);

        txt_color.apply_to(ctext); //ctext.set_source_rgba (0, 0, 0, 1);
        ctext.move_to (x, y);
        Pango.cairo_update_layout (ctext, layout);
        Pango.cairo_show_layout (ctext, layout);

        queue_draw ();

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

    public void write_text_white (Cairo.Context ctext, int x, int y, string txt) {

        Pango.Layout layout;

        layout = create_pango_layout (txt);

        ctext.set_source_rgba (_r (255), _g (255), _b (255), 1);
        ctext.move_to (x, y);
        Pango.cairo_update_layout (ctext, layout);
        Pango.cairo_show_layout (ctext, layout);

        queue_draw ();

    }

    public void write_text_custom_size (string txt, Pango.FontDescription font, out int txt_width, out int txt_height) {

        Pango.Layout layout;

        layout = create_pango_layout (txt);
        layout.set_font_description (font);
        layout.get_pixel_size (out txt_width, out txt_height);

    }

    public void write_text_custom (Cairo.Context ctext, int x, int y, string txt, int cred, int cgreen, int cblue, Pango.FontDescription font) {

        Pango.Layout layout;

        layout = create_pango_layout (txt);

        layout.set_font_description (font);

        ctext.set_source_rgba (_r (cred), _g (cgreen), _b (cblue), 1);
        ctext.move_to (x, y);
        Pango.cairo_update_layout (ctext, layout);
        Pango.cairo_show_layout (ctext, layout);

        queue_draw ();

    }

    /*public void draw_line (Cairo.Context ctext, int x1, int y1, int x2, int y2, double size, int r, int g, int b, bool dash = false, double dash_type = 5.0) {

        ctext.set_dash ({}, 0);

        if (dash) {
            ctext.set_dash ({ dash_type }, 0);
        }

        ctext.set_line_width (size);
        ctext.set_source_rgba (_r (r), _g (g), _b (b), 1);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }*/

    public void draw_line_color (Cairo.Context ctext, int x1, int y1, int x2, int y2, double size, TradeSim.Utils.Color line_color, bool dash = false, double dash_type = 5.0) {

        ctext.set_dash ({}, 0);

        if (dash) {
            ctext.set_dash ({ dash_type }, 0);
        }

        ctext.set_line_width (size);
        line_color.apply_to(ctext);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }

    public void draw_bg (Cairo.Context ctext) {

        color_palette.canvas_bg.apply_to(ctext);
        ctext.rectangle (0, 0, _width, _height);
        ctext.fill ();
        ctext.stroke ();

    }

    public void horizontal_scrollbar_width_calc () {
        int displayed_size = get_candle_count_betwen_dates (date_from, date_to);
        uint display_size = data.quotes.length;
        double scrollbar_size_factor = displayed_size * 1.00 / display_size; // por ejemplo si es 0.5 la barra tiene la mitad de available_width;
        double aux = (_width - vertical_scale_width - 1.00) * scrollbar_size_factor;

        _horizontal_scroll_width = int.parse (aux.to_string ());
    }

    public void draw_horizontal_scrollbar (Cairo.Context ctext) {

        horizontal_scrollbar_width_calc ();

        if (_horizontal_scroll_width < _width - vertical_scale_width - 1.00) {

            _horizontal_scroll_active = true;

            //ctext.set_source_rgba (_r (212), _g (142), _b (21), 1);
            color_palette.canvas_horizontal_scroll_bg.apply_to (ctext);
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

        //ctext.set_source_rgba (_r (173), _g (95), _b (0), 1);
        color_palette.canvas_horizontal_scale_label_bg.apply_to(ctext);
        ctext.rectangle (mouse_x - 70, _available_height, 140, _horizontal_scale_height);
        ctext.fill ();

        ctext.move_to (mouse_x, _available_height);
        ctext.rel_line_to (-10, 0);
        ctext.rel_line_to (10, -10);
        ctext.rel_line_to (10, 10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        color_palette.canvas_horizontal_scale_label_bg.apply_to(ctext);
        //ctext.set_source_rgb (_r (173), _g (95), _b (0));
        ctext.fill_preserve ();
        ctext.stroke ();

        write_text_color (ctext, mouse_x - 56, _available_height + 4, get_date_time_by_pos_x (mouse_x), color_palette.canvas_horizontal_scale_label_fg);

    }

    public void draw_cursor_price_label (Cairo.Context ctext) {

        if (!show_vertical_scale_label) {
            return;
        }

        ctext.set_dash ({}, 0);

        //ctext.set_source_rgba (_r (173), _g (95), _b (0), 1);
        color_palette.canvas_cross_line_price_label_bg.apply_to(ctext);
        ctext.rectangle (_width - vertical_scale_width, mouse_y - 10, vertical_scale_width, 20);
        ctext.fill ();

        ctext.move_to (_width - vertical_scale_width, mouse_y + 10);
        ctext.rel_line_to (-10, -10);
        ctext.rel_line_to (10, -10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        color_palette.canvas_cross_line_price_label_bg.apply_to(ctext);
        //ctext.set_source_rgb (_r (173), _g (95), _b (0));
        ctext.fill_preserve ();
        ctext.stroke ();

        write_text_color (ctext, _width - (vertical_scale_width - 5), mouse_y - 9, get_str_price_by_pos_y (mouse_y), color_palette.canvas_vertical_scale_label_fg);

    }

    public void draw_last_candle_price_label (Cairo.Context ctext) {

        int posy = get_pos_y_by_price (last_candle_price);

        ctext.set_dash ({}, 0);

        //ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        color_palette.canvas_vertical_scale_price_label_bg.apply_to(ctext);
        ctext.rectangle (_width - vertical_scale_width, posy - 10, vertical_scale_width, 20);
        ctext.fill ();

        ctext.move_to (_width - vertical_scale_width, posy + 10);
        ctext.rel_line_to (-10, -10);
        ctext.rel_line_to (10, -10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        //ctext.set_source_rgb (_r (13), _g (82), _b (191));
        color_palette.canvas_vertical_scale_price_label_bg.apply_to(ctext);
        ctext.fill_preserve ();
        ctext.stroke ();

        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        //ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        color_palette.canvas_vertical_scale_price_label_bg.apply_to(ctext);
        ctext.move_to (0, posy);
        ctext.line_to (_width, posy);
        ctext.stroke ();

        write_text_color (ctext, _width - (vertical_scale_width - 4), posy - 8, get_str_price_by_double (last_candle_price), color_palette.canvas_vertical_scale_price_label_fg);

    }

    public void draw_horizontal_scale (Cairo.Context ctext) {

        ctext.set_dash ({}, 0);

        //ctext.set_source_rgba (_r (255), _g (225), _b (107), 1);
        color_palette.canvas_horizontal_scale_bg.apply_to(ctext);
        ctext.rectangle (0, _available_height, _width, _available_height);
        ctext.fill ();

        ctext.set_line_width (0.7);
        //ctext.set_source_rgba (_r (212), _g (142), _b (21), 1);
        color_palette.canvas_border.apply_to(ctext);
        ctext.move_to (0, _available_height);
        ctext.line_to (_width, _available_height);
        ctext.stroke ();

    }

    public void draw_vertical_scale (Cairo.Context ctext) {

        int pos_y = 0;
        int scale_label_dist = (int) (_available_height / 6);
        double precio = get_price_by_pos_y(pos_y);
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        ctext.set_dash ({}, 0);

        //ctext.set_source_rgba (_r (255), _g (225), _b (107), 1);
        color_palette.canvas_vertical_scale_bg.apply_to(ctext);
        ctext.rectangle (_width - vertical_scale_width, 0, 60, _available_height);
        ctext.fill ();
        ctext.stroke ();

        ctext.set_line_width (1);
        color_palette.canvas_border.apply_to(ctext);
        //ctext.set_source_rgba (_r (212), _g (142), _b (21), 1);
        ctext.move_to (_width - vertical_scale_width, 0);
        ctext.line_to (_width - vertical_scale_width, _available_height);
        ctext.stroke ();

        while (pos_y < _available_height) {

            double show_price = precio / 100000;

            //draw_line (ctext, 0, pos_y, _width - vertical_scale_width, pos_y, 0.3, 212, 142, 21, false);
            draw_line_color (ctext, 0, pos_y, _width - vertical_scale_width, pos_y, 0.3, color_palette.canvas_border, false);

            write_text_color (ctext, _width - (vertical_scale_width - 5), pos_y, show_price.format (buf, "%g").concat ("0000").substring (0, 7), color_palette.canvas_vertical_scale_label_fg);

            pos_y += scale_label_dist;

            precio = get_price_by_pos_y(pos_y);

        }

    }

    public void draw_chart (Cairo.Context ctext) {

        // dibujar solo la cantidad fecha desde hasta....

        DateTime cursor_date = date_from;

        drawed_candles = 0; // Se incrementa dentro de get_quote_by_time.

        while (cursor_date.compare (date_to) < 0) {

            draw_candle (ctext, data.get_quote_by_time (cursor_date));

            cursor_date = date_add_int_by_time_frame (cursor_date, time_frame, 1);

        }

    }

    public void start_user_draw_line () {
        // Esta funcion la debe llamar el menu de insertar linea.
        draw_mode_line = true;
        draw_mode_objects++;
        draw_mode_id = "Line " + draw_mode_objects.to_string ();
    }

    public void start_user_draw_fibo () {
        // Esta funcion la debe llamar el menu de insertar linea.
        draw_mode_fibo = true;
        draw_mode_objects++;
        draw_mode_id = "Fibonacci " + draw_mode_objects.to_string ();
    }

    public void start_user_draw_rectangle () {
        // Esta funcion la debe llamar el menu de insertar linea.
        draw_mode_rectangle = true;
        draw_mode_objects++;
        draw_mode_id = "Rectangle " + draw_mode_objects.to_string ();
    }

    public void start_user_draw_hline () {
        // Esta funcion la debe llamar el menu de insertar linea.
        draw_mode_hline = true;
        draw_mode_objects++;
        draw_mode_id = "Horizontal Line " + draw_mode_objects.to_string ();
    }

    public void user_draw_line () {

        if ((draw_mode_line) && (draw_mode)) {
            DateTime posx = get_date_time_fecha_by_pos_x (mouse_x);
            double posy = get_price_by_pos_y (mouse_y) / 100000.00;
            draw_manager.draw_line (draw_mode_id, posx, posy, posx, posy);
        }

    }

    public void user_draw_fibo () {

        if ((draw_mode_fibo) && (draw_mode)) {
            DateTime posx = get_date_time_fecha_by_pos_x (mouse_x);
            double posy = get_price_by_pos_y (mouse_y) / 100000.00;
            draw_manager.draw_fibonacci (draw_mode_id, posx, posy, posx, posy);
        }

    }

    public void user_draw_rectangle () {

        if ((draw_mode_rectangle) && (draw_mode)) {
            DateTime posx = get_date_time_fecha_by_pos_x (mouse_x);
            double posy = get_price_by_pos_y (mouse_y) / 100000.00;
            draw_manager.draw_rectangle (draw_mode_id, posx, posy, posx, posy);
        }

    }

    public void user_draw_hline () {

        if ((draw_mode_hline) && (draw_mode)) {
            DateTime posx = get_date_time_fecha_by_pos_x (mouse_x);
            double posy = get_price_by_pos_y (mouse_y) / 100000.00;
            draw_manager.draw_hline (draw_mode_id, posx, posy, posx, posy);
        }

    }

    public void draw_operation_info (TradeSim.Objects.OperationItem _op) {

        draw_manager.draw_operation (_op);

    }

    public void start_draw_mode (int type) {

        if (type == TradeSim.Services.Drawings.Type.LINE) {
            user_draw_line ();
        } else if (type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            user_draw_fibo ();
        } else if (type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            user_draw_rectangle ();
        } else if (type == TradeSim.Services.Drawings.Type.HLINE) {
            user_draw_hline ();
        }

    }

    public void end_draw_mode (int type) {

        if (type == TradeSim.Services.Drawings.Type.LINE) {
            draw_mode_line = false;
        } else if (type == TradeSim.Services.Drawings.Type.FIBONACCI) {
            draw_mode_fibo = false;
        } else if (type == TradeSim.Services.Drawings.Type.RECTANGLE) {
            draw_mode_rectangle = false;
        } else if (type == TradeSim.Services.Drawings.Type.HLINE) {
            draw_mode_hline = false;
        }

    }

    public override bool draw (Cairo.Context cr) {

        _width = get_allocated_width ();
        _height = get_allocated_height ();

        _available_height = _height - _horizontal_scroll_height - _horizontal_scale_height;

        vertical_scale_calculation ();
        horizontal_scale_calculation ();

        draw_bg (cr);

        draw_chart (cr);

        // Lleva el scroll al final cuando se carga un archivo.
        if (!scroll_from_file_setted) {
            horizontal_scroll_position_end ();
            scroll_from_file_setted = true;
        }

        draw_manager.show_all (cr); // Dibuja todos los objetos creados por el usuario.

        draw_vertical_scale (cr);

        draw_manager.show_all_in_vertical_scale (cr);

        draw_cross_lines (cr);

        draw_horizontal_scale (cr);
        draw_cursor_price_label (cr);
        draw_cursor_datetime_label (cr);

        draw_horizontal_scrollbar (cr);

        draw_last_candle_price_label (cr); // Muestra el precio de la ultima vela.

        cr.restore ();
        cr.save ();

        return true;

    }

    public override void size_allocate (Gtk.Allocation allocation) {

        // cuando cambia el tamaño
        base.size_allocate (allocation);

    }

}
