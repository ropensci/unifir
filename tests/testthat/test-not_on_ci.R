test_that("skipped test", {
  skip_on_ci()
  skip_on_cran()
  Sys.setenv("unifir_debugmode" = "")
})
