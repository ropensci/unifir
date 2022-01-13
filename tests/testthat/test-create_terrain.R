test_that("create_terrain adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- create_terrain(
    script = script,
    method_name = "TerrainTest",
    heightmap_path = "heightmap_test",
    x_pos = 0,
    z_pos = 0,
    width = 4097,
    height = 4097,
    length = 4097,
    heightmap_resolution = 4097,
    texture_path = "texture_test"
  )

  # Generic prop tests

  expect_equal(
    nrow(script$beats),
    4
  )

  expect_equal(
    length(script$props),
    4
  )

  expect_identical(
    unique(script$using),
    script$props[[4]]$using
  )

  expect_true(
    script$beats[4, ]$exec
  )

  expect_true(
    "waiver" %in% class(script$props[[4]]$prop_file) ||
      file.exists(script$props[[4]]$prop_file)

  )

  expect_match(
    script$props[[4]]$method_name,
    script$beats[4, ]$name
  )

  expect_match(
    script$props[[4]]$method_type,
    script$beats[4, ]$type
  )

  # Function-specific tests

  expect_identical(
    script$props[[4]]$parameters,
    list(
      heightmap_path = "heightmap_test",
      x_pos = 0,
      z_pos = 0,
      width = 4097,
      height = 4097,
      length = 4097,
      heightmap_resolution = 4097,
      texturePath = "texture_test",
      add_texture_method = "AddTextureAutoAdd",
      read_raw_method = "ReadRawAutoAdd"
    )
  )

  expect_identical(
    unique(script$using),
    c("System", "System.IO", "UnityEngine")
  )

  expect_identical(
    script$beats[4, ]$name,
    "TerrainTest"
  )

  expect_identical(
    script$beats[4, ]$type,
    "CreateTerrain"
  )

  rm(script)
})

test_that("create_terrain actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- create_terrain(
    script = script,
    method_name = "TerrainTest",
    heightmap_path = "heightmap_test",
    x_pos = 0,
    z_pos = 0,
    width = 4097,
    height = 4097,
    length = 4097,
    heightmap_resolution = 4097,
    texture_path = "texture_test"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" ", "", outcome$props[[4]]), actual)
  writeLines(gsub(" ", "", "static void TerrainTest()\n{\n    string heightmapPath = \"heightmap_test\";\n    float x_pos = 0F;\n    float z_pos = 0F;\n    float width = 4097F;\n    float height = 4097F;\n    float length = 4097F;\n    int heightmapResolution = 4097;\n    string texturePath = \"texture_test\";\n\n    TerrainData terrainData = new TerrainData();\n    terrainData.size = new Vector3(width / 128, height, length / 128);\n    terrainData.heightmapResolution = heightmapResolution;\n\n    GameObject terrain = (GameObject)Terrain.CreateTerrainGameObject(terrainData);\n    terrain.transform.position = new Vector3(x_pos, 0, z_pos);\n    float [,] heights = ReadRawAutoAdd(heightmapPath, heightmapResolution);\n    terrainData.SetHeights(0, 0, heights);\n    if(texturePath != string.Empty){\n        AddTextureAutoAdd(texturePath, terrainData, width, length);\n    }\n    AssetDatabase.CreateAsset(terrainData, \"Assets/\" + heightmapPath + \".asset\");\n}\n"), # nolint
             expected)

  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)

})
