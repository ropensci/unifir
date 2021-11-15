#' Add a prefab to a Unity scene
#'
#' @inheritParams new_scene
#'
#' @export
instantiate_prefab <- function(script,
                               data,
                               method_name = NULL,
                               prefab_path,
                               import_prefab = FALSE,
                               scene_argument = NULL,
                               x_position,
                               y_position,
                               z_position,
                               x_rotation,
                               y_rotation,
                               z_rotation,
                               exec = TRUE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(n = 1,
                                                       n_words = 2,
                                                       sep = '',
                                                       case = "title")
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
