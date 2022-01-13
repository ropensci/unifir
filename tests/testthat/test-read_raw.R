test_that("read_raw adds a prop as expected", {
  script <- readRDS("testdata/example_script.rds")
  script <- read_raw(
    script = script,
    method_name = "RawTest"
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
    "RawTest"
  )

  expect_identical(
    script$beats[1, ]$type,
    "ReadRaw"
  )

  rm(script)
})

test_that("read_raw actions as expected", {
  Sys.setenv("unifir_debugmode" = "true")
  script <- readRDS("testdata/example_script.rds")
  script <- read_raw(
    script = script,
    method_name = "RawTest"
  )

  outcome <- action(script)

  actual <- tempfile()
  expected <- tempfile()

  writeLines(gsub(" |\\n|\\r", "", outcome$props[[1]]), actual)
  writeLines(
    gsub(" |\\n|\\r", "", "    static float[,] RawTest(string path, int heightmapResolution)\n    {\n        byte[] data;\n        using (BinaryReader br = new BinaryReader(File.Open(path, FileMode.Open, FileAccess.Read)))\n        {\n            data = br.ReadBytes(heightmapResolution * heightmapResolution * (int)2);\n            br.Close();\n        }\n\n        float[,] heights = new float[heightmapResolution, heightmapResolution];\n\n            float normalize = 1.0F / (1 << 16);\n            for (int y = 0; y < heightmapResolution; ++y)\n            {\n                for (int x = 0; x < heightmapResolution; ++x)\n                {\n                    int index = Mathf.Clamp(x, 0, heightmapResolution - 1) + Mathf.Clamp(y, 0, heightmapResolution - 1) * heightmapResolution;\n                    ushort compressedHeight = System.BitConverter.ToUInt16(data, index * 2);\n                    float height = compressedHeight * normalize;\n                    heights[y, x] = height;\n                }\n            }\n\n        return heights;\n    }\n"), # nolint
    expected
  )


  expect_identical(
    readLines(actual),
    readLines(expected)
  )

  rm(script, outcome)
})
