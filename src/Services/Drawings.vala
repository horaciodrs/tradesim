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

public class TradeSim.Services.Drawings {

    public weak TradeSim.Widgets.Canvas ref_canvas;

    public enum Type{
          LINE
        , RECTANGLE
        , FIBONACCI
    }

    public bool drawing_mode; //Indica si se esta dibujando algo.

    public Array<TradeSim.Drawings.Line> lines;

    public Drawings(TradeSim.Widgets.Canvas _canvas){
        ref_canvas = _canvas;
    }

    public void show_all(){

        for(int i=0; i<lines.length;i++){
            lines.index(i).render(ref_canvas);
        }

    }
}