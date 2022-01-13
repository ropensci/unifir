#' Create a terrain tile with optional image overlay
#'
#' @inheritParams new_scene
#' @param heightmap_path The file path to the heightmap to import as terrain.
#' @param x_pos,z_pos The position of the corner of the terrain.
#' @param width,height,length The dimensions of the terrain tile, in linear units.
#' @param heightmap_resolution The resolution of the heightmap image.
#' @param texture_path Optional: the file path to the image to use as a terrain
#' overlay.
#'
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
  if (is.null(method_name)) {
    method_name <- proceduralnames::make_english_names(
      n = 1,
      n_words = 2,
      sep = "",
      case = "title"
    )
  }

  if (any(script$beats$type == "AddTexture")) {
    add_texture_method <- utils::head(script$beats[script$beats$type == "AddTexture", ]$name, 1)
  } else {
    add_texture_method <- "AddTextureAutoAdd"
    script <- add_texture(script, add_texture_method, exec = FALSE)
  }

  if (any(script$beats$type == "ReadRaw")) {
    read_raw_method <- utils::head(script$beats[script$beats$type == "ReadRaw", ]$name, 1)
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
    build = function(script, prop) {
      glue::glue(
        readChar(prop$prop_file, file.info(prop$prop_file)$size),
        .open = "%",
        .close = "%",
        method_name = prop$method_name,
        heightmapPath = prop$parameters$heightmap_path,
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
