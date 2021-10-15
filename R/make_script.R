#' @export
make_script <- function(project,
                        script_name = NULL,
                        scene_name = NULL,
                        unity = find_unity(),
                        initialize_project = NULL) {

  script <- list(
    project = project,
    script_name = script_name,
    scene_name = scene_name,
    scene_exists = FALSE,
    unity = unity,
    initialize_project = initialize_project,
    props = list(),
    beats = data.frame(idx = numeric(0), name = character(0), type = character(0)),
    using = character(0)
  )
  class(script) <- "unifir_script"
  script
}
