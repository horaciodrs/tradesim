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