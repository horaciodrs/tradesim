public class TradeSim.Drawings.Fibonacci : TradeSim.Drawings.Line {

    public Fibonacci (TradeSim.Widgets.Canvas canvas, string _id) {

        base (canvas, _id);
        
    }

    public override void render (Cairo.Context ctext) {

        update_data ();

        int distancia_vertical = y2 - y1;

        int y382;
        int y50;
        int y618;

        y382 = (int) (y1 + distancia_vertical * 0.382);
        y50 = (int) (y1 + distancia_vertical * 0.5);
        y618 = (int) (y1 + distancia_vertical * 0.618);

        //Linea Diagonal
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

        //Linea 0
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y1);
        ctext.stroke ();

        //Linea 382
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y382);
        ctext.line_to (x2, y382);
        ctext.stroke ();

        //Linea 50
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y50);
        ctext.line_to (x2, y50);
        ctext.stroke ();

        //Linea 618
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y618);
        ctext.line_to (x2, y618);
        ctext.stroke ();

        //Linea 100
        ctext.set_dash ({}, 0);
        ctext.set_line_width (1);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y2);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }

}