test_that("validate_path adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- validate_path(
    script = script,
    method_name = "ValidPath"
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
    c("System", "System.IO")
  )

  expect_identical(
    script$beats[1, ]$name,
    "ValidPath"
  )

  expect_identical(
    script$beats[1, ]$type,
    "ValidatePath"
  )

  rm(script)
})

test_that("validate_single_path actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- validate_path(
    script = script,
    method_name = "ValidPath"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[1]]), actual)
  writeLines(
    gsub(" |\\n|\\r", "", "    static void ValidPath(string file_path) {\n        if(File.Exists(file_path) == false){\n            throw new ArgumentException(\"Could not find file: \" + file_path);\n        }\n    }\n"), # nolint
    expected
  )


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})

test_that("validate_single_path adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- validate_single_path(
    script = script,
    path = "junk_string",
    method_name = "ValidSinglePath"
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
    list(path = "junk_string")
  )

  expect_identical(
    script$using,
    c("System", "System.IO")
  )

  expect_identical(
    script$beats[1, ]$name,
    "ValidSinglePath"
  )

  expect_identical(
    script$beats[1, ]$type,
    "ValidateSinglePath"
  )

  rm(script)
})

test_that("validate_single_path actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- validate_single_path(
    script = script,
    path = "junk_string",
    method_name = "InstantTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[1]]), actual)
  writeLines(
    gsub(" |\\n|\\r", "", "    static void InstantTest() {\n        if(File.Exists(\"junk_string\") == false){\n            throw new ArgumentException(\"Could not find file: junk_string\");\n        }\n    }\n"), # nolint
    expected
  )


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
