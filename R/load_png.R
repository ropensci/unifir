#' Create a Texture2D from a PNG file
#'
#' @inheritParams new_scene
#'
#' @family props
#' @family utilities
#'
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
