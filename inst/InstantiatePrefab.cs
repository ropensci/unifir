
    static void %method_name%()
    {
         GameObject go = (GameObject)AssetDatabase.LoadAssetAtPath(%prefab_path%, typeof(GameObject));
         go = (GameObject)PrefabUtility.InstantiatePrefab(go%scene_argument%); // second argument: scene
         go.transform.position = new Vector3(%x_position%, %y_position%, %z_position%);
         go.transform.eulerAngles = new Vector3(%x_rotation%, %y_rotation%, %z_rotation%);
    }
