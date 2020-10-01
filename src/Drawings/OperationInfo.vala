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

public class TradeSim.Drawings.OperationInfo : TradeSim.Drawings.Line {

    public TradeSim.Objects.OperationItem operation_data;

    /*
     * Utilizamos las propiedades x1, y1, x2, y2 como indicador
     * de la posición del mouse.
     * Ya que la posición donde vamos a dibujar esta dada por
     * las caracteristicas de cada operación.
     */

    public OperationInfo (TradeSim.Widgets.Canvas _canvas, string _id) {

        base (_canvas, _id);

    }

    public override void render (Cairo.Context ctext) {

        if(!visible){
            return;
        }

        // update_data();

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

        string tp_desc = operation_data.id.to_string () + " - TP";

        draw_price_label (ctext, operation_data.tp, 0, 100, 0);
        draw_left_desc (ctext, tp_desc, y_tp, 0, 100, 0);

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

        string op_sl = operation_data.id.to_string () + " - " + "SL";

        draw_price_label (ctext, operation_data.sl, 100, 0, 0);
        draw_left_desc (ctext, op_sl, y_sl, 100, 0, 0);

    }

    public void draw_left_desc (Cairo.Context ctext, string _desc, int posy, int cred, int cgreen, int cblue) {

        Gtk.DrawingArea aux_canvas;
        Pango.Layout layout;
        int txt_width;
        int txt_height;
        int padding = 6;

        aux_canvas = new Gtk.DrawingArea();
        layout = aux_canvas.create_pango_layout(_desc);
        layout.get_pixel_size(out txt_width, out txt_height);

        ctext.set_source_rgba (_r (cred), _g (cgreen), _b (cblue), 1);
        ctext.rectangle (0, posy - txt_height - padding, txt_width + 20, txt_height + padding);
        ctext.fill ();

        int txt_y = posy - txt_height - padding/2;

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