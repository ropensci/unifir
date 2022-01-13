test_that("instantiate_prefab adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- instantiate_prefab(
    script = script,
    prefab_path = "junk_string",
    method_name = "InstantTest"
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
      destination_scene = "",
      arguments = data.frame(
        prefab_path = "junk_string",
        x_position = 0,
        y_position = 0,
        z_position = 0,
        x_scale = 1,
        y_scale = 1,
        z_scale = 1,
        x_rotation = 0,
        y_rotation = 0,
        z_rotation = 0
      )
    )
  )

  expect_identical(
    script$using,
    c("System", "System.IO", "System.Collections", "System.Collections.Generic", "UnityEngine")
  )

  expect_identical(
    script$beats[1, ]$name,
    "InstantTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "InstantiatePrefab"
  )

  rm(script)
})

test_that("instantiate_prefab actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- instantiate_prefab(
    script = script,
    prefab_path = "junk_string",
    method_name = "InstantTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(outcome$props[[1]], actual)
  writeLines("     static void InstantTest()\n     {\n          using (StreamReader reader = new StreamReader(\"InstantTest.manifest\"))\n          {\n               string line;\n               while ((line = reader.ReadLine()) != null)\n               {\n               string[] fields = line.Split('\\t');\n               GameObject go = (GameObject)AssetDatabase.LoadAssetAtPath(fields[0], typeof(GameObject));\n               go = (GameObject)PrefabUtility.InstantiatePrefab(go); // second argument: scene\n               go.transform.position = new Vector3(float.Parse(fields[1]), float.Parse(fields[2]), float.Parse(fields[3]));\n               go.transform.localScale = new Vector3(float.Parse(fields[4]), float.Parse(fields[5]), float.Parse(fields[6]));\n               go.transform.eulerAngles = new Vector3(float.Parse(fields[7]), float.Parse(fields[8]), float.Parse(fields[9]));\n               }\n          }\n     }\n", # nolint
             expected)


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)

})
