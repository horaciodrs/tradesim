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

/*

        meson build --prefix=/usr
        ninja

        uncrustify --no-backup -c uncrustify.cfg src/*.vala src/Drawings/*.vala src/Objects/*.vala src/Utils/*.vala src/Dialogs/*.vala src/Layouts/*.vala src/Services/*.vala src/Widgets/*.vala

        vscode theme: noctis high contrast
        vsfont theme: AcPlus IBM VGA 8x16-2x    dfsdfsdf

        //Comienza la rama canvas_improvements

 */

namespace TradeSim.Data {
    public const string APP_VERSION = "2020.10.21";
}


public static int main (string[] args) {

    TradeSim.Application AppTradeSim = new TradeSim.Application ();

    return AppTradeSim.run (args);

}
