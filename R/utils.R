#' Print the version of the Unity Editor in use.
#'
#' @inheritParams create_unity_project
#'
#' @examples
#' try(
#'   unity_version()
#' )
#'
#' @return A character vector of length 1
#' containing the version of Unity in use.
#'
#' @export
unity_version <- function(unity = NULL) {
  if (is.null(unity)) unity <- find_unity()
  system(paste(shQuote(unity), "-version"), intern = TRUE)
}

#' A waiver object.
#'
#' This function is borrowed from ggplot2. It creates a "flag" object indicating
#' that a value has been intentionally left blank (because it will be filled in
#' by something else). Often, a function argument being missing or `NULL` will
#' result in an error, while passing `waiver()` will cause the function to look
#' elsewhere in the script for an acceptable value.
#'
#' @family utilities
#'
#' @references H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
#'
#' @examples
#' waiver()
#'
#' @return An empty list of class `waiver`.
#'
#' @export
waiver <- function() structure(list(), class = "waiver")
