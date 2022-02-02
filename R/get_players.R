#' Download prefabs for Unity
#'
#' This is a simple helper function downloading the assets stored at
#' https://github.com/mikemahoney218/unity_assets .
#'
#' @param asset The asset to download. Available asset names are provided in
#' [available_assets].
#' @param directory Optionally, the directory to extract the downloaded models
#' in. If NULL, the default, saves to `tools::R_user_dir("unifir")`.
#'
#' @family utilities
#'
#' @examples
#'
#' if (interactive()) {
#'   get_asset(asset = "tree_1", directory = tempdir())
#'   get_players(directory = tempdir())
#' }
#'
#' @rdname get_asset
#' @export
get_asset <- function(asset, directory = NULL) {

  if (!(asset %in% available_assets)) {
    stop(
      "Asset must be one of: ",
      paste0(available_assets, collapse = ", ")
    )
  }

  if (is.null(directory)) {
    directory <- tools::R_user_dir("unifir")
  }
  create_if_not(directory, TRUE)
  stopifnot(dir.exists(directory))

  dl <- tempfile(fileext = ".zip")
  utils::download.file(
    paste0(
      "https://github.com/mikemahoney218/unity_assets/archive/refs/heads/",
      asset,
      ".zip"
    ),
    dl
  )
  utils::unzip(
    dl,
    exdir = directory
  )

}
