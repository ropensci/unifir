
    private static Texture2D %method_name%(string imagePath){
        Texture2D texture = null;
        byte[] imgData;

        imgData = File.ReadAllBytes(imagePath);
        texture = new Texture2D(2, 2);
        texture.LoadImage(imgData);

        return texture;
    }
