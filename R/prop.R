library(R6)

unifir_prop <- R6Class(
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
