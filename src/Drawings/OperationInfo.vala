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

public class TradeSim.Drawings.OperationInfo : TradeSim.Drawings.Line {

    public TradeSim.Objects.OperationItem operation_data;

    private TradeSim.Drawings.OperationBox box_tp;
    private TradeSim.Drawings.OperationBox box_sl;

    /*
     * Utilizamos las propiedades x1, y1, x2, y2 como indicador
     * de la posición del mouse.
     * Ya que la posición donde vamos a dibujar esta dada por
     * las caracteristicas de cada operación.
     */

    // IMPORTANTE:
    // ===========
    // Las funciones de write_file no las implemento aquí ya que los dibujos
    // se generan leyendo las operaciones cargadas...

    public OperationInfo (TradeSim.Widgets.Canvas _canvas, string _id) {

        base (_canvas, _id);

        box_tp = new TradeSim.Drawings.OperationBox (this, TradeSim.Drawings.OperationBox.Type.TP);
        box_sl = new TradeSim.Drawings.OperationBox (this, TradeSim.Drawings.OperationBox.Type.SL);

    }

    public void drag_start (int mouse_x, int mouse_y) {
        box_tp.drag_start (mouse_x, mouse_y);
        box_sl.drag_start (mouse_x, mouse_y);
    }

    public void drag (TradeSim.Widgets.Canvas ref_canvas, int mouse_x, int mouse_y) {

        // Esta función esta pensada para ser llamada
        // cuando el boton del mouse se encuentra presionado.
        // La función modifica la posición vertical donde
        // se dibuja la linea de tp y en base a esta nueva
        // posicion se recalcula el precio de tp
        // y se modifica en dicha operación.
        // Esta idea se aplica tanto para TP como para SL.

        // Verificamos click en la zona de TP.
        box_tp.drag (ref_canvas, mouse_x, mouse_y);

        // Verificamos click en la zona de SL.
        box_sl.drag (ref_canvas, mouse_x, mouse_y);

    }

    public void drag_end () {
        box_tp.drag_end ();
        box_sl.drag_end ();
    }

    public override void render (Cairo.Context ctext) {

        if (!operation_data.visible) {
            return;
        }

        // Dibujar el historial.

        draw_operation_history_line (ctext);

        // Dibujar un circulo en la vela donde se abrio la operación.

        int open_op_x = ref_canvas.get_pos_x_by_date (operation_data.operation_date);
        int open_op_y = -1;
        double aux_price = -1.0;
        double xc = -1.0;
        double yc = -1.0;
        double radius = 0;

        if (open_op_x > 0) {
            if (operation_data.type_op == TradeSim.Objects.OperationItem.Type.BUY) {
                aux_price = ref_canvas.data.get_quote_by_time (operation_data.operation_date).min_price;
                open_op_y = ref_canvas.get_pos_y_by_price (aux_price);
                xc = (int) (open_op_x + ref_canvas.candle_width / 2);
                yc = open_op_y + ref_canvas.candle_width;
                radius = ref_canvas.candle_width / 2;
            } else if (operation_data.type_op == TradeSim.Objects.OperationItem.Type.SELL) {
                aux_price = ref_canvas.data.get_quote_by_time (operation_data.operation_date).max_price;
                open_op_y = ref_canvas.get_pos_y_by_price (aux_price);
                xc = (int) (open_op_x + ref_canvas.candle_width / 2);
                yc = open_op_y - ref_canvas.candle_width;
                radius = ref_canvas.candle_width / 2;
            }
        }

        var circle_color = new TradeSim.Utils.Color (54, 134, 230);

        circle_color.apply_to (ctext);
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1.0);
        ctext.arc (xc, yc, radius, 0, 2 * Math.PI);
        ctext.fill ();


        if (!visible) {
            return;
        }

        if (operation_data == null) {
            return;
        }

        if (operation_data.state == TradeSim.Objects.OperationItem.State.CLOSED) {
            return;
        }

        int line_width = 2;

        int y_tp = ref_canvas.get_pos_y_by_price (operation_data.tp);
        int y_op = ref_canvas.get_pos_y_by_price (operation_data.price);
        int y_sl = ref_canvas.get_pos_y_by_price (operation_data.sl);

        // Draw Line TP.

        ctext.set_dash ({}, 0);
        ctext.set_line_width (line_width);
        ctext.set_source_rgba (_r (0), _g (100), _b (0), 1);
        ctext.move_to (0, y_tp);
        ctext.line_to (ref_canvas._width, y_tp);
        ctext.stroke ();


        var tp_color = new TradeSim.Utils.Color (0, 100, 0);

        draw_price_label (ctext, operation_data.tp, 0, 100, 0);
        box_tp.draw (ref_canvas, ctext, y_tp, tp_color);

        // Draw Line OPEN

        ctext.set_dash ({}, 0);
        ctext.set_line_width (line_width);
        ctext.set_source_rgba (_r (0), _g (0), _b (0), 1);
        ctext.move_to (0, y_op);
        ctext.line_to (ref_canvas._width, y_op);
        ctext.stroke ();

        string op_desc = operation_data.id.to_string () + " - " + "Open";

        draw_price_label (ctext, operation_data.price, 0, 0, 0);
        draw_left_desc (ctext, op_desc, y_op, 0, 0, 0);

        // Draw Line SL

        ctext.set_dash ({}, 0);
        ctext.set_line_width (line_width);
        ctext.set_source_rgba (_r (100), _g (0), _b (0), 1);
        ctext.move_to (0, y_sl);
        ctext.line_to (ref_canvas._width, y_sl);
        ctext.stroke ();

        var sl_color = new TradeSim.Utils.Color (100, 0, 0);

        draw_price_label (ctext, operation_data.sl, 100, 0, 0);
        box_sl.draw (ref_canvas, ctext, y_sl, sl_color);

    }

    public void render_vertical_scale (Cairo.Context ctext) {

        if (!operation_data.visible) {
            return;
        }

        if (!visible) {
            return;
        }

        if (operation_data == null) {
            return;
        }

        if (operation_data.state == TradeSim.Objects.OperationItem.State.CLOSED) {
            return;
        }

        draw_price_label (ctext, operation_data.tp, 0, 100, 0);
        draw_price_label (ctext, operation_data.price, 0, 0, 0);
        draw_price_label (ctext, operation_data.sl, 100, 0, 0);

    }

    public void draw_operation_history_line (Cairo.Context ctext) {

        if (operation_data.state == TradeSim.Objects.OperationItem.State.CLOSED) {

            if (operation_data.operation_date.compare (ref_canvas.date_from) < 0) {
                if (operation_data.close_date.compare (ref_canvas.date_from) < 0) {
                    return;
                }
            }

            int xi = ref_canvas.get_pos_x_by_date (operation_data.operation_date);
            int xf = ref_canvas.get_pos_x_by_date (operation_data.close_date);
            int yi = ref_canvas.get_pos_y_by_price (operation_data.price);
            int yf = ref_canvas.get_pos_y_by_price (operation_data.close_price);
            TradeSim.Utils.Color aux_color = new TradeSim.Utils.Color (204, 59, 2);

            ctext.set_dash ({ 5.0 }, 0);
            ctext.set_line_width (2);
            aux_color.apply_to (ctext);
            ctext.move_to (xi, yi);
            ctext.line_to (xf, yf);
            ctext.stroke ();

        }

    }

    public void draw_left_desc (Cairo.Context ctext, string _desc, int posy, int cred, int cgreen, int cblue) {

        Gtk.DrawingArea aux_canvas;
        Pango.Layout layout;
        int txt_width;
        int txt_height;
        int padding = 6;

        aux_canvas = new Gtk.DrawingArea ();
        layout = aux_canvas.create_pango_layout (_desc);
        layout.get_pixel_size (out txt_width, out txt_height);

        int left_desc_x = 0;
        int left_desc_y = posy - txt_height - padding;
        int left_desc_w = txt_width + 20;
        int left_desc_h = txt_height + padding;

        ctext.set_source_rgba (_r (cred), _g (cgreen), _b (cblue), 1);
        ctext.rectangle (left_desc_x, left_desc_y, left_desc_w, left_desc_h);
        ctext.fill ();

        int txt_y = posy - txt_height - padding / 2;

        ref_canvas.write_text_white (ctext, padding, txt_y, _desc);

    }

    public void draw_price_label (Cairo.Context ctext, double _price, int cred, int cgreen, int cblue) {

        int posy = ref_canvas.get_pos_y_by_price (_price);

        ctext.set_dash ({}, 0);

        ctext.set_source_rgba (_r (cred), _g (cgreen), _b (cblue), 1);
        ctext.rectangle (ref_canvas._width - ref_canvas.vertical_scale_width, posy - 10, ref_canvas.vertical_scale_width, 20);
        ctext.fill ();

        ctext.move_to (ref_canvas._width - ref_canvas.vertical_scale_width, posy + 10);
        ctext.rel_line_to (-10, -10);
        ctext.rel_line_to (10, -10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        ctext.set_source_rgba (_r (cred), _g (cgreen), _b (cblue), 1);
        ctext.fill_preserve ();
        ctext.stroke ();

        ctext.set_dash ({ 5.0 }, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (cred), _g (cgreen), _b (cblue), 1);
        ctext.move_to (0, posy);
        ctext.line_to (ref_canvas._width, posy);
        ctext.stroke ();

        ref_canvas.write_text_white (ctext, ref_canvas._width - (ref_canvas.vertical_scale_width - 4), posy - 8, ref_canvas.get_str_price_by_double (_price));

    }

    public void set_data (TradeSim.Objects.OperationItem op) {
        operation_data = op;
    }

}
