#' Add a Texture2D layer to a terrain tile object
#'
#' This function adds a helper method, `AddTexture`, to the
#' C# script. This function is typically used to add textures to
#' heightmaps in a Unity scene, for instance by functions
#' like `create_terrain`. It requires some arguments be provided
#' at the C# level, and so is almost always called with `exec = FALSE`.
#'
#' @inheritParams new_scene
#'
#' @family props
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'   unity = waiver()
#' )
#'
#' # Now add props:
#' script <- add_texture(script)
#'
#' # Lastly, execute the script via the `action` function
#' @export
add_texture <- function(script,
                        method_name = NULL,
                        exec = FALSE) {
  if (any(script$beats$type == "LoadPNG")) {
    loadpng_method <- utils::head(
      script$beats[script$beats$type == "LoadPNG", ]$name,
      1
    )
  } else {
    loadpng_method <- "LoadPNGAutoAdd"
    script <- load_png(script, loadpng_method, exec = FALSE)
  }

  prop <- unifir_prop(
    prop_file = system.file("AddTexture.cs", package = "unifir"),
    method_name = method_name,
    method_type = "AddTexture",
    parameters = list(
      loadpng_method = loadpng_method
    ),
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        loadpng_method = prop$parameters$loadpng_method
      )
    },
    using = c("System", "System.IO", "UnityEngine")
  )

  add_prop(script, prop, exec)
}
