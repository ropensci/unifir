#' Create a terrain tile with optional image overlay
#'
#' @inheritParams new_scene
#' @param heightmap_path The file path to the heightmap to import as terrain.
#' @param x_pos,z_pos The position of the corner of the terrain.
#' @param width,height,length The dimensions of the terrain tile,
#' in linear units.
#' @param heightmap_resolution The resolution of the heightmap image.
#' @param texture_path Optional: the file path to the image to use as a terrain
#' overlay.
#'
#' @family props
#'
#' @examples
#' if (requireNamespace("terra", quietly = TRUE)) {
#'   raster <- tempfile(fileext = ".tiff")
#'   r <- terra::rast(matrix(rnorm(1000^2, mean = 100, sd = 20), 1000),
#'     extent = terra::ext(0, 1000, 0, 1000)
#'   )
#'   terra::writeRaster(r, raster)
#'
#'   script <- make_script("example_script",
#'     unity = waiver()
#'   )
#'   create_terrain(
#'     script,
#'     heightmap_path = raster,
#'     x_pos = 0,
#'     z_pos = 0,
#'     width = 1000,
#'     height = terra::minmax(r)[[2]],
#'     length = 1000,
#'     heightmap_resolution = 1000
#'   )
#' }
#' @export
create_terrain <- function(script,
                           method_name = NULL,
                           heightmap_path,
                           x_pos,
                           z_pos,
                           width,
                           height,
                           length,
                           heightmap_resolution,
                           texture_path = "",
                           exec = TRUE) {
  if (any(script$beats$type == "AddTexture")) {
    add_texture_method <- utils::head(
      script$beats[script$beats$type == "AddTexture", ]$name,
      1
    )
  } else {
    add_texture_method <- "AddTextureAutoAdd"
    script <- add_texture(script, add_texture_method, exec = FALSE)
  }

  if (any(script$beats$type == "ReadRaw")) {
    read_raw_method <- utils::head(
      script$beats[script$beats$type == "ReadRaw", ]$name,
      1
    )
  } else {
    read_raw_method <- "ReadRawAutoAdd"
    script <- read_raw(script, read_raw_method, exec = FALSE)
  }

  prop <- unifir_prop(
    prop_file = system.file("CreateTerrain.cs", package = "unifir"),
    method_name = method_name,
    method_type = "CreateTerrain",
    parameters = list(
      heightmap_path = heightmap_path,
      x_pos = x_pos,
      z_pos = z_pos,
      width = width,
      height = height,
      length = length,
      heightmap_resolution = heightmap_resolution,
      texturePath = texture_path,
      add_texture_method = add_texture_method,
      read_raw_method = read_raw_method
    ),
    build = function(script, prop, debug) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        heightmap_path = prop$parameters$heightmap_path,
        base_path = basename(prop$parameters$heightmap_path),
        x_pos = prop$parameters$x_pos,
        z_pos = prop$parameters$z_pos,
        width = prop$parameters$width,
        height = prop$parameters$height,
        length = prop$parameters$length,
        heightmapResolution = prop$parameters$heightmap_resolution,
        texturePath = prop$parameters$texturePath,
        add_texture_method = prop$parameters$add_texture_method,
        read_raw_method = prop$parameters$read_raw_method
      )
    },
    using = c("System", "System.IO", "UnityEngine")
  )

  add_prop(script, prop, exec)
}
