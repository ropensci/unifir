#' Download player prefabs for Unity
#'
#' This is a simple helper function downloading the player prefabs stored at
#' https://github.com/boaheck/TheFirstPerson .
#'
#' @param directory Optionally, the directory to extract the downloaded models
#' in. If NULL, the default, saves to `tools::R_user_dir("unifir")`.
#'
#' @family utilities
#'
#' @export
get_players <- function(directory = NULL) {
  if (is.null(directory)) {
    directory <- tools::R_user_dir("unifir")
  }
  create_if_not(directory, TRUE)
  stopifnot(dir.exists(directory))

  dl <- tempfile(fileext = ".zip")
  utils::download.file(
    "https://github.com/boaheck/TheFirstPerson/archive/refs/heads/master.zip",
    dl
  )
  utils::unzip(
    dl,
    exdir = directory
  )
}
