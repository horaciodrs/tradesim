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

public class TradeSim.Services.FileReader {

    private Xml.Doc * doc;
    private unowned string filename;
    private int status;

    private TradeSim.Objects.CanvasData canvas_data;
    private Array<TradeSim.Objects.OperationItem> operations;
    private Array<TradeSim.Drawings.Line> lines;
    private Array<TradeSim.Drawings.HLine> hlines;
    private Array<TradeSim.Drawings.Rectangle> rectangles;
    private Array<TradeSim.Drawings.Fibonacci> fibonaccies;

    public FileReader (string file) throws FileError, MarkupError {

        filename = file;

        doc = Xml.Parser.parse_file (filename);

        canvas_data = new TradeSim.Objects.CanvasData ();

        operations = new Array<TradeSim.Objects.OperationItem> ();

        lines = new Array<TradeSim.Drawings.Line> ();
        hlines = new Array<TradeSim.Drawings.HLine> ();
        rectangles = new Array<TradeSim.Drawings.Rectangle> ();
        fibonaccies = new Array<TradeSim.Drawings.Fibonacci> ();

    }

    public void read () {

        if (doc == null) {
            print ("File " + filename + " not found or permissions missing\n");
            return;
        }

        Xml.Node * simulation = doc->get_root_element ();

        if (simulation == null) {
            print ("WANTED! root\n");
            delete doc;
            return;
        }

        for (Xml.Node * iter = simulation->children ; iter != null ; iter = iter->next) {
            if (iter->type == Xml.ElementType.ELEMENT_NODE) {

                //print (iter->name + "\n");

                switch (iter->name) {
                case "name":
                    canvas_data.simulation_name = iter->get_content ();
                    break;
                case "initialbalance":
                    canvas_data.simulation_initial_balance = double.parse (iter->get_content ());
                    break;
                case "dateinicial":
                    canvas_data.date_inicial = new DateTime.from_unix_local (int.parse (iter->get_content ()));
                    break;
                case "datefrom":
                    canvas_data.date_from = new DateTime.from_unix_local (int.parse (iter->get_content ()));
                    break;
                case "dateto":
                    canvas_data.date_to = new DateTime.from_unix_local (int.parse (iter->get_content ()));
                    break;
                case "lastcandledate":
                    canvas_data.last_candle_date = new DateTime.from_unix_local (int.parse (iter->get_content ()));
                    break;
                case "lastcandleprice":
                    canvas_data.last_candle_price = double.parse (iter->get_content ());
                    break;
                case "lastcandlemaxprice":
                    canvas_data.last_candle_max_price = double.parse (iter->get_content ());
                    break;
                case "lastcandleminprice":
                    canvas_data.last_candle_min_price = double.parse (iter->get_content ());
                    break;
                case "providername":
                    canvas_data.provider_name = iter->get_content ();
                    break;
                case "timeframe":
                    canvas_data.time_frame = iter->get_content ();
                    break;
                case "ticker":
                    canvas_data.ticker = iter->get_content ();
                    break;
                case "operations":

                    for (Xml.Node * iter_operations = iter->children ; iter_operations != null ; iter_operations = iter_operations->next) {

                        if (iter_operations->type == Xml.ElementType.ELEMENT_NODE) {

                            var new_operation = new TradeSim.Objects.OperationItem.default ();

                            for (Xml.Node * iter_operations_item = iter_operations->children ; iter_operations_item != null ; iter_operations_item = iter_operations_item->next) {
                                if (iter_operations_item->type == Xml.ElementType.ELEMENT_NODE) {
                                    switch (iter_operations_item->name) {
                                    case "providername":
                                        new_operation.provider_name = iter_operations_item->get_content ();
                                        break;
                                    case "tickername":
                                        new_operation.ticker_name = iter_operations_item->get_content ();
                                        break;
                                    case "operationdate":
                                        new_operation.operation_date = new DateTime.from_unix_local (int.parse (iter_operations_item->get_content ()));
                                        break;
                                    case "state":
                                        new_operation.state = int.parse (iter_operations_item->get_content ());
                                        break;
                                    case "type":
                                        new_operation.type_op = int.parse (iter_operations_item->get_content ());
                                        break;
                                    case "observations":
                                        new_operation.observations = iter_operations_item->get_content ();
                                        break;
                                    case "volume":
                                        new_operation.volume = double.parse (iter_operations_item->get_content ());
                                        break;
                                    case "price":
                                        new_operation.price = double.parse (iter_operations_item->get_content ());
                                        break;
                                    case "tp":
                                        new_operation.tp = double.parse (iter_operations_item->get_content ());
                                        break;
                                    case "sl":
                                        new_operation.sl = double.parse (iter_operations_item->get_content ());
                                        break;
                                    case "profit":
                                        new_operation.profit = double.parse (iter_operations_item->get_content ());
                                        break;
                                    case "visible":
                                        new_operation.visible = bool.parse (iter_operations_item->get_content ());
                                        break;
                                    case "closeprice":
                                        new_operation.close_price = double.parse (iter_operations_item->get_content ());
                                        break;
                                    case "closedate":
                                        new_operation.close_date = new DateTime.from_unix_local (int.parse (iter_operations_item->get_content ()));
                                        break;
                                    default:
                                        print ("Unexpected element %s\n", iter->name);
                                        break;
                                    }
                                }
                            }

                            operations.append_val (new_operation);

                        }
                    }
                    break;
                case "drawings":
                    for (Xml.Node * iter_drawings = iter->children ; iter_drawings != null ; iter_drawings = iter_drawings->next) {
                        if (iter_drawings->type == Xml.ElementType.ELEMENT_NODE) {
                            switch (iter_drawings->name) {
                            case "fibonaccies":
                                for (Xml.Node * iter_fibonaccies = iter_drawings->children ; iter_fibonaccies != null ; iter_fibonaccies = iter_fibonaccies->next) {

                                    if (iter_fibonaccies->type == Xml.ElementType.ELEMENT_NODE) {

                                        var new_fibonacci = new TradeSim.Drawings.Fibonacci.default ();

                                        for (Xml.Node * iter_fibonaccies_item = iter_fibonaccies->children ; iter_fibonaccies_item != null ; iter_fibonaccies_item = iter_fibonaccies_item->next) {
                                            if (iter_fibonaccies_item->type == Xml.ElementType.ELEMENT_NODE) {
                                                switch (iter_fibonaccies_item->name) {
                                                case "date1":
                                                    new_fibonacci.set_x1 (new DateTime.from_unix_local (int.parse (iter_fibonaccies_item->get_content ())));
                                                    break;
                                                case "date2":
                                                    new_fibonacci.set_x2 (new DateTime.from_unix_local (int.parse (iter_fibonaccies_item->get_content ())));
                                                    break;
                                                case "price1":
                                                    new_fibonacci.set_y1 (double.parse (iter_fibonaccies_item->get_content ()));
                                                    break;
                                                case "price2":
                                                    new_fibonacci.set_y2 (double.parse (iter_fibonaccies_item->get_content ()));
                                                    break;
                                                case "color":
                                                    int red = int.parse (iter_fibonaccies_item->get_prop ("red"));
                                                    int green = int.parse (iter_fibonaccies_item->get_prop ("green"));
                                                    int blue = int.parse (iter_fibonaccies_item->get_prop ("blue"));
                                                    double alpha = double.parse (iter_fibonaccies_item->get_prop ("alpha"));
                                                    var new_color = new TradeSim.Utils.Color.with_alpha (red, green, blue, alpha);
                                                    new_fibonacci.set_color (new_color);
                                                    break;
                                                case "thickness":
                                                    new_fibonacci.set_thickness (int.parse (iter_fibonaccies_item->get_content ()));
                                                    break;
                                                case "visible":
                                                    new_fibonacci.set_visible (bool.parse (iter_fibonaccies_item->get_content ()));
                                                    break;
                                                case "enabled":
                                                    new_fibonacci.set_enabled (bool.parse (iter_fibonaccies_item->get_content ()));
                                                    break;
                                                default:
                                                    print ("Unexpected element %s\n", iter->name);
                                                    break;
                                                }
                                            }
                                        }

                                        fibonaccies.append_val (new_fibonacci);
                                    }
                                }
                                break;
                            case "hlines":
                                for (Xml.Node * iter_hlines = iter_drawings->children ; iter_hlines != null ; iter_hlines = iter_hlines->next) {

                                    if (iter_hlines->type == Xml.ElementType.ELEMENT_NODE) {

                                        var new_hline = new TradeSim.Drawings.HLine.default ();

                                        for (Xml.Node * iter_hlines_item = iter_hlines->children ; iter_hlines_item != null ; iter_hlines_item = iter_hlines_item->next) {
                                            if (iter_hlines_item->type == Xml.ElementType.ELEMENT_NODE) {
                                                switch (iter_hlines_item->name) {
                                                case "date1":
                                                    new_hline.set_x1 (new DateTime.from_unix_local (int.parse (iter_hlines_item->get_content ())));
                                                    break;
                                                case "date2":
                                                    new_hline.set_x2 (new DateTime.from_unix_local (int.parse (iter_hlines_item->get_content ())));
                                                    break;
                                                case "price1":
                                                    new_hline.set_y1 (double.parse (iter_hlines_item->get_content ()));
                                                    break;
                                                case "price2":
                                                    new_hline.set_y2 (double.parse (iter_hlines_item->get_content ()));
                                                    break;
                                                case "color":
                                                    int red = int.parse (iter_hlines_item->get_prop ("red"));
                                                    int green = int.parse (iter_hlines_item->get_prop ("green"));
                                                    int blue = int.parse (iter_hlines_item->get_prop ("blue"));
                                                    double alpha = double.parse (iter_hlines_item->get_prop ("alpha"));
                                                    var new_color = new TradeSim.Utils.Color.with_alpha (red, green, blue, alpha);
                                                    new_hline.set_color (new_color);
                                                    break;
                                                case "thickness":
                                                    new_hline.set_thickness (int.parse (iter_hlines_item->get_content ()));
                                                    break;
                                                case "visible":
                                                    new_hline.set_visible (bool.parse (iter_hlines_item->get_content ()));
                                                    break;
                                                case "enabled":
                                                    new_hline.set_enabled (bool.parse (iter_hlines_item->get_content ()));
                                                    break;
                                                default:
                                                    print ("Unexpected element %s\n", iter->name);
                                                    break;
                                                }
                                            }
                                        }

                                        hlines.append_val (new_hline);
                                    }
                                }
                                break;
                            case "lines":
                                for (Xml.Node * iter_lines = iter_drawings->children ; iter_lines != null ; iter_lines = iter_lines->next) {

                                    if (iter_lines->type == Xml.ElementType.ELEMENT_NODE) {

                                        var new_line = new TradeSim.Drawings.Line.default ();

                                        for (Xml.Node * iter_lines_item = iter_lines->children ; iter_lines_item != null ; iter_lines_item = iter_lines_item->next) {
                                            if (iter_lines_item->type == Xml.ElementType.ELEMENT_NODE) {
                                                switch (iter_lines_item->name) {
                                                case "date1":
                                                    new_line.set_x1 (new DateTime.from_unix_local (int.parse (iter_lines_item->get_content ())));
                                                    break;
                                                case "date2":
                                                    new_line.set_x2 (new DateTime.from_unix_local (int.parse (iter_lines_item->get_content ())));
                                                    break;
                                                case "price1":
                                                    new_line.set_y1 (double.parse (iter_lines_item->get_content ()));
                                                    break;
                                                case "price2":
                                                    new_line.set_y2 (double.parse (iter_lines_item->get_content ()));
                                                    break;
                                                case "color":
                                                    int red = int.parse (iter_lines_item->get_prop ("red"));
                                                    int green = int.parse (iter_lines_item->get_prop ("green"));
                                                    int blue = int.parse (iter_lines_item->get_prop ("blue"));
                                                    double alpha = double.parse (iter_lines_item->get_prop ("alpha"));
                                                    var new_color = new TradeSim.Utils.Color.with_alpha (red, green, blue, alpha);
                                                    new_line.set_color (new_color);
                                                    break;
                                                case "thickness":
                                                    new_line.set_thickness (int.parse (iter_lines_item->get_content ()));
                                                    break;
                                                case "visible":
                                                    new_line.set_visible (bool.parse (iter_lines_item->get_content ()));
                                                    break;
                                                case "enabled":
                                                    new_line.set_enabled (bool.parse (iter_lines_item->get_content ()));
                                                    break;
                                                default:
                                                    print ("Unexpected element %s\n", iter->name);
                                                    break;
                                                }
                                            }
                                        }

                                        lines.append_val (new_line);
                                    }
                                }
                                break;
                            case "rectangles":
                                for (Xml.Node * iter_rectangles = iter_drawings->children ; iter_rectangles != null ; iter_rectangles = iter_rectangles->next) {

                                    if (iter_rectangles->type == Xml.ElementType.ELEMENT_NODE) {

                                        var new_rectangle = new TradeSim.Drawings.Rectangle.default ();

                                        for (Xml.Node * iter_rectangles_item = iter_rectangles->children ; iter_rectangles_item != null ; iter_rectangles_item = iter_rectangles_item->next) {
                                            if (iter_rectangles_item->type == Xml.ElementType.ELEMENT_NODE) {
                                                switch (iter_rectangles_item->name) {
                                                case "date1":
                                                    new_rectangle.set_x1 (new DateTime.from_unix_local (int.parse (iter_rectangles_item->get_content ())));
                                                    break;
                                                case "date2":
                                                    new_rectangle.set_x2 (new DateTime.from_unix_local (int.parse (iter_rectangles_item->get_content ())));
                                                    break;
                                                case "price1":
                                                    new_rectangle.set_y1 (double.parse (iter_rectangles_item->get_content ()));
                                                    break;
                                                case "price2":
                                                    new_rectangle.set_y2 (double.parse (iter_rectangles_item->get_content ()));
                                                    break;
                                                case "color":
                                                    int red = int.parse (iter_rectangles_item->get_prop ("red"));
                                                    int green = int.parse (iter_rectangles_item->get_prop ("green"));
                                                    int blue = int.parse (iter_rectangles_item->get_prop ("blue"));
                                                    double alpha = double.parse (iter_rectangles_item->get_prop ("alpha"));
                                                    var new_color = new TradeSim.Utils.Color.with_alpha (red, green, blue, alpha);
                                                    new_rectangle.set_color (new_color);
                                                    break;
                                                case "thickness":
                                                    new_rectangle.set_thickness (int.parse (iter_rectangles_item->get_content ()));
                                                    break;
                                                case "visible":
                                                    new_rectangle.set_visible (bool.parse (iter_rectangles_item->get_content ()));
                                                    break;
                                                case "enabled":
                                                    new_rectangle.set_enabled (bool.parse (iter_rectangles_item->get_content ()));
                                                    break;
                                                default:
                                                    print ("Unexpected element %s\n", iter->name);
                                                    break;
                                                }
                                            }
                                        }

                                        rectangles.append_val (new_rectangle);
                                    }
                                }
                                break;
                            default:
                                print ("Unexpected element %s\n", iter->name);
                                break;
                            }
                        }
                    }
                    break;
                default:
                    print ("Unexpected element %s\n", iter->name);
                    break;
                }
            }
        }

        canvas_data.print_data ();

        print ("----------OPERATIONS-----------\n");
        for (int i = 0 ; i < operations.length ; i++) {
            operations.index (i).print_data ();
            print ("---------------------\n");
        }

        print ("----------LINES-----------\n");
        for (int i = 0 ; i < lines.length ; i++) {
            lines.index (i).print_data ();
            print ("---------------------\n");
        }

        print ("----------HLINES-----------\n");
        for (int i = 0 ; i < hlines.length ; i++) {
            hlines.index (i).print_data ();
            print ("---------------------\n");
        }

        print ("----------RECTANGLES-----------\n");
        for (int i = 0 ; i < rectangles.length ; i++) {
            rectangles.index (i).print_data ();
            print ("---------------------\n");
        }

        print ("----------FIBONACCIES-----------\n");
        for (int i = 0 ; i < fibonaccies.length ; i++) {
            fibonaccies.index (i).print_data ();
            print ("---------------------\n");
        }

    }

}
