test_that("add_texture adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- add_texture(
    script = script,
    method_name = "TextureTest"
  )

  # Generic prop tests

  expect_equal(
    nrow(script$beats),
    2
  )

  expect_equal(
    length(script$props),
    2
  )

  expect_identical(
    unique(script$using),
    script$props[[2]]$using
  )

  expect_false(
    script$beats[2, ]$exec
  )

  expect_true(
    file.exists(script$props[[2]]$prop_file) ||
      "waiver" %in% class(script$props[[2]]$prop_file)
  )

  expect_match(
    script$props[[2]]$method_name,
    script$beats[2, ]$name
  )

  expect_match(
    script$props[[2]]$method_type,
    script$beats[2, ]$type
  )

  # Function-specific tests

  expect_identical(
    script$props[[2]]$parameters,
    list(loadpng_method = "LoadPNGAutoAdd")
  )

  expect_identical(
    unique(script$using),
    c("System", "System.IO", "UnityEngine")
  )

  expect_identical(
    script$beats[2, ]$name,
    "TextureTest"
  )

  expect_identical(
    script$beats[2, ]$type,
    "AddTexture"
  )

  expect_identical(
    script$props[[1]]$parameters,
    list()
  )

  expect_identical(
    script$beats[1, ]$name,
    script$props[[2]]$parameters$loadpng_method
  )

  expect_identical(
    script$beats[1, ]$type,
    "LoadPNG"
  )

  rm(script)
})

test_that("add_texture actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- add_texture(
    script = script,
    method_name = "TextureTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[2]]), actual)
  writeLines(
    gsub(" |\\n|\\r", "", "    static void TextureTest(string path, TerrainData terrainData, float width, float length)\n    {\n        Texture2D texture = LoadPNGAutoAdd(path);\n        AssetDatabase.CreateAsset(texture, \"Assets/texture_\" + path + \".asset\");\n        TerrainLayer overlay = new TerrainLayer();\n        overlay.tileSize = new Vector2(width, length);\n        overlay.diffuseTexture = texture;\n        AssetDatabase.CreateAsset(overlay, \"Assets/overlay_\" + path + \".asset\");\n        var layers = terrainData.terrainLayers;\n        int newIndex = layers.Length;\n        var newarray = new TerrainLayer[newIndex + 1];\n        Array.Copy(layers, 0, newarray, 0, newIndex);\n        newarray[newIndex] = overlay;\n        terrainData.SetTerrainLayersRegisterUndo(newarray, \"Add terrain layer\");\n    }\n"), # nolint
    expected
  )


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
