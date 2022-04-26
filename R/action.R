#' Build and execute a `unifir_script`
#'
#' @param script The `unifir_script` object to build and execute.
#' @param write Boolean: Write the generated script to a file?
#' @param exec Boolean: Execute the script inside of the Unity project? Note
#' that if `write = FALSE`, `exec` cannot be `TRUE`.
#' @param quit Boolean: Quit Unity after execution?
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'   unity = waiver()
#' )
#'
#' # Then add any number of props to it:
#' script <- add_light(script)
#'
#' # Then call `action` to execute the script!
#' \donttest{
#' if (interactive()) {
#'   action(script)
#' }
#' }
#'
#' @export
action <- function(script, write = TRUE, exec = TRUE, quit = TRUE) {
  debug <- check_debug()
  if (debug) write <- exec <- FALSE

  if (!write && exec) stop("Cannot execute script without writing it!")

  if (
    !debug &&
      (
        # If initialize_project is NULL and the directory is missing:
        (is.null(script$initialize_project) && !dir.exists(script$project)) ||
          # Or if initialize_project is TRUE:
          (!is.null(script$initialize_project) && script$initialize_project))) {
    # Create a unity project at that directory:
    create_unity_project(script$project, unity = script$unity)
  }

  scene_dir <- file.path(script$project, "Assets", "Scenes")
  if (!debug) create_if_not(scene_dir, TRUE)
  if (is.null(script$scene_name)) {
    script$scene_name <- proceduralnames::make_english_names(1,
      4,
      sep = "",
      case = "title"
    )
  }
  if (is.null(script$script_name)) {
    script$script_name <- proceduralnames::make_english_names(1,
      4,
      sep = "",
      case = "title"
    )
  }

  if (file.exists(file.path(scene_dir, script$scene_name))) {
    script$scene_exists <- TRUE
  }

  for (i in seq_along(script$props)) {
    script$props[[i]] <- script$props[[i]]$build(
      script,
      script$props[[i]],
      debug
    )
  }
  script$props <- paste0(script$props, sep = "\n")
  beats <- paste0(script$beats[script$beats$exec, ]$name,
    "();",
    collapse = "\n        "
  )

  if (!debug) create_if_not(file.path(script$project, "Assets", "Editor"))

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
      file.path(
        script$project,
        "Assets",
        "Editor",
        paste0(script$script_name, ".cs")
      )
    )
  }

  # nocov start
  # Skipping test coverage here because I can't install Unity on GH Actions
  # So unless I set up my own build box for CI this is a manual test job
  if (exec) {
    output <- system(
      paste0(
        shQuote(find_unity()),
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
