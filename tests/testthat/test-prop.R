test_that("unifir_prop generates method names", {
  expect_warning(
    unifir_prop(
      prop_file = waiver(),
      method_name = NULL,
      method_type = "TestMethod",
      parameters = list(),
      build = function(script, prop, debug) {},
      using = character(0)
    ),
    NA
  )
})
