test_that("associate_coordinates is stable", {
  # This test fails on M1 macs, likely due to terra failing on M1 macs.
  # Being not in the possession of M1 macs nor the ability to fix terra,
  # I am temporarily skipping this test until one of those things changes
  skip_on_os(os = "mac", arch = "aarch64")
  out <- associate_coordinates(
      sf::st_as_sf(data.frame(x = 5, y = 5), coords = c("x", "y"), crs = "EPSG:5071"),
      terra::rast(matrix(data = rep(1, 100), nrow = 10), crs = "EPSG:5071")
    )

  expect_equal(out$X, 4092)
  expect_equal(out$Y, 5)
})
