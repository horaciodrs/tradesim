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

    public weak TradeSim.Widgets.Canvas ref_canvas;

    public string id;

    protected DateTime date1;
    protected DateTime date2;
    protected double price1;
    protected double price2;
    
    protected int? x1; //Se calcula en base a date1.
    protected int? x2; //Se calcula en base a date2.
    protected int? y1; //Se calcula en base a price1.
    protected int? y2; //Se calcula en base a price2.

    public Line(TradeSim.Widgets.Canvas _canvas, string _id){
        id = _id;
        x1 = null;
        ref_canvas = _canvas;
    }

    protected void update_data(){

        x1 = ref_canvas.get_pos_x_by_date(date1);
        x2 = ref_canvas.get_pos_x_by_date(date2);
        y1 = ref_canvas.get_pos_y_by_price(price1);
        y2 = ref_canvas.get_pos_y_by_price(price2);

    }

    public virtual void render(Cairo.Context ctext){

        update_data();

        ctext.set_dash ({}, 0);
        ctext.set_line_width (2);
        ctext.set_source_rgba (_r (13), _g (82), _b (191), 1);
        ctext.move_to (x1, y1);
        ctext.line_to (x2, y2);
        ctext.stroke ();

    }

    public void set_x1(DateTime d1){
        date1 = d1;   
    }

    public void set_x2(DateTime d2){
        date2 = d2;
    }

    public void set_y1(double price){
        price1 = price;
    }

    public void set_y2(double price){
        price2 = price;
    }

    public int? get_x1(){
        return x1;
    }

    public int? get_x2(){
        return x2;
    }
}