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
