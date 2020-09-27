public class TradeSim.Drawings.Rectangle : TradeSim.Drawings.Line {

    public Rectangle (TradeSim.Widgets.Canvas canvas, string _id) {

        base (canvas, _id);
        
    }

    public override void render (Cairo.Context ctext) {

        update_data ();

        ctext.set_source_rgba (_r (53), _g (100), _b (86), 0.5);
        ctext.rectangle (x1, y1, x2-x1, y2-y1);
        ctext.fill ();
        ctext.stroke ();

    }

}