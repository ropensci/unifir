test_that("new_scene adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- new_scene(
    script = script,
    method_name = "NewSceneTest"
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
      setup = "EmptyScene",
      mode = "Additive"
    )
  )

  expect_identical(
    script$using,
    c("UnityEngine.SceneManagement", "UnityEditor", "UnityEditor.SceneManagement")
  )

  expect_identical(
    script$beats[1, ]$name,
    "NewSceneTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "NewScene"
  )

  rm(script)
})

test_that("new_scene actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- new_scene(
    script = script,
    method_name = "NewSceneTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" ", "", outcome$props[[1]]), actual)
  writeLines(gsub(" ", "", "    static void NewSceneTest() {\n        var newScene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Additive);\n    }\n"), # nolint
             expected)


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)

})

test_that("load_scene adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- load_scene(
    script = script,
    scene_name = "junk_string",
    method_name = "LoadSceneTest"
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
      scene_name = "junk_string"
    )
  )

  expect_identical(
    script$using,
    c("UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  )

  expect_identical(
    script$beats[1, ]$name,
    "LoadSceneTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "LoadScene"
  )

  rm(script)
})

test_that("load_scene actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- load_scene(
    script = script,
    scene_name = "junk_string",
    method_name = "LoadSceneTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" ", "", outcome$props[[1]]), actual)
  writeLines(gsub(" ", "", "    static void LoadSceneTest() {\n        EditorSceneManager.OpenScene(\"Assets/Scenes/junk_string.unity\");\n    }\n"), # nolint
             expected)


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)

})

test_that("save_scene adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- save_scene(
    script = script,
    scene_name = "junk_string",
    method_name = "SaveTest"
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
      scene_name = "junk_string"
    )
  )

  expect_identical(
    script$using,
    c("UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  )

  expect_identical(
    script$beats[1, ]$name,
    "SaveTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "SaveScene"
  )

  rm(script)
})

test_that("save_scene actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- save_scene(
    script = script,
    scene_name = "junk_string",
    method_name = "SceneTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" ", "", outcome$props[[1]]), actual)
  writeLines(gsub(" ", "", "    static void SceneTest() {\n        bool saveOK = EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene(), \"Assets/Scenes/junk_string.unity\");\n    }\n"), # nolint
             expected)


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)

})

test_that("set_active_scene adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- set_active_scene(
    script = script,
    scene_name = "junk_string",
    method_name = "SetActiveTest"
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
    "waiver" %in% class(script$props[[1]]$prop_file) ||
      file.exists(script$props[[1]]$prop_file)
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
      scene_name = "junk_string"
    )
  )

  expect_identical(
    script$using,
    c("UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  )

  expect_identical(
    script$beats[1, ]$name,
    "SetActiveTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "SetActiveScene"
  )

  rm(script)
})

test_that("set_active_scene actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- set_active_scene(
    script = script,
    scene_name = "junk_string",
    method_name = "InstantTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" ", "", outcome$props[[1]]), actual)
  writeLines(gsub(" ", "", "\n"), # nolint
             expected)


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)

})

