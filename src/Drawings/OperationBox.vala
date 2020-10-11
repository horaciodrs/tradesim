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

public class TradeSim.Drawings.OperationBox {

    public weak TradeSim.Drawings.OperationInfo parent;

    public int left;
    public int top;
    public int width;
    public int height;
    public string text;

    public bool draging;
    public int ? mouse_dist_y;
    public int type;

    public enum Type {
        TP
        , SL
    }

    public OperationBox (TradeSim.Drawings.OperationInfo _parent, int _type) {
        parent = _parent;
        text = "";
        mouse_dist_y = null;
        draging = false;
        type = _type;
        update_price_level (parent.ref_canvas);
    }

    public void mouse_dist_y_calc (int mouse_y) {
        if (mouse_dist_y == null) {
            mouse_dist_y = mouse_y - top;
        }
    }

    public void drag_start (int mouse_x, int mouse_y) {
        if ((mouse_x >= left) && (mouse_x <= left + width)) {
            if ((mouse_y >= top) && (mouse_y <= top + height)) {
                draging = true;
                mouse_dist_y = null;
            }
        }
    }

    public void drag_end () {
        mouse_dist_y = null;
        draging = false;

        // llamar a update_operation_by_id(id_de_operacion) que esta en OperationsPanel...

        var target = parent.ref_canvas.main_window.main_layout.operations_panel;

        target.update_operation_by_id (parent.operation_data.id);

    }

    public void update_price_level (TradeSim.Widgets.Canvas ref_canvas) {
        /*
         * La idea de esta función es actualizar el precio de SL o de TP
         * según corresponda. Por esta razón necesitamos determinar
         * de alguna manera si es una Box de TP o de SL.
         * Esto lo hacemos a traves de un tipo de Box.
         */

        // Actualizar el precio calculado en base a la posición top
        // en parent.operation_data...

        if (parent.ref_canvas == null) {
            return;
        }

        if (parent.operation_data == null) {
            return;
        }

        if (type == TradeSim.Drawings.OperationBox.Type.TP) {
            parent.operation_data.tp = parent.ref_canvas.get_price_by_pos_y (top + height) / 100000.00;
        } else {
            parent.operation_data.sl = parent.ref_canvas.get_price_by_pos_y (top + height) / 100000.00;
        }

    }

    public void drag (TradeSim.Widgets.Canvas ref_canvas, int mouse_x, int mouse_y) {

        if (!draging) {
            return;
        }

        mouse_dist_y_calc (mouse_y);
        top = mouse_y - mouse_dist_y;

        double top_price = ref_canvas.get_price_by_pos_y (top + height) / 100000.00;

        if (parent.operation_data.type_op == TradeSim.Objects.OperationItem.Type.BUY) {

            if (type == TradeSim.Drawings.OperationBox.Type.TP) {

                if (top_price < ref_canvas.last_candle_price) {
                    top = ref_canvas.get_pos_y_by_price (ref_canvas.last_candle_price) - height;
                }

                if (top_price < parent.operation_data.price) {
                    top = ref_canvas.get_pos_y_by_price (parent.operation_data.price) - height;
                }

            } else if (type == TradeSim.Drawings.OperationBox.Type.SL) {

                if (top_price > ref_canvas.last_candle_price) {
                    top = ref_canvas.get_pos_y_by_price (ref_canvas.last_candle_price) - height;
                }

            }
        } else if (parent.operation_data.type_op == TradeSim.Objects.OperationItem.Type.SELL) {

            if (type == TradeSim.Drawings.OperationBox.Type.TP) {

                if (top_price > ref_canvas.last_candle_price) {
                    top = ref_canvas.get_pos_y_by_price (ref_canvas.last_candle_price) - height;
                }

                if (top_price > parent.operation_data.price) {
                    top = ref_canvas.get_pos_y_by_price (parent.operation_data.price) - height;
                }

            } else if (type == TradeSim.Drawings.OperationBox.Type.SL) {

                if (top_price < ref_canvas.last_candle_price) {
                    top = ref_canvas.get_pos_y_by_price (ref_canvas.last_candle_price) - height;
                }

            }

        }

        update_price_level (ref_canvas);
        return;

    }

    public void update_text () {

        text = "";
        text = text + parent.operation_data.id.to_string ();

        if (type == TradeSim.Drawings.OperationBox.Type.TP) {
            text = text + " - TP ($";
            text = text + parent.operation_data.get_str_tp_amount ();
            text = text + ")";
        } else {
            text = text + " - SL ($";
            text = text + parent.operation_data.get_str_sl_amount ();
            text = text + ")";
        }
    }

    public void set_text (string _text) {
        text = _text;
    }

    public void draw (TradeSim.Widgets.Canvas ref_canvas, Cairo.Context ctext, int posy, TradeSim.Utils.Color color) {

        update_text ();

        if (text == "") {
            return;
        }

        Gtk.DrawingArea aux_canvas;
        Pango.Layout layout;
        int txt_y;
        int txt_width;
        int txt_height;
        int padding = 6;

        aux_canvas = new Gtk.DrawingArea ();
        layout = aux_canvas.create_pango_layout (text);
        layout.get_pixel_size (out txt_width, out txt_height);

        // Asignación de la posición y las dimensiones.

        left = 0;

        if (draging == false) {
            // Cuando no se esta modificando utilizamos la posición estandar.
            top = posy - txt_height - padding;
            txt_y = posy - txt_height - padding / 2;
        } else {
            txt_y = top + txt_height - padding * 2;
        }

        width = txt_width + 20;
        height = txt_height + padding;

        color.apply_to (ctext);
        ctext.rectangle (left, top, width, height);
        ctext.fill ();

        ref_canvas.write_text_white (ctext, padding, txt_y, text);

    }

}
