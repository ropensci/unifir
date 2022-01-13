test_that("import_asset adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  junk_string <- tempfile()
  file.create(junk_string)
  script <- import_asset(
    script = script,
    asset_path = junk_string
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
    "waiver" %in% class(script$props[[1]]$prop_file) ||
      file.exists(script$props[[1]]$prop_file)
  )

  expect_match(
    script$props[[1]]$method_type,
    script$beats[1, ]$type
  )

  # Function-specific tests

  expect_identical(
    script$props[[1]]$parameters,
    list(asset_path = junk_string)
  )

  expect_identical(
    script$using,
    character(0)
  )

  expect_identical(
    script$beats[1, ]$name,
    junk_string
  )

  expect_identical(
    script$beats[1, ]$type,
    "ImportAsset"
  )

  rm(script)
})

test_that("import_asset actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  junk_string <- tempfile()
  file.create(junk_string)
  script <- import_asset(
    script = script,
    asset_path = junk_string
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[1]]), actual)
  writeLines(gsub(" |\\n|\\r", "", "\n"), expected)

  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
