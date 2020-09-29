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