
    static void %method_name%()
    {
         GameObject go = (GameObject)AssetDatabase.LoadAssetAtPath("%prefab_path%", typeof(GameObject));
         go = (GameObject)PrefabUtility.InstantiatePrefab(go%destination_scene%); // second argument: scene
         go.transform.position = new Vector3(%x_position%f, %y_position%f, %z_position%f);
         go.transform.localScale = new Vector3(%x_scale%f, %y_scale%f, %z_scale%f);
         go.transform.eulerAngles = new Vector3(%x_rotation%f, %y_rotation%f, %z_rotation%f);
    }
