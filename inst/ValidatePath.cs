
    static void %method_name%(string file_path) {
        if(File.Exists(file_path) == false){
            throw new ArgumentException("Could not find file: " + file_path);
        }
    }
