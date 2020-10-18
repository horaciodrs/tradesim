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


public class TradeSim.Application : Gtk.Application {

    TradeSim.MainWindow WindowTradeSim;

    public Application () {
        Object (
            application_id: "com.github.horaciodrs.tradesim",
            flags : ApplicationFlags.HANDLES_OPEN
            );

            //GLib.ApplicationFlags.HANDLES_COMMAND_LINE |

    }

    /*protected override int command_line (GLib.ApplicationCommandLine command_line){

        hold ();

        string[] args = command_line.get_arguments ();

        for(int i=0; i < args.length; i++){
            print("argumento:" + args[i] + "\n");
        }

        release ();
        //command_line.

        return 0;
    }*/

    public override void open (GLib.File[] open_files, string hint) {

        activate ();

        foreach (var file in open_files) {
            string file_path = file.get_path();
            WindowTradeSim.main_layout.new_chart_from_file (file_path);
        }

    }

    protected override void activate () {

        WindowTradeSim = new TradeSim.MainWindow (this);

        Gtk.Settings.get_default ().set_property ("gtk-icon-theme-name", "elementary");
        Gtk.Settings.get_default ().set_property ("gtk-theme-name", "elementary");

        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/horaciodrs/tradesim");

        add_window (WindowTradeSim);

    }

}
