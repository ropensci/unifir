#' Create an empty `unifir_script` object.
#'
#' unifir relies upon "script" objects, which collect "prop" objects
#' (C# methods)
#' which then may be executed within a Unity project via the [action] function.
#'
#' @param project The directory path of the Unity project.
#' @param script_name The file name to save the script at. The folder location
#' and file extensions will be added automatically.
#' @param scene_name The default scene to operate within. If a function requires
#' a scene name and one is not provided, this field will be used.
#' @param unity The location of the Unity executable to create projects with.
#' @param initialize_project If TRUE, will call [create_unity_project] to create
#' a Unity project at `project`. If FALSE, will not create a new project.
#' If NULL, will create a new project if `project` does not exist.
#'
#' @family scripts
#'
#' @examples
#' # Create an empty script file
#' # In practice, you'll want to set `project` to the project path to create
#' # and `unity` to `NULL` (the default)
#' make_script(project = waiver(), unity = waiver())
#'
#' @return A `unifir_script` object.
#'
#' @export
make_script <- function(project,
                        script_name = NULL,
                        scene_name = NULL,
                        unity = find_unity(),
                        initialize_project = NULL) {
  script <- .unifir_script$new(
    project = project,
    script_name = script_name,
    scene_name = scene_name,
    scene_exists = FALSE,
    unity = unity,
    initialize_project = initialize_project,
    props = list(),
    beats = data.frame(
      idx = numeric(0),
      name = character(0),
      type = character(0),
      exec = logical(0)
    ),
    using = character(0)
  )

  class(script) <- "unifir_script"
  script
}

.unifir_script <- R6::R6Class(
  "unifir_script",
  list(
    project = character(),
    script_name = character(),
    scene_name = character(),
    scene_exists = logical(),
    unity = character(),
    initialize_project = logical(),
    props = list(),
    beats = data.frame(),
    using = character(),
    initialize = function(project,
                          script_name = NULL,
                          scene_name = NULL,
                          scene_exists = NULL,
                          unity = find_unity(),
                          initialize_project = NULL,
                          props = list(),
                          beats = data.frame(
                            idx = numeric(0),
                            name = character(0),
                            type = character(0),
                            exec = logical(0)
                          ),
                          using = character(0)) {
      self$project <- project
      self$script_name <- script_name
      self$scene_name <- scene_name
      self$scene_exists <- scene_exists
      self$unity <- unity
      self$initialize_project <- initialize_project
      self$props <- props
      self$beats <- beats
      self$using <- using
    }
  )
)
