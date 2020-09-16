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

    public double get_operation_profit_by_id(int _id, double _price){

        TradeSim.Objects.OperationItem _operation = null;

        for(int i=0; i<operations.length; i++){
            if(operations.index(i).id == _id){
                _operation = operations.index(i);
            }
        }

        if(_operation != null){
            return get_operation_profit_by_price(_operation, _price);
        }

        return -1.00;

    }

    public double get_operation_profit_by_price(TradeSim.Objects.OperationItem _operation, double _price){

        double return_value = 0.00;

        double original = _operation.volume * DefaultLote * _operation.price;
        double actual = _operation.volume * DefaultLote * _price;

        return_value = actual - original;

        return return_value;

    }

    public void add_operation(TradeSim.Objects.OperationItem _operation){

        operations.append_val(_operation);

    }

}