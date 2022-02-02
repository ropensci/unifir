test_that("get_asset gets assets", {
  skip_on_cran()
  players_dir <- file.path(tempdir(), "players")
  get_asset("default_cameras", players_dir)
  expect_true(dir.exists(file.path(players_dir, "unity_assets-default_cameras")))
})
