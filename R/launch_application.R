#' @export
launch_application <- function(minedata = NULL){
  print(minedata)
  minedata <<- minedata
  shiny::runApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}

#' @export
submit_application <- function(minedata = NULL){
  minedata <<- minedata
  rsconnect::deployApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}
