
     static void %method_name%()
     {
        GameObject lightGameObject = new GameObject("%light_name%");
        lightGameObject.transform.position = new Vector3(%x_position%, %y_position%, %z_position%);
        lightGameObject.transform.localScale = new Vector3(%x_scale%, %y_scale%, %z_scale%);
        lightGameObject.transform.eulerAngles = new Vector3(%x_rotation%, %y_rotation%, %z_rotation%);

        Light lightComp = lightGameObject.AddComponent<Light>();
        lightComp.type = LightType.%light_type%;
     }
