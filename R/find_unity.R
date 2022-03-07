#' Find the Unity executable on a machine.
#'
#' If the path to Unity is not provided to a function, this function is invoked
#' to attempt to find it. To do so, it goes through the following steps:
#'
#' 1. Attempt to load the "unifir_unity_path" environment variable.
#' 2. Attempt to load the "unifir_unity_path" option.
#'
#' @param unity Character: If provided, this function will quote the provided
#' string (if necessary) and return it.
#' @param check_path Logical: If `TRUE`, this function will check if the Unity
#' executable provided as an argument, environment variable, or option exists.
#' If it does not, this function will then attempt to find one, and will error
#' if not found. If `FALSE`, this function will never error.
#'
#' @examples
#' if (interactive()) {
#'   try(find_unity())
#' }
#' @family utilities
#'
#' @export
find_unity <- function(unity = NULL, check_path = TRUE) {
  if (is.null(unity)) unity <- Sys.getenv("unifir_unity_path")

  if (unity == "") unity <- options("unifir_unity_path")[[1]]

  # Check OS standard locations...
  if (is.null(unity) || (check_path && !file.exists(unity))) {
    sysname <- tolower(Sys.info()[["sysname"]])

    unity <- switch(sysname,
      "windows" = windows_locations(),
      "linux" = linux_locations(),
      "darwin" = mac_locations(),
      NULL
    )
  }

  if (is.null(unity) || (check_path && !file.exists(unity))) {
    stop(
      "Couldn't find Unity executable at provided path. \n",
      "Please make sure the path provided to 'unity' is correct."
    )
  }

  unity <- quote_string(unity)

  if (Sys.getenv("unifir_unity_path") == "") {
    Sys.setenv("unifir_unity_path" = unity)
  }

  unity
}

windows_locations <- function() {
  if (dir.exists("C:\\Program Files\\Unity\\Hub\\Editor")) {
    unity <- utils::tail(
      list.files("C:\\Program Files\\Unity\\Hub\\Editor",
        full.names = TRUE
      ),
      1
    )
    paste0(unity, "\\Editor\\Unity.exe")
  }
}

linux_locations <- function() {
  if (dir.exists("~/Unity/Hub/Editor")) {
    unity <- utils::tail(
      list.files("~/Unity/Hub/Editor", full.names = TRUE),
      1
    )
    paste0(unity, "/Editor/Unity")
  }
}

mac_locations <- function() {
  if (dir.exists("/Applications/Unity/Hub/Editor")) {
    # This works on at least one Mac
    unity <- utils::tail(
      list.files("/Applications/Unity/Hub/Editor", full.names = TRUE),
      1
    )
    paste0(unity, "Unity.app/Contents/MacOS/Unity")
  }
}

quote_string <- function(string) {
  if (!grepl("^\"", string)) string <- paste0('"', string)
  if (!grepl("\"$", string)) string <- paste0(string, '"')
}
