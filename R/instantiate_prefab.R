#' Add a prefab to a Unity scene
#'
#' This function creates objects (specifically, prefabs) within a Unity scene.
#' This function is vectorized over all functions from `prefab_path` through
#' `z_rotation`; to add multiple objects, simply provide vectors to each
#' argument. Note that all arguments will be automatically recycled if not the
#' same length; this may produce undesired results. This function is only
#' capable of altering a single scene at once -- call the function multiple
#' times if you need to manipulate multiple scenes.
#'
#' @inheritParams new_scene
#' @param destination_scene Optionally, the scene to instantiate the prefabs
#' in. Ignored if NULL, the default.
#' @param prefab_path File path to the prefab to be instantiated. This should
#' be relative to the Unity project root directory, and likely begins with
#' "Assets".
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
                               destination_scene = NULL,
                               prefab_path,
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
      destination_scene = destination_scene,
      arguments = data.frame(
        prefab_path = prefab_path,
        x_position = x_position,
        y_position = y_position,
        z_position = z_position,
        x_scale = x_scale,
        y_scale = y_scale,
        z_scale = z_scale,
        x_rotation = x_rotation,
        y_rotation = y_rotation,
        z_rotation = z_rotation
      )
    ),
    build = function(script, prop) {

      manifest_path <- file.path(
        script$project,
        paste0(
          prop$method_name,
          ".manifest"
        )
      )

      utils::write.table(
        prop$parameters$arguments,
        manifest_path,
        row.names = FALSE,
        col.names = FALSE,
        sep = "\t",
        quote = FALSE
      )

      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        destination_scene = prop$parameters$destination_scene,
        manifest_path = basename(manifest_path)
      )
    },
    using = c("System", "System.IO", "System.Collections", "System.Collections.Generic", "UnityEngine")
  )

  add_prop(script, prop, exec)
}
