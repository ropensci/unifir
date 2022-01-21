#' Read a RAW file in as a float array
#'
#' This function adds a helper method, `ReadRaw`, to the
#' C# script. This function is typically used to bring in
#' heightmaps into a Unity scene, for instance by functions
#' like `create_terrain`. It requires some arguments be provided
#' at the C# level, and so is almost always called with `exec = FALSE`.
#'
#' @inheritParams new_scene
#'
#' @family props
#' @family utilities
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'                       unity = waiver())
#'
#' # Now add props:
#' script <- read_raw(script)
#'
#' # Lastly, execute the script via the `action` function
#'
#' @export
read_raw <- function(script,
                     method_name = NULL,
                     exec = FALSE) {
  prop <- unifir_prop(
    prop_file = system.file("ReadRaw.cs", package = "unifir"),
    method_name = method_name,
    method_type = "ReadRaw",
    parameters = list(),
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
      )
    },
    using = c("System", "System.IO")
  )

  add_prop(script, prop, exec)
}
