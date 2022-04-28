.unifir_prop <- R6::R6Class(
  "unifir_prop",
  list(
    prop_file = NULL,
    method_name = NULL,
    method_type = NULL,
    parameters = list(),
    build = NULL,
    using = NA_character_,
    initialize = function(prop_file,
                          method_name,
                          method_type,
                          parameters,
                          build,
                          using) {
      if (!("waiver" %in% class(prop_file))) {
        stopifnot(
          is.character(prop_file),
          length(prop_file) == 1,
          file.exists(prop_file)
        )
      }
      if (is.null(method_name) || is.na(method_name)) {
        method_name <- proceduralnames::make_english_names(
          n = 1,
          n_words = 4,
          sep = "",
          case = "title"
        )
      }
      stopifnot(is.character(method_name), length(method_name) == 1)
      stopifnot(is.character(method_type), length(method_type) == 1)

      stopifnot(is.function(build))
      stopifnot(formalArgs(build) == c("script", "prop", "debug"))

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
#' This function is exported so that developers can add their own props
#' in new packages, without needing to re-implement the prop and script
#' classes themselves. It is not expected that end users will need this
#' function.
#'
#' @details
#' This function will check each argument for correctness. To be specific,
#' it performs the following checks:
#'
#' * `prop_file` must be either a `waiver` object (created by [waiver])
#'   or a file path of length 1 pointing to a file that exists
#' * `method_name` will be automatically generated if not existing. If
#'   it exists, it must be a character vector of length 1
#' * `method_type` must be a character vector of length 1
#' * `build` must be a function with the arguments `script`, `prop`,
#'   and `debug` (in that order, with no other arguments). Any other
#'   arguments needed by your build function should be passed as prop
#'   parameters.
#' * `using` must be a character vector (of any length, including 0)
#'
#' If your prop needs data or arguments beyond these, store them as a
#' list in `parameters`, which is entirely unchecked.
#'
#' @section The debug argument:
#' When `Sys.getenv(unifir_debugmode)` returns anything other than `""`,
#' [action] runs in "debug mode". In addition to setting `exec` and `write`
#' to `FALSE` in [action], this mode also attempts to disable any prop
#' functionality that would make changes to the user's disk -- no files
#' or directories should be altered. In this mode, [action] will pass
#' `debug = TRUE` as an argument to your prop; your prop should respect
#' the debug mode and avoid making any changes.
#'
#' @param prop_file The system location for the C# template file
#' @param method_name The name of the method, in C# code
#' @param method_type The type of the method (usually matches its file name);
#' scripts can have multiple versions of the same method, each with different
#' method_name values, all sharing the same method_type.
#' @param parameters Method-specific parameters, typically used in the build
#' stage.
#' @param build A function that takes three arguments, `script`, `prop`, and
#' `debug`, and uses those to construct the C# method.
#' @param using A character vector of imports required for the method.
#'
#' @return An R6 object of class `unifir_prop`
#'
#' @examples
#' unifir_prop(
#'   prop_file = waiver(), # Must be a file that exists or waiver()
#'   method_name = NULL, # Auto-generated if NULL or NA
#'   method_type = "ExampleProp", # Length-1 character vector
#'   parameters = list(), # Not validated, usually a list
#'   build = function(script, prop, debug) {},
#'   using = character(0)
#' )
#' @export
unifir_prop <- function(prop_file,
                        method_name,
                        method_type,
                        parameters,
                        build,
                        using) {
  .unifir_prop$new(
    prop_file,
    method_name,
    method_type,
    parameters,
    build,
    using
  )
}

#' Add a prop to a unifir script
#'
#' This function is exported so that developers can add their own props
#' in new packages, without needing to re-implement the prop and script
#' classes themselves. It is not expected that end users will need this
#' function.
#'
#' @param script A script object (from [make_script]) to append the prop to.
#' @param prop A `unifir_prop` object (from [unifir_prop]) to add to the script.
#' @param exec Logical: Should the method created by the prop be called in the
#' MainFunc method?
#'
#' @family props
#' @family utilities
#'
#' @examples
#' script <- make_script("example_script", unity = waiver())
#' prop <- unifir_prop(
#'   prop_file = waiver(), # Must be a file that exists or waiver()
#'   method_name = NULL, # Auto-generated if NULL or NA
#'   method_type = "ExampleProp", # Length-1 character vector
#'   parameters = list(), # Not validated, usually a list
#'   build = function(script, prop, debug) {},
#'   using = character(0)
#' )
#' script <- add_prop(script, prop)
#' @export
add_prop <- function(script, prop, exec = TRUE) {
  stopifnot(is.logical(exec))
  stopifnot(methods::is(script, "unifir_script"))

  idx <- nrow(script$beats) + 1

  script$props[[idx]] <- prop

  script$beats[idx, ]$idx <- idx
  script$beats[idx, ]$name <- prop$method_name
  script$beats[idx, ]$type <- prop$method_type
  script$beats[idx, ]$exec <- exec
  script$using <- c(script$using, prop$using)
  script
}
