#' Import assets into Unity.
#'
#' @inheritParams new_scene
#' @param package The file path to the asset to import. If a directory, the
#' entire directory will be recursively copied.
#' @param lazy Boolean: if TRUE, unifir will attempt to only copy the files
#' once; if FALSE, unifir will copy the files as many times as requested,
#' overwriting pre-existing files each time.
#'
#' @return `script` with a new prop.
#'
#' @export
import_asset <- function(script,
                         package,
                         exec = TRUE,
                         lazy = TRUE) {

  # Should I be checking this here or in build()?
  # Here seems more friendly (fail fast) but at the same time,
  # it's not impossible that package doesn't exist at script writing time
  # but does at execution
  stopifnot(file.exists(package))

  if (!lazy ||
      (!any(script$beats$type == "ImportPackage") &&
      !any(package %in% script$beats$name))) {

    prop <- unifir_prop(
      prop_file = waiver(),
      method_name = package,
      method_type = "ImportPackage",
      parameters = list(
        package = package
      ),
      build = function(script, prop) {

        if (dir.exists(prop$parameters$package)) {
          dir.create(
            file.path(
              script$project,
              "Assets",
              basename(prop$parameters$package)
            ),
            recursive = TRUE
          )
        }

        file.copy(
          package,
          file.path(
            script$project,
            "Assets"
          ),
          overwrite = TRUE,
          recursive = TRUE
        )

        return("") # Don't add any text to the script

      },
      using = character(0)
    )

    add_prop(script, prop, FALSE)

  } else {
    script
  }

}
