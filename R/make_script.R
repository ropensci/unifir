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
    beats = data.frame(idx = numeric(0), name = character(0)),
    using = character(0)
  )
  class(script) <- "unifir_script"
  script
}

#' @export
action <- function(script, write = TRUE, exec = TRUE, quit = TRUE) {

  if (
    # If initialize_project is NULL and the directory is missing:
    (is.null(script$initialize_project) && !dir.exists(script$project)) ||
    # Or if initialize_project is TRUE:
    (!is.null(script$initialize_project) && script$initialize_project)) {
    # Create a unity project at that directory:
    create_unity_project(script$project, unity = script$unity)
  }

  stopifnot(dir.exists(script$project))

  scene_dir <- file.path(script$project, "Assets", "Scenes")
  create_if_not(scene_dir, TRUE)
  if (is.null(script$scene_name)) {
    script$scene_name <- proceduralnames::make_english_names(1,
                                                            2,
                                                            sep = "",
                                                            case = "title")
  }
  if (is.null(script$script_name)) {
    script$script_name <- proceduralnames::make_english_names(1,
                                                              2,
                                                              sep = "",
                                                              case = "title")
  }

  if (file.exists(file.path(scene_dir, script$scene_name))) {
    script$scene_exists <- TRUE
  }

  if (length(script$props) > 0) {
    for (i in seq_along(script$props)) {
      script$props[[i]] <- script$props[[i]]$build(script, script$props[[i]])
    }
    script$props <- paste0(script$props, sep = "\n")
    beats <- paste0(script$beats$name, "();", collapse = "\n        ")
  }

  create_if_not(file.path(script$project, "Assets", "Editor"))

  script$using <- unique(script$using)
  script$using <- paste0("using ", script$using, ";", collapse = "\n")

  if (write) {
    writeLines(
      c(
        paste(script$using, "\n"),
        paste("public class", script$script_name, "{"),
        script$props,
        "    static void MainFunc() {",
        paste0("        ", beats),
        "    }",
        "}"
      ),
      file.path(script$project, "Assets", "Editor", paste0(script$script_name, ".cs"))
    )
  }

  # nocov start
  # Skipping test coverage here because I can't install Unity on GH Actions
  # So unless I set up my own build box for CI this is a manual test job
  if (exec) {
    output <- system(
      paste0(
        find_unity(),
        " -batchmode",
        if (quit) " -quit",
        " -projectPath ",
        script$project,
        " -executeMethod ",
        script$script_name,
        ".MainFunc"
      )
    )

    if (output != "0") stop(output)
  }
  # nocov end

  return(invisible(script))

}
