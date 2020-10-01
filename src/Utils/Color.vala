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

public class TradeSim.Utils.Color{

    public int red;
    public int green;
    public int blue;
    public double alpha;

    public Color(int _red, int _green, int _blue){
        red = _red;
        green = _green;
        blue = _blue;
        alpha = 1.0;
    }

    public Color.with_alpha(int _red, int _green, int _blue, double _alpha){
        red = _red;
        green = _green;
        blue = _blue;
        alpha = _alpha;
    }

    public Color.default(){
        red = 13;
        green = 82;
        blue = 191;
        alpha = 1.0;
    }

    public Color.with_rgba(Gdk.RGBA _aux){

        red = (int) (_aux.red * 255);
        green = (int) (_aux.green * 255);
        blue = (int) (_aux.blue * 255);
        alpha = _aux.alpha;
        
    }

    public void apply_to(Cairo.Context ctext){
        ctext.set_source_rgba(_r(red), _g(green), _b(blue), alpha);
    }

    public Gdk.RGBA get_rgba(){

        Gdk.RGBA return_value = {red/255.00, green/255.00, blue/255.00, alpha};

        return return_value;

    }

}