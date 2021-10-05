#' Print the version of the Unity Editor in use.
#'
#' @inheritParams create_unity_project
#'
#' @export
unity_version <- function(unity = NULL) {
  if (is.null(unity)) unity <- find_unity()
  system(paste(unity, "-version"), intern = TRUE)
}

current_call <- new.env(parent = emptyenv())

#' @export
detail_current_call <- function() {
   current_call
}
