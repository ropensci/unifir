
     static void %method_name%()
     {
          using (StreamReader reader = new StreamReader("%manifest_path%"))
          {
               string line;
               while ((line = reader.ReadLine()) != null)
               {
               string[] fields = line.Split('\t');
               GameObject go = (GameObject)AssetDatabase.LoadAssetAtPath(fields[0], typeof(GameObject));
               go = (GameObject)PrefabUtility.InstantiatePrefab(go%destination_scene%); // second argument: scene
               go.transform.position = new Vector3(float.Parse(fields[1]), float.Parse(fields[2]), float.Parse(fields[3]));
               go.transform.localScale = new Vector3(float.Parse(fields[4]), float.Parse(fields[5]), float.Parse(fields[6]));
               go.transform.eulerAngles = new Vector3(float.Parse(fields[7]), float.Parse(fields[8]), float.Parse(fields[9]));
               }
          }
     }
