#' Create a new scene in a Unity project.
#'
#' @param script A `unifir_script` object, created by [make_script] or returned
#' by an `add_prop_*` function.
#' @param setup One of "EmptyScene"
#' ("No game objects are added to the new Scene.") or "DefaultGameObjects"
#' ("Adds default game objects to the new Scene (a light and camera).")
#' @param mode One of "Additive"
#' ("The newly created Scene is added to the current open Scenes.") or "Single"
#' ("All current open Scenes are closed and the newly created Scene are
#' opened.")
#' @param method_name The internal name to use for the C# method created. Will
#' be randomly generated if not set.
#' @param exec Logical: Should the C# method be included in the set executed by
#' MainFunc?
#'
#' @export
new_scene <- function(script,
                      setup = c("EmptyScene", "DefaultGameObjects"),
                      mode = c("Additive", "Single"),
                      method_name = NULL,
                      exec = TRUE) {
  setup <- setup[[1]]
  mode <- mode[[1]]
  if (!(mode %in% c("Additive", "Single"))) {
    stop("mode must be one of Additive or Single")
  }

  if (!(setup %in% c("EmptyScene", "DefaultGameObjects"))) {
    stop("setup must be one of EmptyScene or DefaultGameObjects")
  }

  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(
      n = 1,
      n_words = 2,
      sep = "",
      case = "title"
    )
  }

  prop <- unifir_prop(
    prop_file = system.file("NewScene.cs", package = "unifir"),
    method_name = method_name,
    method_type = "NewScene",
    parameters = list(
      setup = setup,
      mode = mode
    ),
    build = function(script, prop) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        setup = setup,
        mode = mode
      )
    },
    using = c("UnityEngine.SceneManagement", "UnityEditor", "UnityEditor.SceneManagement")
  )

  add_prop(script, prop, exec)
}

#' Load a scene in a Unity project.
#'
#' @inheritParams new_scene
#' @param scene_name The name of the scene to load.
#'
#' @export
load_scene <- function(script,
                       scene_name,
                       method_name = NULL,
                       exec = TRUE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(
      n = 1,
      n_words = 2,
      sep = "",
      case = "title"
    )
  }

  prop <- unifir_prop(
    prop_file = system.file("OpenScene.cs", package = "unifir"),
    method_name = method_name,
    method_type = "LoadScene",
    parameters = list(
      scene_name = scene_name
    ),
    build = function(script, prop) {
      scene_name <- if (methods::is(prop$parameters$scene_name, "waiver")) {
        script$scene_name
      } else {
        scene_name <- prop$parameters$scene_name
      }

      stopifnot(!is.null(scene_name))

      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        scene_name = scene_name
      )
    },
    using = c("UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  )

  add_prop(script, prop, exec)
}


#' Save a scene in a Unity project.
#'
#' @inheritParams new_scene
#' @param scene_name The name to save the scene to.
#'
#' @export
save_scene <- function(script,
                       scene_name = NULL,
                       method_name = NULL,
                       exec = TRUE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(
      n = 1,
      n_words = 2,
      sep = "",
      case = "title"
    )
  }

  prop <- unifir_prop(
    prop_file = system.file("SaveScene.cs", package = "unifir"),
    method_name = method_name,
    method_type = "SaveScene",
    parameters = list(
      scene_name = scene_name
    ),
    build = function(script, prop) {
      scene_name <- if (is.null(prop$parameters$scene_name)) {
        script$scene_name
      } else {
        prop$parameters$scene_name
      }
      create_if_not(file.path(script$project, "Assets", "Scenes"))
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        scene_name = scene_name
      )
    },
    using = c("UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  )

  add_prop(script, prop, exec)
}

#' Set a single scene to active.
#'
#' @inheritParams new_scene
#' @param scene_name The name of the scene to set as the active scene.
#' @export
set_active_scene <- function(script,
                             scene_name = NULL) {
  if (is.null(scene_name)) scene_name <- script$scene_name
  stopifnot(!is.null(scene_name))
  writeLines(
    paste0(
      "sceneSetups:\n- path: ",
      file.path("Assets", "Scenes", scene_name),
      ".unity\n  isLoaded: 1\n  isActive: 1\n  isSubScene: 0"
    ),
    file.path(script$project, "Library", "LastSceneManagerSetup.txt")
  )
}
