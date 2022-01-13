#' Validate a file path exists
#'
#' `validate_path` creates a generic C# method which takes a single argument
#' and checks to make sure it exists. Your C# code calling the method must
#' provide the path to validate.
#' `validate_single_path` hard-codes the path to check in the C# code. This
#' allows you to specify the path to check from R.
#'
#' @inheritParams new_scene
#' @param path The file path to validate
#'
#' @family props
#' @family utilities
#'
#' @rdname ValidatePath
#' @export
validate_path <- function(script,
                          method_name = NULL,
                          exec = FALSE) {
  prop <- unifir_prop(
    prop_file = system.file("ValidatePath.cs", package = "unifir"),
    method_name = method_name,
    method_type = "ValidatePath",
    parameters = list(),
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name
      )
    },
    using = c("System", "System.IO")
  )

  add_prop(script, prop, exec)
}

#' @rdname ValidatePath
#' @export
validate_single_path <- function(script,
                                 path,
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
    prop_file = system.file("ValidateSinglePath.cs", package = "unifir"),
    method_name = method_name,
    method_type = "ValidateSinglePath",
    parameters = list(
      path = path
    ),
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        file_path = prop$parameters$path
      )
    },
    using = c("System", "System.IO")
  )

  add_prop(script, prop, exec)
}
