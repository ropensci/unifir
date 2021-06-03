#' Find the Unity executable on a machine.
#'
#' If the path to Unity is not provided to a function, this function is invoked
#' to attempt to find it. To do so, it goes through the following steps:
#'
#' 1. Attempt to load the "unifir_unity_path" environment variable.
#' 2. Attempt to load the "unifir_unity_path" option.
#'
#' @export
find_unity <- function() {
  unity <- Sys.getenv("unifir_unity_path")

  if (unity == '') unity <- options("unifir_unity_path")

  if (is.null(unity) || !file.exists(unity)) {
    stop("Couldn't find Unity executable at provided path. \n",
         "Please make sure the path provided to 'unity' is correct.")
  }

  unity
}
