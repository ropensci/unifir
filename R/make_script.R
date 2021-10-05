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
action <- function(script) {

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

  script$props[[1]] <- NULL

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

  output <- system(
    paste0(
      find_unity(),
      " -batchmode",
      " -quit",
      " -projectPath ",
      script$project,
      " -executeMethod ",
      script$script_name,
      ".MainFunc"
    )
  )

  if (output != "0") stop(output)

  return(invisible(script))

}

#' @export
prop_save_scene <- function(script,
                            method_name = proceduralnames::make_english_names(1, 2, sep = '', case = "title"),
                            scene_name = NULL) {
  script$props <- list(
    script$props,
    list(
      prop_file = system.file("SaveScene.cs", package = "unifir"),
      method_name = method_name,
      parameters = list(
        scene_name = scene_name
      ),
      build = function(script, prop) {
        scene_name <- ifelse(is.null(prop$scene_name), script$scene_name, prop$scene_name)
        glue::glue(
          readChar(system.file("SaveScene.cs", package = "unifir"),
                   file.info(system.file("SaveScene.cs", package = "unifir"))$size),
          .open = "%", .close = "%",
          method_name = prop$method_name, scene_name = scene_name
        )
      }
    )
  )
  idx <- nrow(script$beats) + 1
  script$beats[idx, ]$idx <- idx
  script$beats[idx, ]$name <- method_name
  script$using <- c(script$using, "UnityEngine", "UnityEditor", "UnityEditor.SceneManagement")
  script
}

create_if_not <- function(path, recur = FALSE) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = recur)
  }
}
