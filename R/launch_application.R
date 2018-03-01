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
  # Put app and data file in temp folder
  shinydir = paste0(tempdir(),"/shiny")
  unlink(shinydir, recursive = TRUE, force = TRUE)
  dir.create(shinydir)
  file.copy(system.file("application", package = "dynamiskTabellverk"), shinydir, recursive = TRUE)
  dir.create(paste0(shinydir, "/application/data"))
  file.copy(datasett, paste0(shinydir,"/application/data/data.RData"))
  rsconnect::deployApp(appDir = paste0(shinydir, "/application"), appName = name)
}
