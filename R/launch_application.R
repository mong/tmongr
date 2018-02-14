#' @export
launch_application <- function(datasett = NULL){
  minedata <<- datasett
  shiny::runApp(appDir = system.file("application", package = "dynamiskTabellverk"))
  rm(list = ls())
}

#' @export
submit_application <- function(datasett = NULL){
  minedata <<- datasett
  rsconnect::deployApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}
