test_that("load_png adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- load_png(script = script, method_name = "LoadTest")

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

  expect_false(
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
    list()
  )

  expect_identical(
    script$using,
    c("System", "System.IO", "UnityEngine")
  )

  expect_identical(
    script$beats[1, ]$name,
    "LoadTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "LoadPNG"
  )

  rm(script)
})

test_that("load_png actions as expected", {

  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- load_png(script = script, method_name = "LoadTest")

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" ", "", outcome$props[[1]]), actual)
  writeLines(gsub(" ", "", "    private static Texture2D LoadTest(string imagePath){\n        Texture2D texture = null;\n        byte[] imgData;\n\n        imgData = File.ReadAllBytes(imagePath);\n        texture = new Texture2D(2, 2);\n        texture.LoadImage(imgData);\n\n        return texture;\n    }\n"), #nolint
             expected)


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
