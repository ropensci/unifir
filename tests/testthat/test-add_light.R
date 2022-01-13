test_that("add_light adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- add_light(
    script = script,
    method_name = "LightTest"
  )

  # Generic prop tests

  expect_equal(
    nrow(script$beats),
    1
  )

  expect_equal(
    length(script$props),
    1
  )

  expect_identical(
    script$using,
    script$props[[1]]$using
  )

  expect_true(
    script$beats[1, ]$exec
  )

  expect_true(
    file.exists(script$props[[1]]$prop_file) ||
      "waiver" %in% class(script$props[[1]]$prop_file)
  )

  expect_match(
    script$props[[1]]$method_name,
    script$beats[1, ]$name
  )

  expect_match(
    script$props[[1]]$method_type,
    script$beats[1, ]$type
  )

  # Function-specific tests

  expect_identical(
    script$props[[1]]$parameters,
    list(
      light_name = "Light",
      light_type = "Directional",
      x_position = 0,
      y_position = 0,
      z_position = 0,
      x_scale = 1,
      y_scale = 1,
      z_scale = 1,
      x_rotation = 50,
      y_rotation = -30,
      z_rotation = 0
    )
  )

  expect_identical(
    script$using,
    c("UnityEngine")
  )

  expect_identical(
    script$beats[1, ]$name,
    "LightTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "InstantiatePrefab"
  )

  rm(script)
})

test_that("add_light actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- add_light(
    script = script,
    method_name = "LightTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[1]]), actual)
  writeLines(
    gsub(" |\\n|\\r", "", "     static void LightTest()\n     {\n        GameObject lightGameObject = new GameObject(\"Light\");\n        lightGameObject.transform.position = new Vector3(0, 0, 0);\n        lightGameObject.transform.localScale = new Vector3(1, 1, 1);\n        lightGameObject.transform.eulerAngles = new Vector3(50, -30, 0);\n\n        Light lightComp = lightGameObject.AddComponent<Light>();\n        lightComp.type = LightType.Directional;\n     }\n"), # nolint
    expected
  )


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
