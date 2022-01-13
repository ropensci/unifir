#' Read a RAW file in as a float array
#'
#' @inheritParams new_scene
#'
#' @family props
#' @family utilities
#'
#' @export
read_raw <- function(script,
                     method_name = NULL,
                     exec = FALSE) {
  prop <- unifir_prop(
    prop_file = system.file("ReadRaw.cs", package = "unifir"),
    method_name = method_name,
    method_type = "ReadRaw",
    parameters = list(),
    build = function(script, prop, debug) {
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
