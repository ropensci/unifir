#' Find the Unity executable on a machine.
#'
#' If the path to Unity is not provided to a function, this function is invoked
#' to attempt to find it. To do so, it goes through the following steps:
#'
#' 1. Attempt to load the "unifir_unity_path" environment variable.
#' 2. Attempt to load the "unifir_unity_path" option.
#'
#' @export
find_unity <- function(unity = NULL) {

  if (is.null(unity)) unity <- Sys.getenv("unifir_unity_path")

  if (unity == '') unity <- options("unifir_unity_path")[[1]]

  # Check OS standard locations...
  if (is.null(unity) || !file.exists(unity)) {
    sysname <- tolower(Sys.info()[["sysname"]])
    if ("windows" == sysname) {
      if (dir.exists("C:\\Program Files\\Unity\\Hub\\Editor")) {
        unity <- utils::tail(
          list.files("C:\\Program Files\\Unity\\Hub\\Editor",
                     full.names = TRUE),
          1)
        unity <- paste0(unity, "\\Editor\\Unity.exe")
      }
    }

    if ("linux" == sysname) {
      if (dir.exists("~/Unity/Hub/Editor")) {
        unity <- utils::tail(list.files("~/Unity/Hub/Editor", full.names = TRUE), 1)
        unity <- paste0(unity, "/Editor/Unity")
      }
    }

    if ("darwin" == sysname) {
      if (dir.exists("/Applications/Unity/Hub/Editor")) {
        # This works on at least one Mac
        unity <- utils::tail(
          list.files("/Applications/Unity/Hub/Editor", full.names = TRUE),
          1
        )
        unity <- paste0(unity, "Unity.app/Contents/MacOS/Unity")
      }
    }
  }

  if (is.null(unity) || !file.exists(unity)) {
    stop("Couldn't find Unity executable at provided path. \n",
         "Please make sure the path provided to 'unity' is correct.")
  }

  if (!grepl("^\"", unity)) unity <- paste0('"', unity)
  if (!grepl("\"$", unity)) unity <- paste0(unity, '"')

  if (Sys.getenv("unifir_unity_path") == '') {
    Sys.setenv("unifir_unity_path" = unity)
  }

  unity
}
