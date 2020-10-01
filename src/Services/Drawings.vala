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

    public enum Type {
        LINE
        , HLINE
        , RECTANGLE
        , FIBONACCI
        , OPERATION_INFO
    }

    public bool drawing_mode; // Indica si se esta dibujando algo.

    public Array<TradeSim.Drawings.Line> lines;
    public Array<TradeSim.Drawings.Fibonacci> fibonacci;
    public Array<TradeSim.Drawings.Rectangle> rectangles;
    public Array<TradeSim.Drawings.HLine> hlines;
    public Array<TradeSim.Drawings.OperationInfo> operations;

    public Drawings (TradeSim.Widgets.Canvas _canvas) {

        ref_canvas = _canvas;

        lines = new Array<TradeSim.Drawings.Line> ();
        fibonacci = new Array<TradeSim.Drawings.Fibonacci> ();
        rectangles = new Array<TradeSim.Drawings.Rectangle> ();
        hlines = new Array<TradeSim.Drawings.HLine> ();
        operations = new Array<TradeSim.Drawings.OperationInfo> ();

    }

    public void show_all (Cairo.Context ctext) {

        for (int i = 0 ; i < lines.length ; i++) {
            lines.index (i).render (ctext);
        }

        for (int z = 0 ; z < fibonacci.length ; z++) {
            fibonacci.index (z).render (ctext);
        }

        for (int z = 0 ; z < rectangles.length ; z++) {
            rectangles.index (z).render (ctext);
        }

        for (int z = 0 ; z < hlines.length ; z++) {
            hlines.index (z).render (ctext);
        }

        for (int z = 0 ; z < operations.length ; z++) {
            operations.index (z).render (ctext);
        }

    }

    public void draw_operation (TradeSim.Objects.OperationItem _op) {

        //Esta función debe ser llamada cada vez que se crea o modifica
        //una operación.

        string _id = "operation" + _op.id.to_string ();
        var new_operation = operation_exists (_id);
        bool is_new_operation = false;

        if (new_operation == null) {
            new_operation = new TradeSim.Drawings.OperationInfo (ref_canvas, _id);
            is_new_operation = true;
        }

        new_operation.set_data (_op);

        if (is_new_operation) {
            operations.append_val (new_operation);
        }

    }

    public void draw_hline (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_hline = hline_exists (_id);
        bool is_new_hline = false;

        if (new_hline == null) {
            new_hline = new TradeSim.Drawings.HLine (ref_canvas, _id);
            is_new_hline = true;
        }

        if (new_hline.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_hline.set_x1 (d1);
            new_hline.set_x2 (d1);
            new_hline.set_y1 (p1);
            new_hline.set_y2 (p1);
        } else {
            new_hline.set_x2 (d2);
            new_hline.set_y2 (p2);
        }

        if (is_new_hline) {
            hlines.append_val (new_hline);
        }

    }

    public void draw_rectangle (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_rectangle = rectangle_exists (_id);
        bool is_new_rectangle = false;

        if (new_rectangle == null) {
            new_rectangle = new TradeSim.Drawings.Rectangle (ref_canvas, _id);
            is_new_rectangle = true;
        }

        if (new_rectangle.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_rectangle.set_x1 (d1);
            new_rectangle.set_x2 (d1);
            new_rectangle.set_y1 (p1);
            new_rectangle.set_y2 (p1);
        } else {
            new_rectangle.set_x2 (d2);
            new_rectangle.set_y2 (p2);
        }

        if (is_new_rectangle) {
            rectangles.append_val (new_rectangle);
        }

    }

    public void draw_fibonacci (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_fibo = fibo_exists (_id);
        bool is_new_fibo = false;

        if (new_fibo == null) {
            new_fibo = new TradeSim.Drawings.Fibonacci (ref_canvas, _id);
            is_new_fibo = true;
        }



        if (new_fibo.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_fibo.set_x1 (d1);
            new_fibo.set_x2 (d1);
            new_fibo.set_y1 (p1);
            new_fibo.set_y2 (p1);
        } else {
            new_fibo.set_x2 (d2);
            new_fibo.set_y2 (p2);
        }

        if (is_new_fibo) {
            fibonacci.append_val (new_fibo);
        }

    }

    public void draw_line (string _id, DateTime d1, double p1, DateTime d2, double p2) {

        var new_line = line_exists (_id);
        bool is_new_line = false;

        if (new_line == null) {
            new_line = new TradeSim.Drawings.Line (ref_canvas, _id);
            is_new_line = true;
        }

        if (new_line.get_x1 () == null) {
            // Si no hay x1 es porque se esta creando la linea
            // por primer vez.
            new_line.set_x1 (d1);
            new_line.set_x2 (d1);
            new_line.set_y1 (p1);
            new_line.set_y2 (p1);
        } else {
            new_line.set_x2 (d2);
            new_line.set_y2 (p2);
        }

        if (is_new_line) {
            lines.append_val (new_line);
        }

    }

    public TradeSim.Drawings.Line ? line_exists (string _id) {

        for (int i = 0 ; i < lines.length ; i++) {
            if (lines.index (i).id == _id) {
                return lines.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.Fibonacci ? fibo_exists (string _id) {

        for (int i = 0 ; i < fibonacci.length ; i++) {
            if (fibonacci.index (i).id == _id) {
                return fibonacci.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.Rectangle ? rectangle_exists (string _id) {

        for (int i = 0 ; i < rectangles.length ; i++) {
            if (rectangles.index (i).id == _id) {
                return rectangles.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.HLine ? hline_exists (string _id) {

        for (int i = 0 ; i < hlines.length ; i++) {
            if (hlines.index (i).id == _id) {
                return hlines.index (i);
            }
        }

        return null;

    }

    public TradeSim.Drawings.OperationInfo ? operation_exists (string _id) {

        for (int i = 0 ; i < operations.length ; i++) {
            if (operations.index (i).id == _id) {
                return operations.index (i);
            }
        }

        return null;

    }

    public void set_draw_color(string _id, int _type, Gdk.RGBA _c){

        var _color = new TradeSim.Utils.Color.with_rgba(_c);

        //print("red:" + _color.red.to_string() + " green:" + _color.green.to_string() + " blue:" + _color.blue.to_string() + "\n");

        if(_type==TradeSim.Services.Drawings.Type.LINE){
            for(int i=0; i< lines.length; i++){
                if(lines.index(i).id == _id){
                    lines.index(i).set_color(_color);
                    break;
                }
            }
        }else if(_type==TradeSim.Services.Drawings.Type.HLINE){
            for(int i=0; i< hlines.length; i++){
                if(hlines.index(i).id == _id){
                    hlines.index(i).set_color(_color);
                    break;
                }
            }
        }else if(_type==TradeSim.Services.Drawings.Type.FIBONACCI){
            for(int i=0; i< fibonacci.length; i++){
                if(fibonacci.index(i).id == _id){
                    fibonacci.index(i).set_color(_color);
                    break;
                }
            }
        }else if(_type==TradeSim.Services.Drawings.Type.RECTANGLE){
            for(int i=0; i< rectangles.length; i++){
                if(rectangles.index(i).id == _id){
                    rectangles.index(i).set_color(_color);
                    break;
                }
            }
        }
    }
}