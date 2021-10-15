#' Validate a file path exists
#'
#' @inheritParams new_scene
#' @param path The file path to validate
#'
#' @export
validate_path <- function(script,
                       path,
                       method_name = NULL) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(n = 1,
                                                       n_words = 2,
                                                       sep = '',
                                                       case = "title")
  }

  prop <- unifir_prop$new(
    prop_file = system.file("ValidatePath.cs", package = "unifir"),
    method_name = method_name,
    method_type = "ValidatePath",
    parameters = list(
      path = path
    ),
    build = function(script, prop) {

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

  add_prop(script, prop)
}
