test_that("action fails as expected", {
  Sys.setenv("unifir_debugmode" = "")
  expect_error(
    action("", write = FALSE, exec = TRUE),
    "Cannot execute script without writing it!"
  )
  # be very, very sure to not delete this:
  Sys.setenv("unifir_debugmode" = "true")
})

test_that("action will generate names as needed", {
  script <- readRDS("testdata/example_script.rds")

  script$scene_name <- NULL
  script$script_name <- NULL
  outcome <- action(script)

  expect_true(
    !is.null(script$scene_name)
  )

  expect_true(
    !is.null(script$script_name)
  )

  rm(script)
})

test_that("action will create project directories", {
  Sys.setenv("unifir_debugmode" = "")
  script <- readRDS("testdata/example_script.rds")

  script$project <- file.path(tempdir(), "unifir_test")
  script$initialize_project <- FALSE

  outcome <- action(script, exec = FALSE)

  expect_true(
    dir.exists(outcome$project)
  )

  expect_true(
    file.exists(file.path(script$project, "Assets", "Editor", paste0(script$script_name, ".cs")))
  )

  expect_true(
    dir.exists(file.path(script$project, "Assets", "Scenes"))
  )

  rm(script, outcome)

  # be very, very sure to not delete this:
  Sys.setenv("unifir_debugmode" = "true")
})
