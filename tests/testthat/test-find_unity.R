test_that("find_unity respects options", {
  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)

  options("unifir_unity_path" = "junk_string")
  expect_match(
    find_unity(check_path = FALSE),
    "junk_string"
  )

  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)
})

test_that("find_unity respects environment variables", {
  Sys.setenv("unifir_unity_path" = "junk_string")
  options("unifir_unity_path" = NULL)
  expect_match(
    find_unity(check_path = FALSE),
    "junk_string"
  )

  options("unifir_unity_path" = "other_string")
  expect_match(
    find_unity(check_path = FALSE),
    "junk_string"
  )

  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)
})

test_that("find_unity respects arguments", {
  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)
  expect_match(
    find_unity(unity = "junk_string", check_path = FALSE),
    "junk_string"
  )

  options("unifir_unity_path" = "other_string")
  expect_match(
    find_unity(unity = "junk_string", check_path = FALSE),
    "junk_string"
  )

  Sys.setenv("unifir_unity_path" = "another_string")
  expect_match(
    find_unity(unity = "junk_string", check_path = FALSE),
    "junk_string"
  )

  options("unifir_unity_path" = NULL)
  expect_match(
    find_unity(unity = "junk_string", check_path = FALSE),
    "junk_string"
  )

  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)
})

test_that("find_unity behaves as expected when (not) checking paths", {
  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)

  tryCatch(
    {
      invisible(find_unity())
    },
    error = function(e) {
      expect_error(
        find_unity(),
        "Couldn't find Unity executable at provided path. \\nPlease make sure the path provided to 'unity' is correct."
      )
    }
  )

  expect_error(
    find_unity(check_path = FALSE),
    NA
  )

  Sys.setenv("unifir_unity_path" = "")
  options("unifir_unity_path" = NULL)
})
