double _r(int red){
    return red/255.00;
}

double _g(int green){
    return green/255.00;
}

double _b(int blue){
    return blue/255.00;
}

public void create_dir_with_parents (string dir) {
    string path = Environment.get_home_dir () + dir;
    File tmp = File.new_for_path (path);
    if (tmp.query_file_type (0) != FileType.DIRECTORY) {
        GLib.DirUtils.create_with_parents (path, 0775);
    }
}

public string get_month_name(int i){
    
    if(i==1){
        return "January";
    }else if(i==2){
        return "February";
    }else if(i==3){
        return "March";
    }else if(i==4){
        return "April";
    }else if(i==5){
        return "May";
    }else if(i==6){
        return "June";
    }else if(i==7){
        return "July";
    }else if(i==8){
        return "August";
    }else if(i==9){
        return "September";
    }else if(i==10){
        return "Octover";
    }else if(i==11){
        return "November";
    }else{
        return "December";
    }

}

public int get_month_number(string month){
    
    if(month=="January"){
        return 1;
    }else if(month=="February"){
        return 2;
    }else if(month=="March"){
        return 3;
    }else if(month=="April"){
        return 4;
    }else if(month=="May"){
        return 5;
    }else if(month=="June"){
        return 6;
    }else if(month=="July"){
        return 7;
    }else if(month=="August"){
        return 8;
    }else if(month=="September"){
        return 8;
    }else if(month=="Octover"){
        return 10;
    }else if(month=="November"){
        return 11;
    }else{
        return 12;
    }

}

DateTime date_add_int_by_time_frame(DateTime add_date, string time_frame, int qty){

    int add_value = 1;

    if(time_frame == "M1"){
        add_value = 1;
        return add_date.add_minutes(add_value*qty);
    }else if(time_frame == "M5"){
        add_value = 5;
        return add_date.add_minutes(add_value*qty);
    }else if(time_frame == "M15"){
        add_value = 15;
        return add_date.add_minutes(add_value*qty);
    }else if(time_frame == "M30"){
        add_value = 30;
        return add_date.add_minutes(add_value*qty);
    }else if(time_frame == "H1"){
        add_value = 1;
        return add_date.add_hours(add_value*qty);
    }else if(time_frame == "H4"){
        add_value = 4;
        return add_date.add_hours(add_value*qty);
    }else if(time_frame == "D1"){
        add_value = 24;
        return add_date.add_hours(add_value*qty);
    }else{
        return add_date.add_minutes(qty);
    }
    
}