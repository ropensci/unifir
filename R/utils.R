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

#' Add a prop to a unifir script
#'
#' @param script A script object (from [make_script]) to append the prop to.
#' @param prop A [unifir_prop] object to add to the script
#' @param exec Logical: Should the method created by the prop be called in the
#' MainFunc method?
#'
#' @export
add_prop <- function(script, prop, exec = TRUE) {
  stopifnot(is.logical(exec))

  idx <- nrow(script$beats) + 1

  script$props[[idx]] <- prop

  script$beats[idx, ]$idx <- idx
  script$beats[idx, ]$name <- prop$method_name
  script$beats[idx, ]$type <- prop$method_type
  script$beats[idx, ]$exec <- exec
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
#' @export
waiver <- function() structure(list(), class = "waiver")
