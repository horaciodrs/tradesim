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

public class TradeSim.Layouts.Welcome : Granite.Widgets.Welcome {

    public weak TradeSim.MainWindow main_window { get; construct; }

    public enum WelcomeActions {
        CREATE_DOCUMENT
        , OPEN_DOCUMENT
        , FOLDER_DOWNLOAD
    }

    public Welcome (TradeSim.MainWindow _main_window) {
        Object (
            main_window: _main_window,
            title: "Welcome to TradeSim",
            subtitle: "Test your strategies on the Linux Trading Simulator."
            );
    }

    construct {
        valign = Gtk.Align.FILL;
        halign = Gtk.Align.FILL;
        vexpand = true;

        append ("document-new", "Create a New Simulation", "Try or develop new strategies for your trading.");
        append ("document-open", "Open a previous saved simulation", "Open a previous saved simulation");
        append ("folder-download", "Import Datasources", "Import quotes from internet");

        activated.connect (index => {
            switch (index) {
            case WelcomeActions.CREATE_DOCUMENT:
                main_window.main_layout.add_canvas("", "", "");
                break;
            case WelcomeActions.OPEN_DOCUMENT:
                print ("open saved document");
                break;
            case WelcomeActions.FOLDER_DOWNLOAD:
                main_window.open_dialog_preferences(main_window.SettingsActions.DATA_SOURCE);
                break;
            }
        });
    }

}
