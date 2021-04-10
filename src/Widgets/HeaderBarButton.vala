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
 * along with TradeSim. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Horacio Daniel Ros <horaciodrs@gmail.com>
 */

public class TradeSim.Widgets.HeaderBarButton : Gtk.Grid {

    public weak TradeSim.MainWindow mainWindow;
    public Gtk.Button button;
    public Gtk.Label label_btn;
    public TradeSim.Widgets.ButtonImage image;

    private string setted_icon_name;
    public string icon_name;
    public string alternative_icon_name;

    public HeaderBarButton (TradeSim.MainWindow window, string _icon_name, string name, string[] ? accels = null) {

        mainWindow = window;

        icon_name = _icon_name;
        setted_icon_name = icon_name;

        label_btn = new Gtk.Label (name);
        label_btn.get_style_context ().add_class ("headerbar-label");

        button = new Gtk.Button ();
        button.can_focus = false;
        button.halign = Gtk.Align.CENTER;
        button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        button.tooltip_markup = Granite.markup_accel_tooltip (accels, name);

        image = new ButtonImage (icon_name);
        button.add (image);

        attach (button, 0, 0, 1, 1);
        attach (label_btn, 0, 1, 1, 1);

    }

    public void set_alternative_icon_name (string _name) {
        alternative_icon_name = _name;
    }

    public void change_icon (string icon_name) {

        foreach (var item in button.get_children ()) {

            if (item.get_type () == typeof (ButtonImage)) {

                ((ButtonImage) item).change_icon (icon_name);

                return;
            }
        }

    }

    public void change_alternative_icon () {

        foreach (var item in button.get_children ()) {

            if (item.get_type () == typeof (ButtonImage)) {

                string new_icon_name = "";
                               
                if (setted_icon_name == icon_name){
                    new_icon_name = alternative_icon_name;
                }else {
                    new_icon_name = icon_name;
                }

                ((ButtonImage) item).change_icon (new_icon_name);
                
                setted_icon_name = new_icon_name;

                return;
            }
        }

    }

    public void set_primary_icon () {

        foreach (var item in button.get_children ()) {

            if (item.get_type () == typeof (ButtonImage)) {

                ((ButtonImage) item).change_icon (icon_name);
                
                setted_icon_name = icon_name;

                return;
            }
        }

    }

    public void set_alternative_icon () {

        foreach (var item in button.get_children ()) {

            if (item.get_type () == typeof (ButtonImage)) {

                ((ButtonImage) item).change_icon (alternative_icon_name);
                
                setted_icon_name = alternative_icon_name;

                return;
            }
        }

    }

}
