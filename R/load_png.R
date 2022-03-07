#' Create a Texture2D from a PNG file
#'
#' This function adds a helper method, `LoadPNG`, to the
#' C# script. This function is typically used by other C# methods
#' to bring in textures into a Unity scene, for instance by functions
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
#'   unity = waiver()
#' )
#'
#' # Then add any number of props to it:
#' script <- load_png(script)
#'
#' # Then call `action` to execute the script!
#' @export
load_png <- function(script,
                     method_name = NULL,
                     exec = FALSE) {
  prop <- unifir_prop(
    prop_file = system.file("LoadPNG.cs", package = "unifir"),
    method_name = method_name,
    method_type = "LoadPNG",
    parameters = list(),
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
      )
    },
    using = c("System", "System.IO", "UnityEngine")
  )

  add_prop(script, prop, exec)
}
