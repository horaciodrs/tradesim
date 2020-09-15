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
    public TradeSim.Widgets.HeaderBarButton insert;
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
        insert = new TradeSim.Widgets.HeaderBarButton (main_window, "insert-object", "Insertar", { "<Ctrl>p" });
        reporte = new TradeSim.Widgets.HeaderBarButton (main_window, "x-office-presentation", "Reporte", { "<Ctrl>p" });
        preferencias = new TradeSim.Widgets.HeaderBarButton (main_window, "open-menu", "Settings", { "<Ctrl>p" });

        time_button = new TradeSim.Widgets.TimeButton (main_window);


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
            main_window.open_dialog_preferences ();
        });

        new_button.button.clicked.connect (() => {

            main_window.main_layout.add_canvas ("", "", "");

        });

        buy.button.clicked.connect(e => {

            main_window.open_dialog_operations();

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

}
