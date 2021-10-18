    
    static void %method_name%(string path, TerrainData terrainData, float width, float length)
    {
        Texture2D texture = %loadpng_method%(path);
        AssetDatabase.CreateAsset(texture, "Assets/texture_" + path + ".asset");
        TerrainLayer overlay = new TerrainLayer();
        overlay.tileSize = new Vector2(width, length);
        overlay.diffuseTexture = texture;
        AssetDatabase.CreateAsset(overlay, "Assets/overlay_" + path + ".asset");
        var layers = terrainData.terrainLayers;
        int newIndex = layers.Length;
        var newarray = new TerrainLayer[newIndex + 1];
        Array.Copy(layers, 0, newarray, 0, newIndex);
        newarray[newIndex] = overlay;
        terrainData.SetTerrainLayersRegisterUndo(newarray, "Add terrain layer");
    }
