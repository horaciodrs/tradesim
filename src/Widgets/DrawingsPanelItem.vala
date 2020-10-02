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

public class TradeSim.Widgets.DrawingsPanelItem : Gtk.EventBox {

    public weak TradeSim.MainWindow main_window;

    private int type;
    private bool hidden;
    private bool enabled;
    public string desc;
    private string ? css;
    private string icon_name;
    private Gdk.RGBA original_color;

    public Gtk.Grid main_grid;
    public Gtk.Label label_name;
    public Gtk.Image type_icon;
    public Gtk.Button visible_icon;
    public Gtk.Button sensitive_icon;
    public Gtk.Button trash_icon;
    public Gtk.ColorButton item_color;

    public DrawingsPanelItem (TradeSim.MainWindow _window, string _name, int _type, string ? _css = null,Gdk.RGBA ?  _color = null) {

        main_window = _window;

        desc = _name;
        type = _type;
        css = _css;

        if(_color == null){
            var default_color = new TradeSim.Utils.Color.default();
            original_color = default_color.get_rgba();
        }else{
            original_color = _color;
        }

        //enabled = true;
        hidden = false;

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

    public void set_class (string css) {
        main_grid.get_style_context ().add_class (css);
    }

    public void init () {

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);

        main_grid = new Gtk.Grid();
        type_icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.MENU);
        visible_icon = new Gtk.Button.from_icon_name ("draw-item-visible-symbolic", Gtk.IconSize.MENU);
        sensitive_icon = new Gtk.Button.from_icon_name ("draw-item-sensitive-symbolic", Gtk.IconSize.MENU);
        trash_icon = new Gtk.Button.from_icon_name ("draw-item-trash-symbolic", Gtk.IconSize.MENU);
        label_name = new Gtk.Label (desc);
        item_color = new Gtk.ColorButton.with_rgba (original_color);

        type_icon.hexpand = false;
        type_icon.margin = 4;

        visible_icon.hexpand = false;
        visible_icon.halign = Gtk.Align.START;
        visible_icon.margin = 4;
        visible_icon.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        visible_icon.clicked.connect(()=>{

            var dm = main_window.main_layout.current_canvas.draw_manager;
            bool enabled = dm.get_draw_enabled(desc, type);

            if(!enabled){
                return;
            }

            bool visible = dm.get_draw_visible(desc, type);

            dm.set_draw_visible(desc, type, !visible);
            string imagen_name = "draw-item-visible-no-symbolic";

            if(!visible){
                imagen_name = "draw-item-visible-symbolic";
            }

            var imagen = new Gtk.Image.from_icon_name(imagen_name, Gtk.IconSize.MENU);

            visible_icon.set_image(imagen);

        });

        //visible_icon.

        sensitive_icon.hexpand = false;
        sensitive_icon.halign = Gtk.Align.START;
        sensitive_icon.margin = 4;
        sensitive_icon.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        sensitive_icon.clicked.connect(()=>{

            var dm = main_window.main_layout.current_canvas.draw_manager;

            bool enabled = dm.get_draw_enabled(desc, type);

            dm.set_draw_enabled(desc, type, !enabled);
            string imagen_name = "draw-item-sensitive-no-symbolic";

            item_color.set_sensitive(false);

            if(!enabled){
                imagen_name = "draw-item-sensitive-symbolic";
                item_color.set_sensitive(true);
            }

            var imagen = new Gtk.Image.from_icon_name(imagen_name, Gtk.IconSize.MENU);

            sensitive_icon.set_image(imagen);
            
        });

        trash_icon.hexpand = false;
        trash_icon.halign = Gtk.Align.START;
        trash_icon.margin = 4;
        trash_icon.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        trash_icon.clicked.connect(()=>{

            if(!confirm("Are you sure you want to delete this object?", main_window, Gtk.MessageType.QUESTION)){
                return;
            }

            var dm = main_window.main_layout.current_canvas.draw_manager;
            var target = main_window.main_layout.drawings_panel;
            bool enabled = dm.get_draw_enabled(desc, type);

            if(!enabled){
                return;
            }

            target.delete_object(desc, type);
            
        });

        item_color.hexpand = false;
        item_color.margin = 4;

        item_color.color_set.connect(() =>{

            var dm = main_window.main_layout.current_canvas.draw_manager;
            var target = main_window.main_layout.current_canvas.draw_manager;
            bool enabled = dm.get_draw_enabled(desc, type);

            if(!enabled){
                return;
            }

            target.set_draw_color(desc, type, item_color.get_rgba());

        });

        label_name.hexpand = true;
        label_name.halign = Gtk.Align.START;

        if (css != null) {
            main_grid.get_style_context ().add_class (css);
        }

        main_grid.hexpand = true;
        main_grid.column_homogeneous = false;
        main_grid.row_spacing = 0;
        main_grid.column_spacing = 4;

        var lbl_test = new Gtk.Label (" ");
        lbl_test.hexpand = true;

        main_grid.attach (type_icon, 0, 0, 1);
        main_grid.attach (label_name, 1, 0, 4);
        main_grid.attach (item_color, 5, 0);

        main_grid.attach (sensitive_icon, 1, 1);
        main_grid.attach (visible_icon, 2, 1, 1);
        main_grid.attach (trash_icon, 3, 1, 1);
        main_grid.attach (lbl_test, 4, 1);

        main_grid.set_sensitive(true);

        motion_notify_event.connect (on_mouse_over);
        leave_notify_event.connect (on_mouse_out);
        button_press_event.connect(on_mouse_click);

        add(main_grid);

    }

    public void refresh(string _new_desc){

        var draw_manager = main_window.main_layout.current_canvas.draw_manager;

        desc = _new_desc;

        var object_color = draw_manager.get_draw_color(desc, type);

        label_name.set_text(desc);
        item_color.set_rgba(object_color.get_rgba());

    }

    public bool on_mouse_click(Gdk.EventButton event){

        if(event.type == Gdk.EventType.2BUTTON_PRESS){

            var dm = main_window.main_layout.current_canvas.draw_manager;
            bool enabled = dm.get_draw_enabled(desc, type);

            if(!enabled){
                return true;
            }
            
            var edit_object_dialog = new TradeSim.Dialogs.DrawEditDialog (main_window, this, desc, type);

            edit_object_dialog.show_all ();
            edit_object_dialog.present ();

        }

        return true;

    }

    public bool on_mouse_over(Gdk.EventMotion event){

        main_grid.get_style_context().remove_class(css);
        main_grid.get_style_context ().add_class (css + "-mouse-over");

        return true;
        
    }

    public bool on_mouse_out(Gdk.EventCrossing event){

        main_grid.get_style_context().remove_class(css + "-mouse-over");
        main_grid.get_style_context ().add_class (css);

        return true;
    }

}