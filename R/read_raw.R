#' Read a RAW file in as a float array
#'
#' @inheritParams new_scene
#'
#' @export
read_raw <- function(script,
                     method_name = NULL,
                     exec = FALSE) {
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(n = 1,
                                                       n_words = 2,
                                                       sep = '',
                                                       case = "title")
  }

  prop <- unifir_prop(
    prop_file = system.file("ReadRaw.cs", package = "unifir"),
    method_name = method_name,
    method_type = "ReadRaw",
    parameters = list(),
    build = function(script, prop) {

      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
      )
    },
    using = c("System", "System.IO")
  )

  add_prop(script, prop, exec)
}
