#' Add a Texture2D layer to a terrain tile object
#'
#' @inheritParams new_scene
#'
#' @export
add_texture <- function(script,
                        method_name = NULL,
                        exec = FALSE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(n = 1,
                                                       n_words = 2,
                                                       sep = '',
                                                       case = "title")
  }

  if (any(script$beats$type == "LoadPNG")) {
    loadpng_method <- utils::head(script$beats[script$beats$type == "LoadPNG", ]$name, 1)
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
    build = function(script, prop) {
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
