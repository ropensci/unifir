#' Create directory if it doesn't exist
#'
#' @param path The path to be created
#' @param recur Boolean: create directories recursively?
create_if_not <- function(path, recur = FALSE) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = recur)
  }
}

#' Check if unifir should run in debug mode
#'
#' When running in debug mode, unifir will write nothing to disk.
check_debug <- function() {
  debug <- FALSE
  if (Sys.getenv("unifir_debugmode") != "" ||
    !is.null(options("unifir_debugmode")$unifir_debugmode)) {
    debug <- TRUE
  }
  debug
}
