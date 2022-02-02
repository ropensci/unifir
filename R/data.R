#' Vector of assets unifir can download and import
#'
#' This object contains the set of assets unifir is able to download and import
#' (through [get_asset] and [import_asset]). These objects are all released
#' under permissive open-source licenses (currently, either CC-0 1.0 or MIT).
#' More information on the assets may be found at
#' https://github.com/mikemahoney218/unity_assets .
#'
#' @format A character vector with 13 elements, each representing an asset
#' which can be imported.
#'
#' @source \url{https://github.com/mikemahoney218/unity_assets}
"available_assets"
utils::globalVariables("available_assets")
