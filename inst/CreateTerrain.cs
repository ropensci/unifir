    
    static void %method_name%()
    {
        string heightmapPath = %heightmap_path%;
        float x_pos = %x_pos%;
        float z_pos = %z_pos%;
        float width = %width%;
        float height = %height%;
        float length = %length%;
        int heightmapResolution = %heightmapResolution%;
        string texturePath = %texturePath%;

        TerrainData terrainData = new TerrainData();
        terrainData.size = new Vector3(width / 128, height, length / 128);
        terrainData.heightmapResolution = heightmapResolution;

        GameObject terrain = (GameObject)Terrain.CreateTerrainGameObject(terrainData);
        terrain.transform.position = new Vector3(x_pos, 0, z_pos);
        float [,] heights = ReadRaw(heightmapPath, heightmapResolution);
        terrainData.SetHeights(0, 0, heights);
        if(texturePath != string.Empty){
            AddTexture(texturePath, terrainData, width, length);
        }
        AssetDatabase.CreateAsset(terrainData, "Assets/" + heightmapPath + ".asset");
    }
    
    static void AddTexture(string path, TerrainData terrainData, float width, float length)
    {
        Texture2D texture = LoadPNG(path);
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
