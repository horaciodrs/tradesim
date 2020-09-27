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

public class TradeSim.Layouts.HeaderBar : Gtk.HeaderBar {

    public weak TradeSim.MainWindow main_window { get; construct; }

    public TradeSim.Widgets.HeaderBarButton new_button;
    public TradeSim.Widgets.HeaderBarButton open;
    public TradeSim.Widgets.HeaderBarButton save;

    public TradeSim.Widgets.ZoomButton zoom;

    public TradeSim.Widgets.HeaderBarButton play;
    public TradeSim.Widgets.HeaderBarButton forward;
    public TradeSim.Widgets.HeaderBarButton backward;

    public TradeSim.Widgets.HeaderBarButton buy;
    public TradeSim.Widgets.HeaderBarButton sell;
    public TradeSim.Widgets.MenuButton insert;
    public TradeSim.Widgets.HeaderBarButton reporte;
    public TradeSim.Widgets.HeaderBarButton preferencias;

    public TradeSim.Widgets.TimeButton time_button;

    public HeaderBar (TradeSim.MainWindow window) {
        Object (
            main_window: window
            );
    }

    construct {

        set_show_close_button (true);
        title = "TradeSim";
        subtitle = "Simulación sin nombre";

        new_button = new TradeSim.Widgets.HeaderBarButton (main_window, "document-new", "Nuevo", { "<Ctrl>p" });
        open = new TradeSim.Widgets.HeaderBarButton (main_window, "document-open", "Abrir", { "<Ctrl>p" });
        save = new TradeSim.Widgets.HeaderBarButton (main_window, "document-save", "Guardar", { "<Ctrl>p" });

        zoom = new TradeSim.Widgets.ZoomButton (main_window);

        backward = new TradeSim.Widgets.HeaderBarButton (main_window, "media-seek-backward-symbolic", "", { "<Ctrl>p" });
        play = new TradeSim.Widgets.HeaderBarButton (main_window, "media-playback-start", "Play", { "<Ctrl>p" });
        forward = new TradeSim.Widgets.HeaderBarButton (main_window, "media-seek-forward-symbolic", "", { "<Ctrl>p" });
        buy = new TradeSim.Widgets.HeaderBarButton (main_window, "go-up", "Comprar", { "<Ctrl>p" });
        sell = new TradeSim.Widgets.HeaderBarButton (main_window, "go-down", "Vender", { "<Ctrl>p" });
        insert = new TradeSim.Widgets.MenuButton ("insert-object", "Insertar", { "<Ctrl>p" });
        reporte = new TradeSim.Widgets.HeaderBarButton (main_window, "x-office-presentation", "Reporte", { "<Ctrl>p" });
        preferencias = new TradeSim.Widgets.HeaderBarButton (main_window, "open-menu", "Settings", { "<Ctrl>p" });

        time_button = new TradeSim.Widgets.TimeButton (main_window);

        var insert_popover = get_insert_menu ();
        insert.button.popover = insert_popover;
        insert.sensitive = true;

        play.button.clicked.connect (() => {

            if (play.label_btn.get_text () == "Play") {
                play.change_icon ("media-playback-pause");
                play.label_btn.set_text ("Stop");
            } else {
                play.change_icon ("media-playback-start");
                play.label_btn.set_text ("Play");
            }

            main_window.main_layout.current_canvas.simulate ();

        });

        forward.button.clicked.connect (() => {

            string new_label = main_window.main_layout.current_canvas.simulate_fast ();

            play.label_btn.set_text (new_label);

        });

        backward.button.clicked.connect (() => {

            string new_label = main_window.main_layout.current_canvas.simulate_slow ();

            play.label_btn.set_text (new_label);

        });

        preferencias.button.clicked.connect (e => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.stop_simulation ();
            }

            main_window.open_dialog_preferences ();
        });

        new_button.button.clicked.connect (() => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.stop_simulation ();
            }

            main_window.main_layout.add_canvas ("", "", "");

        });

        buy.button.clicked.connect(e => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.stop_simulation ();
            }
            
            main_window.open_dialog_operations(TradeSim.Objects.OperationItem.Type.BUY);

        });

        sell.button.clicked.connect(e => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.stop_simulation ();
            }

            main_window.open_dialog_operations(TradeSim.Objects.OperationItem.Type.SELL);
        });

        pack_start (new_button);
        pack_start (open);
        pack_start (save);

        pack_start (new Gtk.Separator (Gtk.Orientation.VERTICAL));

        pack_start (zoom);
        pack_start (time_button);

        pack_start (new Gtk.Separator (Gtk.Orientation.VERTICAL));

        pack_start (backward);
        pack_start (play);
        pack_start (forward);

        pack_start (new Gtk.Separator (Gtk.Orientation.VERTICAL));

        pack_end (preferencias);
        pack_end (reporte);
        pack_end (new Gtk.Separator (Gtk.Orientation.VERTICAL));
        pack_end (insert);
        pack_end (new Gtk.Separator (Gtk.Orientation.VERTICAL));
        pack_end (sell);
        pack_end (buy);
        pack_end (new Gtk.Separator (Gtk.Orientation.VERTICAL));

    }

    private Gtk.PopoverMenu get_insert_menu () {

        var grid = new Gtk.Grid ();
        grid.margin_top = 6;
        grid.margin_bottom = 3;
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.width_request = 240;
        grid.name = "main";

        var draw_line_button = create_model_button ("Line","shape-line-symbolic");
        var draw_hline_button = create_model_button ("Horizontal Line","shape-hline-symbolic");
        var draw_rect_button = create_model_button ("Rectangle","shape-rectangle-symbolic");
        var draw_fibo_button = create_model_button ("Fibonacci Retracement","shape-fibonacci-symbolic");

        draw_line_button.clicked.connect(e => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.start_user_draw_line();
            }

        });

        draw_fibo_button.clicked.connect(e => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.start_user_draw_fibo();
            }

        });

        draw_rect_button.clicked.connect(e => {

            var canvas = main_window.main_layout.current_canvas;

            if(canvas != null){
                canvas.start_user_draw_rectangle();
            }

        });

        var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        separator.margin_top = separator.margin_bottom = 3;

        var separator2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        separator2.margin_top = separator.margin_bottom = 3;

        var separator3 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        separator3.margin_top = separator.margin_bottom = 3;

        grid.add (draw_line_button);
        grid.add (separator);

        grid.add (draw_hline_button);
        grid.add (separator2);

        grid.add (draw_rect_button);
        grid.add (separator3);

        grid.add (draw_fibo_button);
        
        grid.show_all ();

        var popover = new Gtk.PopoverMenu ();
        popover.add (grid);
        popover.child_set_property (grid, "submenu", "main");

        return popover;

    }

    private Gtk.ModelButton create_model_button (string text, string? icon) {
        var button = new Gtk.ModelButton ();
        button.get_child ().destroy ();
        var label = new Granite.AccelLabel.from_action_name (text, "<Ctrl>J");

        if (icon != null) {
            var image = new Gtk.Image.from_icon_name (icon, Gtk.IconSize.MENU);
            image.margin_end = 6;
            label.attach_next_to (
                image,
                label.get_child_at (0, 0),
                Gtk.PositionType.LEFT
            );
        }

        button.add (label);

        return button;
    }

}
