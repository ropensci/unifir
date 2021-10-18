    
    static void %method_name%()
    {
        string heightmapPath = "%heightmap_path%";
        float x_pos = %x_pos%F;
        float z_pos = %z_pos%F;
        float width = %width%F;
        float height = %height%F;
        float length = %length%F;
        int heightmapResolution = %heightmapResolution%;
        string texturePath = "%texturePath%";

        TerrainData terrainData = new TerrainData();
        terrainData.size = new Vector3(width / 128, height, length / 128);
        terrainData.heightmapResolution = heightmapResolution;

        GameObject terrain = (GameObject)Terrain.CreateTerrainGameObject(terrainData);
        terrain.transform.position = new Vector3(x_pos, 0, z_pos);
        float [,] heights = %read_raw_method%(heightmapPath, heightmapResolution);
        terrainData.SetHeights(0, 0, heights);
        if(texturePath != string.Empty){
            %add_texture_method%(texturePath, terrainData, width, length);
        }
        AssetDatabase.CreateAsset(terrainData, "Assets/" + heightmapPath + ".asset");
    }
    