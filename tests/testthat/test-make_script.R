test_that("make_script always produces the same script", {
  example_script <- make_script(
    project = "test_project",
    script_name = "test_script",
    scene_name = "test_scene",
    unity = find_unity("junk_string", FALSE),
    initialize_project = NULL
  )

  expect_match(
    class(example_script),
    "unifir_script"
  )

  saved_script <- readRDS("testdata/example_script.rds")

  expect_identical(
    names(example_script),
    names(saved_script)
  )

  expect_identical(
    names(example_script$beats),
    names(saved_script$beats)
  )

  expect_equal(
    nrow(example_script$beats),
    0
  )

  expect_true(
    is.null(example_script$initialize_project)
  )

  expect_match(
    example_script$project,
    "test_project"
  )

  expect_identical(
    example_script$props,
    list()
  )

  expect_false(
    example_script$scene_exists
  )

  expect_false(
    example_script$scene_exists
  )

  expect_identical(
    example_script$scene_name,
    "test_scene"
  )

  expect_identical(
    example_script$script_name,
    "test_script"
  )

  expect_identical(
    example_script$unity,
    saved_script$unity
  )

  expect_identical(
    example_script$using,
    character(0)
  )

  rm(example_script, saved_script)
})

test_that("initalize methods are stable", {
  skip_on_covr()

  example_script <- make_script(
    project = "test_project",
    script_name = "test_script",
    scene_name = "test_scene",
    unity = find_unity("junk_string", FALSE),
    initialize_project = NULL
  )

  saved_script <- readRDS("testdata/example_script.rds")

  example_init <- example_script$initialize
  saved_init <- saved_script$initialize
  environment(example_init) <- environment(saved_init) <- environment()
  expect_identical(
    example_init,
    saved_init
  )
  rm(example_init, saved_init)

})
