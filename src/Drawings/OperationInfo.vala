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

    private TradeSim.Drawings.OperationBox box_tp;
    private TradeSim.Drawings.OperationBox box_sl;

    /*
     * Utilizamos las propiedades x1, y1, x2, y2 como indicador
     * de la posición del mouse.
     * Ya que la posición donde vamos a dibujar esta dada por
     * las caracteristicas de cada operación.
     */

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

        if (!visible) {
            return;
        }

        //box_tp.update_price_level (ref_canvas);
        //box_sl.update_price_level (ref_canvas);

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