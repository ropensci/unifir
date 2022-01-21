#' Create a new Unity project.
#'
#' @param path The path to create a new Unity project at.
#' @param quit Logical: quit Unity after creating the project?
#' @param unity The path to the Unity executable on your system (importantly,
#' _not_ the UnityHub executable). If `NULL`, checks to see if the environment
#' variable or option `unifir_unity_path` is set; if so, uses that path
#' (preferring the environment variable over the option if the two disagree).
#'
#' @family utilities
#'
#' @return TRUE, invisibly.
#'
#' @examples
#' \donttest{
#'
#' if (interactive()) create_unity_project(file.path(tempdir(), "project"))
#'
#' }
#'
#' @export
# nocov start
# This function is not included in codecov metrics because it only runs when
# Unity is installed, which it is not on CRAN or on GitHub Actions CI.
# This function is tested in test-not_on_ci.R.
create_unity_project <- function(path,
                                 quit = TRUE,
                                 unity = NULL) {
  if (is.null(unity)) {
    unity <- find_unity()
  }

  output <- system(
    paste0(
      unity,
      " -batchmode",
      if (quit) " -quit",
      " -createProject ",
      path
    )
  )

  if (output != "0") stop(output)
  invisible(TRUE)
}
# nocov end
