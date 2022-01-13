test_that("get_players gets players", {
  skip_on_cran()
  players_dir <- file.path(tempdir(), "players")
  get_players(players_dir)
  expect_true(dir.exists(file.path(players_dir, "TheFirstPerson-master")))
})
