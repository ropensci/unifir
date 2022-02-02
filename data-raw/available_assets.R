## code to prepare `available_assets` dataset goes here

available_assets <- httr::GET(
  "api.github.com/repos/mikemahoney218/unity_assets/branches"
  )

if (httr::http_type(available_assets) == "application/json") {
  available_assets <- jsonlite::fromJSON(
    httr::content(available_assets, "text")
    )
} else {
  stop("API did not return a JSON bundle")
}

available_assets <- setdiff(available_assets$name, "main")

usethis::use_data(available_assets, overwrite = TRUE)
