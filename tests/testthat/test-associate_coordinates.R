test_that("associate_coordinates is stable", {
  expect_identical(
    associate_coordinates(
      sf::st_as_sf(data.frame(x = 5, y = 5), coords = c("x", "y"), crs = "EPSG:5071"),
      terra::rast(matrix(data = rep(1, 100), nrow = 10), crs = "EPSG:5071")
    ),
    data.frame(X = 4092, Y = 5, row.names = "1")
  )
})
