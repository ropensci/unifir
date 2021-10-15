
    static float[,] %method_name%(string path, int heightmapResolution)
    {
        byte[] data;
        using (BinaryReader br = new BinaryReader(File.Open(path, FileMode.Open, FileAccess.Read)))
        {
            data = br.ReadBytes(heightmapResolution * heightmapResolution * (int)m_Depth);
            br.Close();
        }

        float[,] heights = new float[heightmapResolution, heightmapResolution];

            float normalize = 1.0F / (1 << 16);
            for (int y = 0; y < heightmapResolution; ++y)
            {
                for (int x = 0; x < heightmapResolution; ++x)
                {
                    int index = Mathf.Clamp(x, 0, heightmapResolution - 1) + Mathf.Clamp(y, 0, heightmapResolution - 1) * heightmapResolution;
                    ushort compressedHeight = System.BitConverter.ToUInt16(data, index * 2);
                    float height = compressedHeight * normalize;
                    heights[y, x] = height;
                }
            }

        return heights;
    }
