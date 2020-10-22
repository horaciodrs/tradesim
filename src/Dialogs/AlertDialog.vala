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

public class TradeSim.Dialogs.AlertDialog : Gtk.Dialog {
    public weak TradeSim.MainWindow main_window { get; construct; }

    private Gtk.ScrolledWindow scroll_licence;

    public Gtk.Grid grid_about_us;

    public AlertDialog (TradeSim.MainWindow window) {

        Object (
            main_window: window,
            border_width: 6,
            deletable: false,
            resizable: false,
            modal: true,
            title: _ ("Licence Agreement")
        );

        delete_event.connect ((e) => {
            return true; //Evita que se cierre el dialogo sin aceptar o rechazar la licencia.
        });

        scroll_licence = new Gtk.ScrolledWindow (null, null);
        scroll_licence.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        grid_about_us = get_about_box ();

        transient_for = main_window;

        get_content_area ().add (grid_about_us);

    }

    private Gtk.Grid get_about_box () {

        var grid = new Gtk.Grid ();
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.halign = Gtk.Align.CENTER;

        var app_icon = new Gtk.Image ();
        app_icon.gicon = new ThemedIcon ("com.github.horaciodrs.TradeSim");
        app_icon.pixel_size = 64;
        app_icon.margin_top = 12;

        var app_name = new Gtk.Label ("TradeSim");
        app_name.get_style_context ().add_class ("h2");
        app_name.margin_top = 6;

        var app_description = new Gtk.Label (_ ("The Linux Trading Simulator"));
        app_description.get_style_context ().add_class ("h3");

        var lbl_titulo = new Gtk.Label (_ ("Licence Agreement"));
        lbl_titulo.get_style_context ().add_class ("h2");
        lbl_titulo.margin_top = 15;
        lbl_titulo.margin_bottom = 10;

        var app_version = new Gtk.Label (TradeSim.Data.APP_VERSION);
        app_version.get_style_context ().add_class ("dim-label");
        app_version.selectable = true;

        var disclaimer = new Gtk.Label (_ ("Trading currencies with leverage carries a high level of risk and may not be suitable for all types of investors.\n\nThe high degree of market leverage can play both for and against the investor. We remember that there is the possibility of losing part or all of the initial investment so you should not invest money that you cannot afford to lose.\n\nTradeSim is an application created in order to test strategies without risk for the user in a simulated market. The results obtained in TradeSim should in no case be taken as advice, or recommendation for investment.\n\nThe creator of this application will not be held responsible for the losses suffered by the investor. The investor will be solely responsible for his actions in the negotiation in the real market."));

        disclaimer.justify = Gtk.Justification.LEFT;
        //disclaimer.get_style_context ().add_class ("warning-message");
        disclaimer.max_width_chars = 60;
        disclaimer.wrap = true;
        disclaimer.margin_top = disclaimer.margin_bottom = 12;

        scroll_licence.add (disclaimer);
        scroll_licence.set_size_request(400, 200);
        scroll_licence.set_vexpand (true);
        scroll_licence.set_hexpand (true);
        scroll_licence.get_style_context ().add_class ("scrolled-window-data");

        grid.attach (app_icon, 0, 0);
        grid.attach (app_name, 0, 1);
        grid.attach (app_description, 0, 2);
        grid.attach (app_version, 0, 3);
        grid.attach (lbl_titulo, 0, 4);
        grid.attach (scroll_licence, 0, 5);


        // Button grid at the bottom of the About page.
        var button_grid = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_grid.halign = Gtk.Align.CENTER;
        button_grid.spacing = 6;

        var aceptar_button = new Gtk.Button.with_label (_ ("Ok"));
        aceptar_button.clicked.connect (() => {
            //acepto el acuerdo...
            main_window.settings.set_boolean ("tradesim-licence-agreement", true);
            destroy ();
            //
        });

        var cancel_button = new Gtk.Button.with_label (_ ("Cancel"));
        cancel_button.clicked.connect (() => {
            //no acepto...
            main_window.settings.set_boolean ("tradesim-licence-agreement", false);
            main_window.destroy();
        });

        button_grid.add (aceptar_button);
        button_grid.add (cancel_button);

        grid.attach (button_grid, 0, 6);

        return grid;
    }

    private class SettingsHeader : Gtk.Label {
        public SettingsHeader (string text) {
            label = text;
            get_style_context ().add_class ("h4");
            halign = Gtk.Align.START;
        }

    }

    private class SettingsLabel : Gtk.Label {
        public SettingsLabel (string text) {
            label = text;
            halign = Gtk.Align.END;
        }

    }

    private class SettingsSwitch : Gtk.Switch {
        public SettingsSwitch (string setting) {
            halign = Gtk.Align.START;
            // settings.bind (setting, this, "active", SettingsBindFlags.DEFAULT);
        }

    }
}
