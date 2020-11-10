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

public class TradeSim.Drawings.Line {

    public weak TradeSim.Widgets.Canvas ? ref_canvas;

    public string id;

    protected DateTime date1;
    protected DateTime date2;
    protected double price1;
    protected double price2;

    protected TradeSim.Utils.Color color;
    protected int thickness;

    protected bool visible;
    protected bool enabled;

    protected int ? x1; // Se calcula en base a date1.
    protected int ? x2; // Se calcula en base a date2.
    protected int ? y1; // Se calcula en base a price1.
    protected int ? y2; // Se calcula en base a price2.

    protected TradeSim.Drawings.DrawHandler handler;

    public Line (TradeSim.Widgets.Canvas _canvas, string _id) {
        id = _id;
        x1 = null;
        ref_canvas = _canvas;
        color = new TradeSim.Utils.Color.with_alpha (13, 82, 191, 1.0);
        thickness = TradeSim.Services.Drawings.Thickness.FINE;
        visible = true;
        enabled = true;
        handler = new TradeSim.Drawings.DrawHandler (this);
    }

    public Line.default () {

    }

    public void print_data () {
        print ("id:" + id + "\n");
        print ("date1:" + date1.to_string () + "\n");
        print ("date2:" + date2.to_string () + "\n");
        print ("price1:" + price1.to_string () + "\n");
        print ("price2:" + price2.to_string () + "\n");
        print ("color:" + color.to_string () + "\n");
        print ("thickness:" + thickness.to_string () + "\n");
        print ("visible:" + visible.to_string () + "\n");
        print ("enabled:" + enabled.to_string () + "\n");
    }

    protected void update_data () {

        x1 = ref_canvas.get_pos_x_by_date (date1);
        x2 = ref_canvas.get_pos_x_by_date (date2);
        y1 = ref_canvas.get_pos_y_by_price (price1);
        y2 = ref_canvas.get_pos_y_by_price (price2);

    }

    public virtual void render (Cairo.Context ctext) {

        if (!visible) {
            return;
        }

        update_data ();

        if (date1.compare (ref_canvas.date_from) < 0) {
            if (date2.compare (ref_canvas.date_from) < 0) {
                return;
            }
        }

        if(ref_canvas.draw_mode_line){
            handler.draw (ctext);
        }

        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }

    public void set_ref_canvas (TradeSim.Widgets.Canvas _canvas) {
        ref_canvas = _canvas;
    }

    public void set_id (string _id) {
        id = _id;
    }

    public void set_thickness (int _thicness) {
        thickness = _thicness;
    }

    public void set_color (TradeSim.Utils.Color _color) {
        color = _color;
    }

    public void set_x1 (DateTime d1) {
        date1 = d1;
    }

    public void set_x2 (DateTime d2) {
        date2 = d2;
    }

    public void set_y1 (double price) {
        price1 = price;
    }

    public void set_y2 (double price) {
        price2 = price;
    }

    public double ? get_y1 () {
        return price1;
    }

    public double ? get_y2 () {
        return price2;
    }

    public void set_date1 (DateTime d) {
        date1 = d;
    }

    public void set_date2 (DateTime d) {
        date2 = d;
    }

    public int ? get_x1 () {
        return x1;
    }

    public int ? get_x2 () {
        return x2;
    }

    public TradeSim.Utils.Color get_color () {
        return color;
    }

    public int get_thicness () {
        return thickness;
    }

    public void set_alpha (double _alpha) {
        color.alpha = _alpha;
    }

    public double get_alpha () {
        return color.alpha;
    }

    public bool get_visible () {
        return visible;
    }

    public void set_visible (bool _state) {
        visible = _state;
    }

    public bool get_enabled () {
        return enabled;
    }

    public void set_enabled (bool _enabled) {
        enabled = _enabled;
    }

    public virtual void write_file (Xml.TextWriter writer, bool write_header = false) throws FileError {

        if (write_header) {
            writer.start_element ("line");
        }

        writer.start_element ("id");
        writer.write_string (id);
        writer.end_element ();

        writer.start_element ("date1");
        writer.write_string (date1.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("date2");
        writer.write_string (date2.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("price1");
        writer.write_string (price1.to_string ());
        writer.end_element ();

        writer.start_element ("price2");
        writer.write_string (price2.to_string ());
        writer.end_element ();

        writer.start_element ("color");
        writer.write_attribute ("red", color.red.to_string ());
        writer.write_attribute ("green", color.green.to_string ());
        writer.write_attribute ("blue", color.blue.to_string ());
        writer.write_attribute ("alpha", color.alpha.to_string ());
        writer.write_string ("#ff9900");
        writer.end_element ();

        writer.start_element ("thickness");
        writer.write_string (thickness.to_string ());
        writer.end_element ();

        writer.start_element ("visible");
        writer.write_string (visible.to_string ());
        writer.end_element ();

        writer.start_element ("enabled");
        writer.write_string (enabled.to_string ());
        writer.end_element ();

        /*writer.start_element ("x1");
           writer.write_string (x1.to_string ());
           writer.end_element ();

           writer.start_element ("x2");
           writer.write_string (x2.to_string ());
           writer.end_element ();

           writer.start_element ("y1");
           writer.write_string (y1.to_string ());
           writer.end_element ();

           writer.start_element ("y2");
           writer.write_string (y2.to_string ());
           writer.end_element ();*/

        if (write_header) {
            writer.end_element ();
        }

    }

}
