#' Import assets into Unity.
#'
#' @inheritParams new_scene
#' @param asset_path The file path to the asset to import. If a directory, the
#' entire directory will be recursively copied. Note that this function doesn't
#' have a `method_name` argument: the `asset_path` is used as the method name.
#' This function is not currently vectorized; call it separately for each asset
#' you need to import.
#' @param lazy Boolean: if TRUE, unifir will attempt to only copy the files
#' once per run of a script; if FALSE, unifir will copy the files as many times as
#' requested, overwriting pre-existing files each time.
#'
#' @family props
#'
#' @examples
#' # First, create a script object.
#' # CRAN doesn't have Unity installed, so pass
#' # a waiver object to skip the Unity-lookup stage:
#' script <- make_script("example_script",
#'   unity = waiver()
#' )
#'
#' # CRAN also doesn't have any props to install,
#' # so we'll make a fake prop location:
#' prop_directory <- file.path(tempdir(), "props")
#' dir.create(prop_directory)
#'
#' # Now add props:
#' script <- import_asset(script, prop_directory)
#'
#' # Lastly, execute the script via the `action` function
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
  stopifnot(class(asset_path) %in% waiver() ||
    file.exists(asset_path) ||
    asset_path %in% available_assets)

  if (!lazy ||
    !any(asset_path %in% script$beats$name)) {
    prop <- unifir_prop(
      prop_file = waiver(),
      method_name = asset_path,
      method_type = "ImportAsset",
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
          if (!file.exists(asset_path) &&
            asset_path %in% available_assets) {
            get_asset(asset = asset_path)
            # In an ideal world, we'd update asset_path before build() is
            # called, so that anyone searching $beats can see the actual path.
            #
            # That said, this feels like the easiest way to do this, in case
            # the output of tools::R_user_dir is changed
            # (via environment variable) pre-action()
            #
            # This way, we import the actual asset at its actual location,
            # rather than where we thought the location was going to be
            # back when the prop was first added
            asset_path <- file.path(
              tools::R_user_dir("unifir"),
              paste0("unity_assets-", asset_path),
              asset_path
            )
          }

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
