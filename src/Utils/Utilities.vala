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