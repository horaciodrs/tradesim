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

public class TradeSim.Widgets.DrawingsPanelItem : Gtk.Grid {

    private int type;
    private bool visible;
    private bool sensitive;
    private string name;
    private string css;
    private string icon_name;

    public Gtk.Label label_name;
    public Gtk.Image type_icon;
    public Gtk.Image visible_icon;
    public Gtk.Image sensitive_icon;
    public Gtk.ColorButton item_color;

    public DrawingsPanelItem (string _name, int _type, string _css) {

        name = _name;
        type = _type;
        css = _css;

        switch (type) {
        case TradeSim.Services.Drawings.Type.LINE:
            icon_name = "shape-line-symbolic";
            break;
        case TradeSim.Services.Drawings.Type.HLINE:
            icon_name = "shape-hline-symbolic";
            break;
        case TradeSim.Services.Drawings.Type.RECTANGLE:
            icon_name = "shape-rectangle-symbolic";
            break;
        case TradeSim.Services.Drawings.Type.FIBONACCI:
            icon_name = "shape-fibonacci-symbolic";
            break;
        }

        init ();

    }

    public void init () {



        type_icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.MENU);
        visible_icon = new Gtk.Image.from_icon_name ("draw-item-visible-symbolic", Gtk.IconSize.MENU);
        sensitive_icon = new Gtk.Image.from_icon_name ("draw-item-sensitive-symbolic", Gtk.IconSize.MENU);
        label_name = new Gtk.Label (name);
        item_color = new Gtk.ColorButton ();

        type_icon.hexpand = false;
        type_icon.margin = 4;

        visible_icon.hexpand = false;
        visible_icon.halign = Gtk.Align.START;
        visible_icon.margin = 4;

        sensitive_icon.hexpand = false;
        sensitive_icon.halign = Gtk.Align.START;
        sensitive_icon.margin = 4;

        item_color.hexpand = false;
        item_color.margin = 4;

        label_name.hexpand = true;
        label_name.halign = Gtk.Align.START;

        get_style_context ().add_class (css);

        hexpand = true;
        column_homogeneous = false;
        row_spacing = 0;
        column_spacing = 4;

        var lbl_test = new Gtk.Label (" ");
        lbl_test.hexpand = true;

        attach (type_icon, 0, 0, 1);
        attach (label_name, 1, 0, 3);
        attach (item_color, 4, 0);

        attach (sensitive_icon, 1, 1);
        attach (visible_icon, 2, 1, 1);
        attach (lbl_test, 3, 1);

    }

}