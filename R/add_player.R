#' Add default player
#'
#' This function adds "player" controllers to a Unity scene. It is
#' in effect a thin wrapper across `instantiate_prefab` to add a
#' pre-defined player object to a specific location in a scene;
#' however, this function will first download the player prefab if
#' necessary and handles the default file paths.
#'
#' @inheritParams instantiate_prefab
#' @inheritParams import_asset
#' @param controller Which controller to use? `Player`, the default,
#' is a simple first-person controller. `FootstepsPlayer` adds footsteps
#' to this controller, while `JetpackPlayer` adds a "jetpack" with limited
#' fuel. `Third Person` lets you control a small cylinder in third person.
#' @param player_path The path to which the default player should be saved.
#' Defaults to `tools::R_user_dir("unifir")`.
#'
#' @family props
#' @family utilities
#'
#' @export
add_default_player <- function(script,
                               controller = c("Player",
                                              "FootstepsPlayer",
                                              "JetpackPlayer",
                                              "Third Person"),
                               player_path = NULL,
                               lazy = TRUE,
                               method_name = NULL,
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

  controller <- controller[[1]]
  stopifnot(controller %in% c("Player",
                              "FootstepsPlayer",
                              "JetpackPlayer",
                              "Third Person"))
  controller <- paste0(controller, ".prefab")

  if (is.null(player_path)) {
    player_path <- tools::R_user_dir("unifir")
  }

  if (!dir.exists(file.path(player_path, "TheFirstPerson-master"))) {
    get_players(player_path)
  }

  script <- import_asset(
    script = script,
    asset_path = file.path(player_path, "TheFirstPerson-master", "Assets", "TheFirstPerson"),
    lazy = lazy
  )

  instantiate_prefab(
    script,
    method_name = method_name,
    destination_scene = destination_scene,
    prefab_path = file.path("Assets", "TheFirstPerson", "Prefabs", controller),
    x_position = x_position,
    y_position = y_position,
    z_position = z_position,
    x_scale = x_scale,
    y_scale = y_scale,
    z_scale = z_scale,
    x_rotation = x_rotation,
    y_rotation = y_rotation,
    z_rotation = z_rotation,
    exec = exec
  )
}
