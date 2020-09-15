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

public class TradeSim.Objects.OperationItem{

    private int Id {get; set;}
    private string ProviderName {get; set;}
    private string TickerName {get; set;}
    private DateTime Date {get; set;}
    private string State {get; set;}
    private string Observations {get; set;}
    private double Volume {get; set;}
    private double Price {get; set;}
    private double Tp {get; set;}
    private double Sl {get; set;}
    private double Profit {get; set;}

    public OperationItem(){

    }

    public double get_profit_by_price(double price){

        return 0.00;
        
    }

}