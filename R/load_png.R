#' Create a Texture2D from a PNG file
#'
#' @inheritParams new_scene
#'
#' @export
load_png <- function(script,
                     method_name = NULL,
                     exec = FALSE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(
      n = 1,
      n_words = 2,
      sep = "",
      case = "title"
    )
  }

  prop <- unifir_prop(
    prop_file = system.file("LoadPNG.cs", package = "unifir"),
    method_name = method_name,
    method_type = "LoadPNG",
    parameters = list(),
    build = function(script, prop) {
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
