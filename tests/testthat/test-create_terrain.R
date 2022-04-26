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

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[4]]), actual)
  writeLines(
    "staticvoidTerrainTest(){stringheightmapPath=\"heightmap_test\";stringbasePath=\"heightmap_test\";floatx_pos=0F;floatz_pos=0F;floatwidth=4097F;floatheight=4097F;floatlength=4097F;intheightmapResolution=4097;stringtexturePath=\"texture_test\";TerrainDataterrainData=newTerrainData();terrainData.size=newVector3(width/128,height,length/128);terrainData.heightmapResolution=heightmapResolution;GameObjectterrain=(GameObject)Terrain.CreateTerrainGameObject(terrainData);terrain.transform.position=newVector3(x_pos,0,z_pos);float[,]heights=ReadRawAutoAdd(heightmapPath,heightmapResolution);terrainData.SetHeights(0,0,heights);if(texturePath!=string.Empty){AddTextureAutoAdd(texturePath,terrainData,width,length);}AssetDatabase.CreateAsset(terrainData,\"Assets/\"+basePath+\".asset\");}", # nolint
    expected
  )

  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
