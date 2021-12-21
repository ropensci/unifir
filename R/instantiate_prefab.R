#' Add a prefab to a Unity scene
#'
#' @inheritParams new_scene
#' @param prefab_path File path to the prefab to be instantiated. This should
#' be relative to the Unity project root directory, and likely begins with
#' "Assets".
#' @param destination_scene Optionally, the scene to instantiate the prefabs
#' in. Ignored if NULL, the default.
#' @param x_position,y_position,z_position The position of the GameObject in
#' world space.
#' @param x_scale,y_scale,z_scale The scale of the GameObject (relative to its
#' parent object).
#' @param x_rotation,y_rotation,z_rotation The rotation of the GameObject to
#' create, as Euler angles.
#'
#' @export
instantiate_prefab <- function(script,
                               method_name = NULL,
                               prefab_path,
                               destination_scene = NULL,
                               x_position = 0,
                               y_position = 0,
                               z_position = 0,
                               x_scale = 1,
                               y_scale = 1,
                               z_scale = 1,
                               x_rotation = 0,
                               y_rotation = 0,
                               z_rotation = 0,
                               exec = TRUE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(n = 1,
                                                       n_words = 4,
                                                       sep = '',
                                                       case = "title")
  }

  if (!is.null(destination_scene)) {
    destination_scene <- paste0(", ", destination_scene)
  } else {
    destination_scene <- ""
  }

  prop <- unifir_prop(
    prop_file = system.file("InstantiatePrefab.cs", package = "unifir"),
    method_name = method_name,
    method_type = "InstantiatePrefab",
    parameters = list(
      prefab_path = prefab_path,
      destination_scene = destination_scene,
      x_position = x_position,
      y_position = y_position,
      z_position = z_position,
      x_scale = x_scale,
      y_scale = y_scale,
      z_scale = z_scale,
      x_rotation = x_rotation,
      y_rotation = y_rotation,
      z_rotation = z_rotation
    ),
    build = function(script, prop) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        prefab_path = prop$parameters$prefab_path,
        destination_scene = prop$parameters$destination_scene,
        x_position = prop$parameters$x_position,
        y_position = prop$parameters$y_position,
        z_position = prop$parameters$z_position,
        x_scale = prop$parameters$x_scale,
        y_scale = prop$parameters$y_scale,
        z_scale = prop$parameters$z_scale,
        x_rotation = prop$parameters$x_rotation,
        y_rotation = prop$parameters$y_rotation,
        z_rotation = prop$parameters$z_rotation
      )
    },
    using = c("System", "System.IO", "UnityEngine")
  )

  add_prop(script, prop, exec)
}
