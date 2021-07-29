using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor.Experimental.TerrainAPI;
     
public class TerrainrImport : EditorWindow {
       
    private static EditorWindow window;
    
    private float width  = 4097;
    private float length = 4097;
    private float height = 2394;
    private int heightmapResolution = 4097;
    private string heightmapPath = "terrainr.raw";
    
    public enum Depth { Bit8 = 1, Bit16 = 2 }
    public enum ByteOrder { Mac = 1, Windows = 2 }
    public Depth m_Depth = Depth.Bit16;
    public int m_Resolution = 1;
    public ByteOrder m_ByteOrder = ByteOrder.Windows;

    [MenuItem("Terrain/RAW tile import")]
    public static void CreateWindow(){
        window = EditorWindow.GetWindow(typeof(TerrainrImport));
        window.title = "RAW tile import";
    }
    
    private void OnGUI(){
        heightmapPath  = EditorGUILayout.TextField("Path to RAW file", heightmapPath);           
        width = EditorGUILayout.FloatField("Terrain Width", width);
        length = EditorGUILayout.FloatField("Terrain Length", length);
        height = EditorGUILayout.FloatField("Terrain Height", height);
        
        EditorGUILayout.Space();
    
        heightmapResolution = EditorGUILayout.IntField("Heightmap Resolution", heightmapResolution);
        heightmapResolution = Mathf.ClosestPowerOfTwo(heightmapResolution) + 1;
        heightmapResolution = Mathf.Clamp(heightmapResolution, 33, 4097);
        
        if(GUILayout.Button("Create")){
            ValidatePath();
            CreateTerrain();
        }
    }
    
    private void ValidatePath(){
        if(File.Exists(heightmapPath) == false){
            throw new ArgumentException("Could not find file: " + heightmapPath);
        }
    }
    
    private void CreateTerrain(){
        TerrainData terrainData = new TerrainData();
        terrainData.size = new Vector3(width / 128, height, length / 128);
        terrainData.heightmapResolution = heightmapResolution;

        GameObject terrain = (GameObject)Terrain.CreateTerrainGameObject(terrainData);
        ReadRaw(heightmapPath, terrainData);
        AssetDatabase.CreateAsset(terrainData, "Assets/" + heightmapPath + ".asset");
    }

    void ReadRaw(string path, TerrainData terrainData)
    {
        m_Resolution = terrainData.heightmapResolution;

        // Read data
        byte[] data;
        using (BinaryReader br = new BinaryReader(File.Open(path, FileMode.Open, FileAccess.Read)))
        {
            data = br.ReadBytes(m_Resolution * m_Resolution * (int)m_Depth);
            br.Close();
        }

        int heightmapRes = terrainData.heightmapResolution;
        float[,] heights = new float[heightmapRes, heightmapRes];

            float normalize = 1.0F / (1 << 16);
            for (int y = 0; y < heightmapRes; ++y)
            {
                for (int x = 0; x < heightmapRes; ++x)
                {
                    int index = Mathf.Clamp(x, 0, m_Resolution - 1) + Mathf.Clamp(y, 0, m_Resolution - 1) * m_Resolution;
                    ushort compressedHeight = System.BitConverter.ToUInt16(data, index * 2);
                    float height = compressedHeight * normalize;
                    heights[y, x] = height;
                }
            }

        terrainData.SetHeights(0, 0, heights);
    }
}
    
    
