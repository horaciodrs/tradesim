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

double _r (int red) {
    return red / 255.00;
}

double _g (int green) {
    return green / 255.00;
}

double _b (int blue) {
    return blue / 255.00;
}

public void create_dir_with_parents (string dir) {
    string path = Environment.get_home_dir () + dir;
    File tmp = File.new_for_path (path);
    if (tmp.query_file_type (0) != FileType.DIRECTORY) {
        GLib.DirUtils.create_with_parents (path, 0775);
    }
}

public string get_money (double amount, int decs = 2) {

    char[] buf = new char[double.DTOSTR_BUF_SIZE];

    string return_value = amount.format (buf, "%f"); // 'e', 'E', 'f', 'F', 'g' and 'G'.

    string[] aux = return_value.split (".");

    if (aux[1] != null) {
        return_value = aux[0];
        if ((return_value.length >= 4) && (amount > 0)) {
            string p1 = return_value.substring (0, return_value.length - 3);
            string p2 = return_value.substring (return_value.length - 3, 3);
            return_value = p1 + "," + p2;
        } else if ((return_value.length >= 5) && (amount < 0)) {
            string p1 = return_value.substring (0, 2);
            string p2 = return_value.substring (return_value.length - 3, 3);
            return_value = p1 + "," + p2;
        }
        return_value = return_value + ".";
        return_value = return_value + aux[1].substring (0, decs);
    } else {
        return_value = "0.00";
    }

    return return_value;
}

public string get_fecha (DateTime fecha) {

    string dia = fecha.get_day_of_month ().to_string ();
    string mes = get_month_name (fecha.get_month ());
    string anio = fecha.get_year ().to_string ();
    string hora = fecha.get_hour ().to_string ();
    string minuto = "0" + fecha.get_minute ().to_string ();

    minuto = minuto.substring (minuto.length - 2, 2);

    return mes + " " + dia + ",  " + anio + " at " + hora + ":" + minuto + "hs.";
}

public string get_datetime_to_db (DateTime fecha) {

    string dia = "00" + fecha.get_day_of_month ().to_string ();
    string mes = "00" + fecha.get_month ().to_string ();
    string anio = fecha.get_year ().to_string ();
    string hora = "00" + fecha.get_hour ().to_string ();
    string minuto = "00" + fecha.get_minute ().to_string ();

    string return_value = "";

    dia = dia.substring (dia.length - 2, 2);
    mes = mes.substring (mes.length - 2, 2);
    hora = hora.substring (hora.length - 2, 2);
    minuto = minuto.substring (minuto.length - 2, 2);

    return_value = return_value + anio + "-" + mes + "-" + dia + " " + hora + ":" + minuto;

    return return_value;

}

public string get_month_name (int i) {

    if (i == 1) {
        return "January";
    } else if (i == 2) {
        return "February";
    } else if (i == 3) {
        return "March";
    } else if (i == 4) {
        return "April";
    } else if (i == 5) {
        return "May";
    } else if (i == 6) {
        return "June";
    } else if (i == 7) {
        return "July";
    } else if (i == 8) {
        return "August";
    } else if (i == 9) {
        return "September";
    } else if (i == 10) {
        return "Octover";
    } else if (i == 11) {
        return "November";
    } else {
        return "December";
    }

}

public int get_month_number (string month) {

    if (month == "January") {
        return 1;
    } else if (month == "February") {
        return 2;
    } else if (month == "March") {
        return 3;
    } else if (month == "April") {
        return 4;
    } else if (month == "May") {
        return 5;
    } else if (month == "June") {
        return 6;
    } else if (month == "July") {
        return 7;
    } else if (month == "August") {
        return 8;
    } else if (month == "September") {
        return 8;
    } else if (month == "Octover") {
        return 10;
    } else if (month == "November") {
        return 11;
    } else {
        return 12;
    }

}

int get_dist_to_viernes (DateTime fecha) {

    // pensada para time H1.

    var dia_posicion = fecha.get_day_of_week ();
    var anio = fecha.get_year ();
    var mes = fecha.get_month ();
    var dia = fecha.get_day_of_month ();
    var hora = fecha.get_hour ();
    // var minutos = fecha.get_minute ();


    if (dia_posicion < 5) {

        int distancia = 5 - dia_posicion;
        DateTime obj = new DateTime.local (anio, mes, dia, 0, 0, 0);
        obj = obj.add_days (distancia);

        return (distancia * 24 + 18 - hora);

    } else if (dia_posicion == 5) {
        return 18 - hora;
    }

    return 0;

}

DateTime get_next_market_date (DateTime fecha) {

    // pensada para time H1.

    var dia_posicion = fecha.get_day_of_week ();
    var anio = fecha.get_year ();
    var mes = fecha.get_month ();
    var dia = fecha.get_day_of_month ();
    // var hora = fecha.get_hour ();
    // var minutos = fecha.get_minute ();

    int distancia = 5 - dia_posicion;


    if (dia_posicion < 5) {

        DateTime obj = new DateTime.local (anio, mes, dia, 0, 0, 0);
        obj = obj.add_days (distancia);
        obj = obj.add_hours (18);
        obj = obj.add_days (2);

        return obj;

    } else if (dia_posicion == 5) {

        DateTime obj = new DateTime.local (anio, mes, dia, 0, 0, 0);
        obj = obj.add_hours (18);
        obj = obj.add_days (2);

        return obj;
    }

    return fecha;

}

DateTime date_add_int_by_time_frame (DateTime add_date, string time_frame, int qty) {

    int add_value = 1;

    if (time_frame == "M1") {
        add_value = 1;
        return add_date.add_minutes (add_value * qty);
    } else if (time_frame == "M5") {
        add_value = 5;
        return add_date.add_minutes (add_value * qty);
    } else if (time_frame == "M15") {
        add_value = 15;
        return add_date.add_minutes (add_value * qty);
    } else if (time_frame == "M30") {
        add_value = 30;
        return add_date.add_minutes (add_value * qty);
    } else if (time_frame == "H1") {
        int distancia = get_dist_to_viernes (add_date);
        if (distancia < add_value * qty) {
            int agregar = qty - distancia;
            DateTime aux = get_next_market_date (add_date);
            return aux.add_hours (agregar);
        } else {
            add_value = 1;
            return add_date.add_hours (add_value * qty);
        }
        // Lineas originales----->>>>>
        // add_value = 1;
        // return add_date.add_hours (add_value * qty);
        // Lineas originales FIN-----<<<<<
    } else if (time_frame == "H4") {
        add_value = 4;
        return add_date.add_hours (add_value * qty);
    } else if (time_frame == "D1") {
        add_value = 24;
        return add_date.add_hours (add_value * qty);
    } else {
        return add_date.add_minutes (qty);
    }

}

public void alert (string msg, Gtk.Window sender) {
    var dialog = new Gtk.MessageDialog (sender, 0, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, msg);
    dialog.run ();
    dialog.destroy ();
}

public bool confirm (string message, TradeSim.MainWindow _main_window, Gtk.MessageType mt) {
    Gtk.MessageDialog m = new Gtk.MessageDialog (_main_window, Gtk.DialogFlags.MODAL, mt, Gtk.ButtonsType.OK_CANCEL, message);
    Gtk.ResponseType result = (Gtk.ResponseType)m.run ();
    m.close ();
    if (result == Gtk.ResponseType.OK) {
        return true;
    } else {
        return false;
    }
}
