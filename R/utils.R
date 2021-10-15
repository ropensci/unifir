#' Print the version of the Unity Editor in use.
#'
#' @inheritParams create_unity_project
#'
#' @export
unity_version <- function(unity = NULL) {
  if (is.null(unity)) unity <- find_unity()
  system(paste(unity, "-version"), intern = TRUE)
}


create_if_not <- function(path, recur = FALSE) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = recur)
  }
}

add_prop <- function(script, prop) {

  idx <- nrow(script$beats) + 1

  script$props[[idx]] <- prop

  script$beats[idx, ]$idx <- idx
  script$beats[idx, ]$name <- prop$method_name
  script$beats[idx, ]$type <- prop$method_type
  script$using <- c(script$using, prop$using)
  script

}

#' A waiver object.
#'
#' This function is borrowed from ggplot2. It creates a "flag" object indicating
#' that a value has been intentionally left blank (because it will be filled in
#' by something else). Often, a function argument being missing or `NULL` will
#' result in an error, while passing `waiver()` will cause the function to look
#' elsewhere in the script for an acceptable value.
#'
#' @references H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
#'
#' @examples
#' waiver()
#'
#' @export
waiver <- function() structure(list(), class = "waiver")
