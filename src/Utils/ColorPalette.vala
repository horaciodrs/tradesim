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

public class TradeSim.Utils.ColorPalette {

    public TradeSim.Utils.Color canvas_bg;
    public TradeSim.Utils.Color canvas_border;
    public TradeSim.Utils.Color canvas_horizontal_line;
    public TradeSim.Utils.Color canvas_cross_line;
    public TradeSim.Utils.Color canvas_cross_line_price_label_bg;
    public TradeSim.Utils.Color canvas_cross_line_price_label_fg;
    public TradeSim.Utils.Color canvas_vertical_scale_bg;
    public TradeSim.Utils.Color canvas_horizontal_scale_bg;
    public TradeSim.Utils.Color canvas_vertical_scale_label_bg;
    public TradeSim.Utils.Color canvas_vertical_scale_label_fg;
    public TradeSim.Utils.Color canvas_vertical_scale_price_label_bg;
    public TradeSim.Utils.Color canvas_vertical_scale_price_label_fg;
    public TradeSim.Utils.Color canvas_horizontal_scale_label_bg;
    public TradeSim.Utils.Color canvas_horizontal_scale_label_fg;
    public TradeSim.Utils.Color canvas_horizontal_scroll_bg;

    public TradeSim.Utils.Color candle_up;
    public TradeSim.Utils.Color candle_down;
    public TradeSim.Utils.Color candle_border;

    public ColorPalette(){
        //set_light_mode ();
        set_dark_mode ();
    }

    public void  set_light_mode(){

        canvas_bg = new TradeSim.Utils.Color(255, 243, 148);
        canvas_horizontal_scroll_bg = new TradeSim.Utils.Color(212, 142, 21);
        canvas_horizontal_scale_label_bg = new TradeSim.Utils.Color(173, 95, 0);
        canvas_horizontal_scale_label_fg = new TradeSim.Utils.Color(0, 0, 0);
        canvas_vertical_scale_label_bg = new TradeSim.Utils.Color(255, 255, 107);
        canvas_vertical_scale_label_fg = new TradeSim.Utils.Color(0, 0, 0);
        canvas_vertical_scale_price_label_bg = new TradeSim.Utils.Color(13, 82, 191); //Color del Precio de la ultima vela.
        canvas_vertical_scale_price_label_fg = new TradeSim.Utils.Color(255, 255, 255);
        canvas_cross_line_price_label_bg = new TradeSim.Utils.Color(173, 95, 0);
        canvas_cross_line_price_label_fg = new TradeSim.Utils.Color(255, 255, 255);
        canvas_border = new TradeSim.Utils.Color(212, 142, 21);
        canvas_vertical_scale_bg = new TradeSim.Utils.Color(255, 226, 107);
        canvas_cross_line = new TradeSim.Utils.Color(0, 0, 0);
        canvas_horizontal_scale_bg = new TradeSim.Utils.Color(255, 226, 107);
        candle_up = new TradeSim.Utils.Color(104, 183, 35);
        candle_down = new TradeSim.Utils.Color(192, 38, 46);
        candle_border = new TradeSim.Utils.Color(0, 0, 0);

    }

    public void set_dark_mode(){

        canvas_bg = new TradeSim.Utils.Color(40, 40, 40);
        canvas_horizontal_scroll_bg = new TradeSim.Utils.Color(50, 50, 50);
        canvas_horizontal_scale_label_bg = new TradeSim.Utils.Color(30, 30, 30);
        canvas_horizontal_scale_label_fg = new TradeSim.Utils.Color(128, 128, 128);
        canvas_vertical_scale_label_bg = new TradeSim.Utils.Color(30, 30, 30);
        canvas_vertical_scale_label_fg = new TradeSim.Utils.Color(128, 128, 128);
        canvas_vertical_scale_price_label_bg = new TradeSim.Utils.Color(13, 82, 191); //Color del Precio de la ultima vela.
        canvas_vertical_scale_price_label_fg = new TradeSim.Utils.Color(255, 255, 255);
        canvas_cross_line_price_label_bg = new TradeSim.Utils.Color(50, 50, 50);
        canvas_cross_line_price_label_fg = new TradeSim.Utils.Color(128, 128, 128);
        canvas_border = new TradeSim.Utils.Color(128, 128, 128);
        canvas_vertical_scale_bg = new TradeSim.Utils.Color(25, 25, 25);
        canvas_cross_line = new TradeSim.Utils.Color(128, 128, 128);
        canvas_horizontal_scale_bg = new TradeSim.Utils.Color(20, 20, 20);
        candle_up = new TradeSim.Utils.Color(38, 166, 154);
        candle_down = new TradeSim.Utils.Color(239, 83, 80);
        candle_border = new TradeSim.Utils.Color(128, 128, 128);

    }

}
