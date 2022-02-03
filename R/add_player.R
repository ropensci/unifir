#' Add assets to a Unity scene
#'
#' These functions add assets available at
#' https://github.com/mikemahoney218/unity_assets/
#' to a Unity scene.
#'
#' In effect, these functions provide a thin wrapper across `instantiate_prefab`
#' and `import_asset`. By providing the directory an asset is stored in, and the
#' path to the prefab file once that directory has been copied into Unity,
#' these files will add prefabs to specified locations throughout the scene.
#' This function will also download the necessary assets
#' and handles specifying file paths.
#'
#' `add_default_player` adds "player" controllers to a Unity scene.
#' `add_tree` adds tree GameObjects.
#'
#' @inheritParams instantiate_prefab
#' @inheritParams import_asset
#' @param controller Which controller to use. `Player`, the default,
#' is a simple first-person controller. `FootstepsPlayer` adds footsteps
#' to this controller, while `JetpackPlayer` adds a "jetpack" with limited
#' fuel. `Third Person` lets you control a small cylinder in third person.
#' @param tree Which tree to use. There are currently 12 generic tree objects
#' available, named "tree_1" through "tree_12". The number of a tree (1-12)
#' can be specified instead of the full name.
#' @param asset_directory A file path to the directory containing the asset,
#' or alternatively, to which the default assets should be saved.
#' Defaults to `tools::R_user_dir("unifir")`.
#'
#' @family props
#' @family utilities
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'                       unity = waiver())
#'
#' # Now add props:
#' script <- add_default_player(script)
#' script <- add_default_tree(script, 1)
#' script <- save_scene(script)
#'
#' # Lastly, execute the script via the `action` function
#' @rdname add_asset
#' @export
add_default_player <- function(script,
                               controller = c("Player",
                                              "FootstepsPlayer",
                                              "JetpackPlayer",
                                              "Third Person"),
                               asset_directory = NULL,
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
  controller <- file.path(
    "Assets",
    "default_players",
    "Prefabs",
    paste0(controller, ".prefab")
  )

  add_asset(
    script = script,
    asset = "default_players",
    prefab_path = controller,
    asset_directory = asset_directory,
    lazy = lazy,
    method_name = method_name,
    destination_scene = destination_scene,
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

#' @rdname add_asset
#' @export
add_default_tree <- function(script,
                             tree,
                             asset_directory = NULL,
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

  if (is.numeric(tree)) tree <- paste0("tree_", tree)
  prefab_path <- file.path(
    "Assets",
    tree,
    paste0(tree, ".prefab")
  )

  stopifnot(tree %in% available_assets)

  add_asset(
    script = script,
    asset = tree,
    prefab_path = prefab_path,
    asset_directory = asset_directory,
    lazy = lazy,
    method_name = method_name,
    destination_scene = destination_scene,
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

add_asset <- function(script,
                      asset,
                      prefab_path,
                      asset_directory = NULL,
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

  if (is.null(asset_directory)) {
    asset_directory <- tools::R_user_dir("unifir")
  }

  if (!dir.exists(file.path(asset_directory, paste0("unity_assets-", asset)))) {
    get_asset(asset, asset_directory)
  }

  script <- import_asset(
    script = script,
    asset_path = file.path(asset_directory,
                           paste0("unity_assets-", asset),
                           asset),
    lazy = lazy
  )

  instantiate_prefab(
    script,
    method_name = method_name,
    destination_scene = destination_scene,
    prefab_path = prefab_path,
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

