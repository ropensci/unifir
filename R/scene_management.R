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
#' @family props
#' @family utilities
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'   unity = waiver()
#' )
#'
#' # Now add props:
#' script <- new_scene(script)
#'
#' # Lastly, execute the script via the `action` function
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

  prop <- unifir_prop(
    prop_file = system.file("NewScene.cs", package = "unifir"),
    method_name = method_name,
    method_type = "NewScene",
    parameters = list(
      setup = setup,
      mode = mode
    ),
    build = function(script, prop, debug) {
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
#' @family props
#' @family utilities
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script", unity = waiver())
#'
#' # Now add props:
#' script <- load_scene(script, scene_name = "some_scene")
#'
#' # Lastly, execute the script via the `action` function
#' @export
load_scene <- function(script,
                       scene_name,
                       method_name = NULL,
                       exec = TRUE) {
  prop <- unifir_prop(
    prop_file = system.file("OpenScene.cs", package = "unifir"),
    method_name = method_name,
    method_type = "LoadScene",
    parameters = list(
      scene_name = scene_name
    ),
    build = function(script, prop, debug) {
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
#' @family props
#' @family utilities
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'   unity = waiver()
#' )
#'
#' # Now add props:
#' script <- save_scene(script, scene_name = "some_scene")
#'
#' # Lastly, execute the script via the `action` function
#' @export
save_scene <- function(script,
                       scene_name = NULL,
                       method_name = NULL,
                       exec = TRUE) {
  prop <- unifir_prop(
    prop_file = system.file("SaveScene.cs", package = "unifir"),
    method_name = method_name,
    method_type = "SaveScene",
    parameters = list(
      scene_name = scene_name
    ),
    build = function(script, prop, debug) {
      scene_name <- if (is.null(prop$parameters$scene_name)) {
        script$scene_name
      } else {
        prop$parameters$scene_name
      }
      if (!debug) create_if_not(file.path(script$project, "Assets", "Scenes"))
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
#'
#' @family props
#' @family utilities
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'   unity = waiver()
#' )
#'
#' # Now add props:
#' script <- set_active_scene(script, scene_name = "some_scene")
#'
#' # Lastly, execute the script via the `action` function
#' @export
set_active_scene <- function(script,
                             scene_name = NULL,
                             method_name = NULL,
                             exec = FALSE) {
  prop <- unifir_prop(
    prop_file = waiver(),
    method_name = method_name,
    method_type = "SetActiveScene",
    parameters = list(
      scene_name = scene_name
    ),
    build = function(script, prop, debug) {
      if (is.null(prop$parameters$scene_name)) {
        scene_name <- script$scene_name
      } else {
        scene_name <- prop$parameters$scene_name
      }
      stopifnot(!is.null(scene_name))
      if (!debug) {
        create_if_not(file.path(script$project, "Library"))
        writeLines(
          paste0(
            "sceneSetups:\n- path: ",
            file.path("Assets", "Scenes", scene_name),
            ".unity\n  isLoaded: 1\n  isActive: 1\n  isSubScene: 0"
          ),
          file.path(script$project, "Library", "LastSceneManagerSetup.txt")
        )
      }
    },
    using = c("UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  )

  add_prop(script, prop, exec = FALSE)
}
