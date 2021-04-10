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

public class TradeSim.Objects.OperationItem {

    public int id { get; set; }
    public string provider_name { get; set; }
    public string ticker_name { get; set; }
    public DateTime operation_date { get; set; }
    public int state { get; set; }
    public int type_op { get; set; }
    public string observations { get; set; }
    public double volume { get; set; }
    public double price { get; set; }
    public double tp { get; set; }
    public double sl { get; set; }
    public double profit { get; set; }
    public bool visible { get; set; }

    public double ? close_price;
    public DateTime ? close_date;

    private double default_lote;

    public enum State {
        OPEN
        , CLOSED
    }

    public enum Type {
        BUY
        , SELL
    }

    public OperationItem (int _id, string _provider_name, string _ticker_name
                          , DateTime _date, int _state, string _observations
                          , double _volume, double _price, double _tp, double _sl
                          , int _type) {
        id = _id;
        provider_name = _provider_name;
        ticker_name = _ticker_name;
        operation_date = _date;
        state = _state;
        observations = _observations;
        volume = _volume;
        price = _price;
        tp = _tp;
        sl = _sl;
        type_op = _type;

        close_price = null;
        close_date = null;

        default_lote = 100000.00;

        visible = true;

    }

    public OperationItem.default () {

    }

    public void print_data () {
        print ("id:" + id.to_string () + "\n");
        print ("provider_name:" + provider_name + "\n");
        print ("ticker_name:" + ticker_name + "\n");
        print ("operation_date:" + operation_date.to_string () + "\n");
        print ("state:" + state.to_string () + "\n");
        print ("type_op:" + type_op.to_string () + "\n");
        print ("observations:" + observations + "\n");
        print ("volume:" + volume.to_string () + "\n");
        print ("price:" + price.to_string () + "\n");
        print ("tp:" + tp.to_string () + "\n");
        print ("sl:" + sl.to_string () + "\n");
        print ("profit:" + profit.to_string () + "\n");
        print ("visible:" + visible.to_string () + "\n");
        print ("close_price:" + close_price.to_string () + "\n");
        print ("close_date:" + close_date.to_string () + "\n");
    }

    public string get_str_tp_amount () {
        return get_money (get_tp_amount ());
    }

    public double get_tp_amount () {

        double operation_value = volume * default_lote;
        double calc_costo = operation_value * price;
        double calc_profit = operation_value * tp;
        double return_value = 0.00;

        if (type_op == TradeSim.Objects.OperationItem.Type.BUY) {
            return_value = calc_profit - calc_costo;
        } else if (type_op == TradeSim.Objects.OperationItem.Type.SELL) {
            return_value = calc_costo - calc_profit;
        }

        return return_value;

    }

    public string get_str_sl_amount () {
        return get_money (get_sl_amount ());
    }

    public double get_sl_amount () {

        double operation_value = volume * default_lote;
        double calc_costo = operation_value * price;
        double calc_profit = operation_value * sl;
        double return_value = 0.00;

        if (type_op == TradeSim.Objects.OperationItem.Type.BUY) {
            return_value = calc_costo - calc_profit;
            if (sl > price) {
                return_value = return_value * (-1.00);
            }
        } else if (type_op == TradeSim.Objects.OperationItem.Type.SELL) {
            return_value = calc_profit - calc_costo;
            if (sl < price) {
                return_value = return_value * (-1.00);
            }
        }

        return return_value;

    }

    public void write_file (Xml.TextWriter writer) throws FileError {

        writer.start_element ("operation");

        writer.start_element ("id");
        writer.write_string (id.to_string ());
        writer.end_element ();

        writer.start_element ("providername");
        writer.write_string (provider_name);
        writer.end_element ();

        writer.start_element ("tickername");
        writer.write_string (ticker_name);
        writer.end_element ();

        writer.start_element ("operationdate");
        writer.write_string (operation_date.to_unix ().to_string ());
        writer.end_element ();

        writer.start_element ("state");
        writer.write_string (state.to_string ());
        writer.end_element ();

        writer.start_element ("type");
        writer.write_string (type_op.to_string ());
        writer.end_element ();

        writer.start_element ("observations");
        writer.write_string (observations);
        writer.end_element ();

        writer.start_element ("volume");
        writer.write_string (volume.to_string ());
        writer.end_element ();

        writer.start_element ("price");
        writer.write_string (price.to_string ());
        writer.end_element ();

        writer.start_element ("tp");
        writer.write_string (tp.to_string ());
        writer.end_element ();

        writer.start_element ("sl");
        writer.write_string (sl.to_string ());
        writer.end_element ();

        writer.start_element ("profit");
        writer.write_string (profit.to_string ());
        writer.end_element ();

        writer.start_element ("visible");
        writer.write_string (visible.to_string ());
        writer.end_element ();


        if (close_price != null) {
            writer.start_element ("closeprice");
            writer.write_string (close_price.to_string ());
            writer.end_element ();
        }

        if (close_date != null) {
            writer.start_element ("closedate");
            writer.write_string (close_date.to_unix ().to_string ());
            writer.end_element ();
        }

        writer.end_element ();
    }

}
