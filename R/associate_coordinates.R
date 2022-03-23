#' Associate vector coordinates with a raster surface for Unity import
#'
#' Unity uses a left-handed coordinate system, which is effectively "flipped"
#' from our normal way of thinking about spatial coordinate systems. It also
#' can only import terrain as square tiles of side 2^x + 1, for x between 5 and
#' 12. As a result, importing objects into a Unity scene so that they align
#' with terrain surfaces is trickier than you'd expect.
#'
#' This function "associates" the XY coordinates from some `sf` object, likely a
#' point data set, with some raster object.
#'
#' @param object The `sf` object to take coordinates from. The object will be
#' reprojected to align with `raster`.
#' @param raster A raster or file path to a raster to associate coordinates
#' with. Note that different rasters will produce different coordinate outputs;
#' you should run this function with the same raster you plan on bringing into
#' Unity. Any file or object that can be read via [terra::rast] can be used.
#' @param side_length The side length of terrain tiles, in map units,
#' you intend to bring into Unity. Must be a value equal to 2^x + 1, for x
#' between 5 and 12. All functions in the unifir family default to 4097.
#'
#' @return A data.frame with two columns, X and Y, representing the re-aligned
#' coordinates. If `object` is point data (or anything object that
#' [sf::st_coordinates] returns a single row for each row of), these rows will
#' be in the same order as `object` (and so can be appended via `cbind`).
#'
#' @examples
#' \dontrun{
#' if (!isTRUE(as.logical(Sys.getenv("CI")))) {
#'   simulated_data <- data.frame(
#'     id = seq(1, 100, 1),
#'     lat = runif(100, 44.04905, 44.17609),
#'     lng = runif(100, -74.01188, -73.83493)
#'   )
#'   simulated_data <- sf::st_as_sf(simulated_data, coords = c("lng", "lat"))
#'   output_files <- terrainr::get_tiles(simulated_data)
#'   temptiff <- tempfile(fileext = ".tif")
#'   terrainr::merge_rasters(output_files["elevation"][[1]], temptiff)
#'   associate_coordinates(simulated_data, temptiff)
#' }
#' }
#'
#' @export
associate_coordinates <- function(object,
                                  raster,
                                  side_length = 4097) {

  stopifnot(any(class(object) == "sf"))
  stopifnot(side_length %in% (2^(5:12) + 1))
  if (!requireNamespace("terra", quietly = TRUE) ||
      !requireNamespace("sf", quietly = TRUE)) {
    stop("associate_coordinates requires the terra and sf",
         " packages be installed. Please install these packages and try again.")
  }

  object <- sf::st_transform(
    object,
    terra::crs(
      terra::rast(raster)
    )
  )



  coords <- as.data.frame(sf::st_coordinates(object))
  bounds <- as.vector(terra::ext(terra::rast(raster)))
  coords$X <- (side_length *
                 ceiling((bounds[[2]] - bounds[[1]]) / side_length)) -
    (coords$X - bounds[[1]])
  coords$Y <- bounds[[4]] - coords$Y
  coords[c("X", "Y")]
}
