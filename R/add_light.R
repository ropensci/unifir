#' Add a light to a Unity scene
#'
#' This function creates light objects within a Unity scene. This function can
#' only add one light at a time -- call the function multiple times to add
#' more than one light.
#'
#' @param light_type One of "Directional", "Point", "Spot", or "Area". See
#' \url{https://docs.unity3d.com/Manual/Lighting.html} for more information.
#' @param light_name The name to assign the Light object.
#' @inheritParams instantiate_prefab
#'
#' @family props
#'
#' @export
add_light <- function(script,
                      light_type = c(
                        "Directional",
                        "Point",
                        "Spot",
                        "Area"
                      ),
                      method_name = NULL,
                      light_name = "Light",
                      x_position = 0,
                      y_position = 0,
                      z_position = 0,
                      x_scale = 1,
                      y_scale = 1,
                      z_scale = 1,
                      x_rotation = 50,
                      y_rotation = -30,
                      z_rotation = 0,
                      exec = TRUE) {
  light_type <- light_type[[1]]
  stopifnot(light_type %in% c(
    "Directional",
    "Point",
    "Spot",
    "Area"
  ))

  prop <- unifir_prop(
    prop_file = system.file("AddLight.cs", package = "unifir"),
    method_name = method_name,
    method_type = "InstantiatePrefab",
    parameters = list(
      light_name = light_name,
      light_type = light_type,
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
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        light_name = prop$parameters$light_name,
        light_type = prop$parameters$light_type,
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
    using = c("UnityEngine")
  )

  add_prop(script, prop, exec)
}
