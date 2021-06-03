#' Create a new Unity project.
#'
#' @param path The path to create a new Unity project at.
#' @param unity The path to the Unity executable on your system (importantly,
#' _not_ the UnityHub executable). If `NULL`, checks to see if the environment
#' variable or option `unifir_unity_path` is set; if so, uses that path
#' (preferring the environment variable over the option if the two disagree).
#'
#' @return TRUE, invisibly.
#'
#' @export
create_unity_project <- function(path,
                                 unity = NULL) {

  if (is.null(unity)) {
    unity <- find_unity()
  }

  output <- system(
    paste(
      unity,
      "-batchmode -quit -createProject",
      path
    )
  )

  if (output != "0") stop(output)
  invisible(TRUE)

}
