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

public class TradeSim.Dialogs.DrawEditDialog : Gtk.Dialog {

    public weak TradeSim.MainWindow main_window { get; construct; }
    public weak TradeSim.Widgets.DrawingsPanelItem item_to_update { get; construct; }

    private string object_id;
    private int type;
    private int selected_thicness;

    public Gtk.Button acept_button;
    public Gtk.Button cancel_button;

    private Gtk.Label header_title;

    private Gtk.Label label_name;
    private Gtk.Label label_color;
    private Gtk.Label label_alpha;
    private Gtk.Label label_thickness;

    private Gtk.Entry txt_name;
    private Gtk.ColorButton button_color;
    private Gtk.Button button_thickness1;
    private Gtk.Button button_thickness2;
    private Gtk.Button button_thickness3;
    private Gtk.Button button_thickness4;
    private Gtk.Scale scale_alpha;


    enum Action {
        OK,
        CANCEL
    }

    public DrawEditDialog (TradeSim.MainWindow ? parent, TradeSim.Widgets.DrawingsPanelItem _item_to_update, string _id, int _type) {
        Object (
            border_width: 5,
            deletable: false,
            resizable: true,
            title: "Edit Object",
            transient_for: parent,
            main_window: parent,
            item_to_update: _item_to_update
            );

        object_id = _id;
        type = _type;

        init ();

    }

    public void init () {

        build_content ();

        response.connect (on_response);

    }

    private void build_content () {

        var draw_manager = main_window.main_layout.current_canvas.draw_manager;

        var body = get_content_area ();

        var header_grid = new Gtk.Grid ();
        header_grid.margin_start = 30;
        header_grid.margin_end = 30;
        header_grid.margin_bottom = 10;

        var image = new Gtk.Image.from_icon_name ("document-page-setup", Gtk.IconSize.DIALOG);
        image.margin_end = 10;

        header_title = new Gtk.Label ("Edit Object");
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_title.halign = Gtk.Align.START;
        header_title.ellipsize = Pango.EllipsizeMode.END;
        header_title.margin_end = 10;
        header_title.set_line_wrap (true);
        header_title.hexpand = true;

        header_grid.attach (image, 0, 0, 1, 2);
        header_grid.attach (header_title, 1, 0, 1, 2);

        body.add (header_grid);

        var form_grid = new Gtk.Grid ();
        form_grid.margin = 30;
        form_grid.row_spacing = 12;
        form_grid.column_spacing = 20;

        label_name = new Gtk.Label ("Object Name:");
        txt_name = new Gtk.Entry ();
        txt_name.set_text (object_id);
        label_name.halign = Gtk.Align.END;

        form_grid.attach (label_name, 0, 0);
        form_grid.attach (txt_name, 1, 0);

        // Color.

        Gdk.RGBA aux_color = draw_manager.get_draw_color (object_id, type).get_rgba ();

        label_color = new Gtk.Label ("Color:");
        button_color = new Gtk.ColorButton.with_rgba (aux_color);
        label_color.halign = Gtk.Align.END;

        form_grid.attach (label_color, 0, 1);
        form_grid.attach (button_color, 1, 1);

        // Alpha

        label_alpha = new Gtk.Label ("Opacity:");
        scale_alpha = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 0.1);
        label_alpha.halign = Gtk.Align.END;

        scale_alpha.set_value (aux_color.alpha * 100);

        scale_alpha.value_changed.connect ((a) => {

            var color_aux = button_color.get_rgba ();

            color_aux.alpha = scale_alpha.get_value () / 100.00;

            button_color.set_rgba (color_aux);

        });

        form_grid.attach (label_alpha, 0, 2);
        form_grid.attach (scale_alpha, 1, 2);

        // Thickness

        label_thickness = new Gtk.Label ("Thickness:");
        label_thickness.halign = Gtk.Align.END;

        form_grid.attach (label_thickness, 0, 3);
        form_grid.attach (get_button_thickness (), 1, 3);

        body.add (form_grid);

        acept_button = new Gtk.Button.with_label ("Ok");
        acept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        cancel_button = new Gtk.Button.with_label ("Cancel");

        add_action_widget (acept_button, Action.OK);
        add_action_widget (cancel_button, Action.CANCEL);

    }

    private Gtk.Grid get_button_thickness () {

        var draw_manager = main_window.main_layout.current_canvas.draw_manager;

        Gtk.Grid grilla = new Gtk.Grid ();

        grilla.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        grilla.get_style_context ().add_class ("linked-flat");

        grilla.hexpand = true;

        button_thickness1 = new Gtk.Button.from_icon_name ("shape-thickness1-symbolic");
        button_thickness2 = new Gtk.Button.from_icon_name ("shape-thickness2-symbolic");
        button_thickness3 = new Gtk.Button.from_icon_name ("shape-thickness3-symbolic");
        button_thickness4 = new Gtk.Button.from_icon_name ("shape-thickness4-symbolic");

        button_thickness1.hexpand = true;
        button_thickness2.hexpand = true;
        button_thickness3.hexpand = true;
        button_thickness4.hexpand = true;

        selected_thicness = draw_manager.get_draw_thicness (object_id, type);

        // print("type:" + type.to_string() + "\n");
        // print(selected_thicness.to_string() + "\n");

        if (selected_thicness == TradeSim.Services.Drawings.Thickness.VERY_FINE) {
            button_thickness1.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness2.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness3.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness4.get_style_context ().remove_class ("btn-thicness-selected");
        } else if (selected_thicness == TradeSim.Services.Drawings.Thickness.FINE) {
            button_thickness2.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness1.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness3.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness4.get_style_context ().remove_class ("btn-thicness-selected");
        } else if (selected_thicness == TradeSim.Services.Drawings.Thickness.THICK) {
            button_thickness3.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness2.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness1.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness4.get_style_context ().remove_class ("btn-thicness-selected");
        } else if (selected_thicness == TradeSim.Services.Drawings.Thickness.VERY_THICK) {
            button_thickness4.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness2.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness3.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness1.get_style_context ().remove_class ("btn-thicness-selected");
        }

        grilla.attach (button_thickness1, 0, 0);
        grilla.attach (button_thickness2, 1, 0);
        grilla.attach (button_thickness3, 2, 0);
        grilla.attach (button_thickness4, 3, 0);



        button_thickness1.clicked.connect (() => {
            selected_thicness = TradeSim.Services.Drawings.Thickness.VERY_FINE;
            button_thickness1.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness2.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness3.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness4.get_style_context ().remove_class ("btn-thicness-selected");
        });

        button_thickness2.clicked.connect (() => {
            selected_thicness = TradeSim.Services.Drawings.Thickness.FINE;
            button_thickness2.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness1.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness3.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness4.get_style_context ().remove_class ("btn-thicness-selected");
        });

        button_thickness3.clicked.connect (() => {
            selected_thicness = TradeSim.Services.Drawings.Thickness.THICK;
            button_thickness3.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness2.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness1.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness4.get_style_context ().remove_class ("btn-thicness-selected");
        });

        button_thickness4.clicked.connect (() => {
            selected_thicness = TradeSim.Services.Drawings.Thickness.VERY_THICK;
            button_thickness4.get_style_context ().add_class ("btn-thicness-selected");
            button_thickness2.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness3.get_style_context ().remove_class ("btn-thicness-selected");
            button_thickness1.get_style_context ().remove_class ("btn-thicness-selected");
        });

        return grilla;

    }

    private string validate_data () {

        if (txt_name.get_text ().length < 1) {
            return "Please enter the object name";
        }

        return "";
    }

    private void on_response (Gtk.Dialog source, int response_id) {

        if (response_id == Action.OK) {

            string msg = validate_data ();

            if (msg.length > 0) {

                var dialog = new Gtk.MessageDialog (this, 0, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK_CANCEL, msg);
                dialog.run ();
                dialog.destroy ();
                return;

            }

        }

        switch (response_id) {
        case Action.OK:

            TradeSim.Dialogs.DrawEditDialog dialogo = ((TradeSim.Dialogs.DrawEditDialog)source);

            var objetivo = dialogo.main_window.main_layout;
            var target = objetivo.current_canvas.draw_manager;

            target.set_draw_color (object_id, type, button_color.get_rgba ());
            target.set_draw_thickness (object_id, type, selected_thicness);
            target.set_draw_name (object_id, type, txt_name.get_text ());
            target.set_draw_alpha (object_id, type, scale_alpha.get_value () / 100.00);

            dialogo.item_to_update.refresh (txt_name.get_text ());

            destroy ();

            break;

        case Action.CANCEL:
            destroy ();
            break;
        }
    }

}