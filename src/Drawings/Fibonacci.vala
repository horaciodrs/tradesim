public class TradeSim.Drawings.Fibonacci : TradeSim.Drawings.Line {

    public Fibonacci (TradeSim.Widgets.Canvas canvas, string _id) {

        base (canvas, _id);

    }

    public Fibonacci.default () {
        base.default ();
    }

    public override void render (Cairo.Context ctext) {

        if (!visible) {
            return;
        }

        update_data ();

        if (date1.compare (ref_canvas.date_from) < 0) {
            if (date2.compare (ref_canvas.date_from) < 0) {
                return;
            }
        }

        if(ref_canvas.draw_mode_fibo){
            handler.draw (ctext);
        }

        int distancia_vertical = y2 - y1;
        int x_fibo = x2;

        if (x2 < x1) {
            x_fibo = x1;
        }

        x_fibo += 5;

        int y382;
        int y50;
        int y618;

        Pango.FontDescription font = new Pango.FontDescription ();
        font.set_size (8 * Pango.SCALE);

        y382 = (int) (y1 + distancia_vertical * 0.382);
        y50 = (int) (y1 + distancia_vertical * 0.5);
        y618 = (int) (y1 + distancia_vertical * 0.618);

        // Linea Diagonal
        ctext.set_dash ({ 5.0 }, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

        // Linea 0
        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y1);
        ctext.stroke ();
        ref_canvas.write_text_custom (ctext, x_fibo, y1 - 6, "0.00%", color.red, color.green, color.blue, font);

        // Linea 382
        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y382);
        ctext.line_to (x2, y382);
        ctext.stroke ();
        ref_canvas.write_text_custom (ctext, x_fibo, y382 - 6, "38.20%", color.red, color.green, color.blue, font);

        // Linea 50
        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y50);
        ctext.line_to (x2, y50);
        ctext.stroke ();
        ref_canvas.write_text_custom (ctext, x_fibo, y50 - 6, "50.00%", color.red, color.green, color.blue, font);

        // Linea 618
        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y618);
        ctext.line_to (x2, y618);
        ctext.stroke ();
        ref_canvas.write_text_custom (ctext, x_fibo, y618 - 6, "61.80%", color.red, color.green, color.blue, font);

        // Linea 100
        ctext.set_dash ({}, 0);
        ctext.set_line_width (thickness);
        color.apply_to (ctext);
        ctext.move_to (x1, y2);
        ctext.line_to (x2, y2);
        ctext.stroke ();
        ref_canvas.write_text_custom (ctext, x_fibo, y2 - 6, "100.00%", color.red, color.green, color.blue, font);

    }

    public override void write_file (Xml.TextWriter writer, bool unused) throws FileError {

        writer.start_element ("fibonacci");
        base.write_file (writer, false);
        writer.end_element ();

    }

}
