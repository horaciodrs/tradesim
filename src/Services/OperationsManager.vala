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

public class TradeSim.Services.OperationsManager{

    public Array<TradeSim.Objects.OperationItem> operations;

    public double DefaultLote;

    public OperationsManager(){

        DefaultLote = 100000.00;

        operations = new Array<TradeSim.Objects.OperationItem> ();


    }

    public int get_code_for_new_operation(){
        return (int) (operations.length) + 1;
    }

    public TradeSim.Objects.OperationItem get_operation_by_id(int _id){

        TradeSim.Objects.OperationItem _operation = null;

        for(int i=0; i<operations.length; i++){
            if(operations.index(i).id == _id){
                _operation = operations.index(i);
            }
        }

        return _operation;

    }

    public double get_operation_profit_by_id(int _id, double _price){

        TradeSim.Objects.OperationItem _operation = get_operation_by_id(_id);

        /*for(int i=0; i<operations.length; i++){
            if(operations.index(i).id == _id){
                _operation = operations.index(i);
            }
        }*/

        if(_operation != null){
            return get_operation_profit_by_price(_operation, _price);
        }

        return -1.00;

    }

    public double get_operation_profit_by_price(TradeSim.Objects.OperationItem _operation, double _price){

        double return_value = 0.00;

        if(_operation.state == TradeSim.Objects.OperationItem.State.CLOSED){
            return _operation.profit;
        }

        double original = _operation.volume * DefaultLote * _operation.price;
        double actual = _operation.volume * DefaultLote * _price;

        return_value = actual - original;

        if(_operation.type_op == TradeSim.Objects.OperationItem.Type.SELL){
            return_value = return_value * (-1.00);
        }

        return return_value;

    }

    public void add_operation(TradeSim.Objects.OperationItem _operation){

        operations.append_val(_operation);

    }

    public void close_operation_by_id(int _id, double price){

        TradeSim.Objects.OperationItem _operation = get_operation_by_id(_id);

        if(_operation != null){
            close_operation(_operation, price);
        }

    }

    public void close_operation(TradeSim.Objects.OperationItem _operation, double price){

        _operation.profit = get_operation_profit_by_price(_operation, price);
        _operation.state = TradeSim.Objects.OperationItem.State.CLOSED;

    }

    public void hide_operation_by_id(int _id){

       TradeSim.Objects.OperationItem _operation = get_operation_by_id(_id);

       if(_operation != null){
           hide_operation(_operation);
       }

    }

    public void hide_operation(TradeSim.Objects.OperationItem _operation){

        bool new_visibility = !_operation.visible;

        _operation.visible = new_visibility;

    }

}
