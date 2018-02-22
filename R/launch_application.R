#' Launch the application locally
#' @param datasett The data set to be loaded into the application
#'
#' @export
launch_application <- function(datasett = NULL){
  minedata <<- datasett
  shiny::runApp(appDir = system.file("application", package = "dynamiskTabellverk"))
  rm(list = ls())
}

#' Submit the application to shinyapp.io
#' @param datasett The data set to be loaded into the application
#'
#' @export
submit_application <- function(datasett = NULL, name = "experimental"){
#  minedata <<- datasett
#  print(minedata)
  load(datasett)
  appfolder = system.file("application", package = "dynamiskTabellverk")
  rsconnect::deployApp(appDir = appfolder, appName = name, appFiles = c(appfolder, datasett))
}
