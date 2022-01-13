#' Import assets into Unity.
#'
#' @inheritParams new_scene
#' @param asset_path The file path to the asset to import. If a directory, the
#' entire directory will be recursively copied.
#' @param lazy Boolean: if TRUE, unifir will attempt to only copy the files
#' once per run of a script; if FALSE, unifir will copy the files as many times as
#' requested, overwriting pre-existing files each time.
#'
#' @family props
#'
#' @return `script` with a new prop.
#'
#' @export
import_asset <- function(script,
                         asset_path,
                         lazy = TRUE) {

  # Should I be checking this here or in build()?
  # Here seems more friendly (fail fast) but at the same time,
  # it's not impossible that asset_path doesn't exist at script writing time
  # but does at execution
  stopifnot(file.exists(asset_path))

  if (!lazy ||
    !any(asset_path %in% script$beats$name)) {
    prop <- unifir_prop(
      prop_file = waiver(),
      method_name = asset_path,
      method_type = "Importasset_path",
      parameters = list(
        asset_path = asset_path
      ),
      build = function(script, prop, debug) {
        asset_dir <- file.path(
          script$project,
          "Assets",
          basename(prop$parameters$asset_path)
        )

        if (!debug) {
          if (!dir.exists(asset_dir)) {
            dir.create(
              asset_dir,
              recursive = TRUE
            )
          }

          file.copy(
            asset_path,
            file.path(
              script$project,
              "Assets"
            ),
            overwrite = TRUE,
            recursive = TRUE
          )
        }

        return("") # Don't add any text to the script
      },
      using = character(0)
    )

    add_prop(script, prop, FALSE)
  } else {
    script
  }
}
