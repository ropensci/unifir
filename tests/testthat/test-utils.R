test_that("create_if_not works", {

  # Test creating new
  expect_warning(
    create_if_not(
      file.path(tempdir(), "junk_directory")
    ),
    NA
  )

  # Test with existing
  expect_warning(
    create_if_not(
      file.path(tempdir(), "junk_directory")
    ),
    NA
  )

})
