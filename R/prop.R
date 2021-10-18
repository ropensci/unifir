.unifir_prop <- R6::R6Class(
  "unifir_prop",
  list(
    prop_file = NULL,
    method_name = NULL,
    method_type = NULL,
    parameters = list(),
    build = NULL,
    using = NA_character_,
    initialize = function(prop_file, method_name, method_type, parameters, build, using) {
      stopifnot(is.character(prop_file), length(prop_file) == 1, file.exists(prop_file))
      stopifnot(is.character(method_name), length(method_name) == 1)
      stopifnot(is.character(method_type), length(method_type) == 1)

      stopifnot(is.function(build))
      stopifnot(formalArgs(build) == c("script", "prop"))

      stopifnot(is.character(using))

      self$prop_file <- prop_file
      self$method_name <- method_name
      self$method_type <- method_type
      self$parameters <- parameters
      self$build <- build
      self$using <- using

    }
    )
  )

#' The class for unifir prop objects
#'
#' @param prop_file The system location for the C# template file
#' @param method_name The name of the method, in C# code
#' @param method_type The type of the method (usually matches its file name);
#' scripts can have multiple versions of the same method, each with different
#' method_name values, all sharing the same method_type.
#' @param parameters Method-specific parameters, typically used in the build
#' stage.
#' @param build A function that takes two arguments, `script` and `prop`, and
#' uses those to construct the C# method.
#' @param using A character vector of imports required for the method.
#'
#' @return An R6 object of class `unifir_prop`
#'
#' @export
unifir_prop <- function(prop_file, method_name, method_type, parameters, build, using) {
  .unifir_prop$new(prop_file, method_name, method_type, parameters, build, using)
}
