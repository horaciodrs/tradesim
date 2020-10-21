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

public class TradeSim.Drawings.HLine : TradeSim.Drawings.Line {

    public HLine (TradeSim.Widgets.Canvas canvas, string _id) {

        base (canvas, _id);

        thickness = TradeSim.Services.Drawings.Thickness.THICK;

    }

    public HLine.default () {
        base.default ();
    }

    public override void render (Cairo.Context ctext) {

        if (!visible) {
            return;
        }

        update_data ();

        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (0, y2);
        ctext.line_to (ref_canvas._width, y2);
        ctext.stroke ();

        draw_price_label (ctext);

    }

    public  void render_vertical_scale (Cairo.Context ctext) {

        if (!visible) {
            return;
        }

        update_data ();

        draw_price_label (ctext);

    }

    public void draw_price_label (Cairo.Context ctext) {

        int posy = ref_canvas.get_pos_y_by_price (price2);

        ctext.set_dash ({}, 0);

        color.apply_to (ctext);
        ctext.rectangle (ref_canvas._width - ref_canvas.vertical_scale_width, posy - 10, ref_canvas.vertical_scale_width, 20);
        ctext.fill ();

        ctext.move_to (ref_canvas._width - ref_canvas.vertical_scale_width, posy + 10);
        ctext.rel_line_to (-10, -10);
        ctext.rel_line_to (10, -10);
        ctext.close_path ();

        ctext.set_line_width (1.0);
        color.apply_to (ctext);
        ctext.fill_preserve ();
        ctext.stroke ();

        ctext.set_dash ({ 5.0 }, 0);
        ctext.set_line_width (1);
        color.apply_to (ctext);
        ctext.move_to (0, posy);
        ctext.line_to (ref_canvas._width, posy);
        ctext.stroke ();

        ref_canvas.write_text_white (ctext, ref_canvas._width - (ref_canvas.vertical_scale_width - 4), posy - 8, ref_canvas.get_str_price_by_double (price2));

    }

    public override void write_file (Xml.TextWriter writer, bool unused) throws FileError {

        writer.start_element ("hline");
        base.write_file (writer, false);
        writer.end_element ();

    }

}
