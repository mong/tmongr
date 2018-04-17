#' Launch the application locally
#' @param datasett The data set to be loaded into the application
#'
#' @export
launch_application <- function(datasett = NULL){
  shinydir <- create_appDir(datafile = datasett)
  shiny::runApp(appDir = shinydir)
}

#' Submit the application to shinyapp.io
#' @param datasett The data set file (.RData) to be loaded into the application.
#' The absolute path has to be given
#' @param name The appName of the deployed shiny application
#'
#' @export
submit_application <- function(datasett = NULL, name = "experimental"){
  shinydir <- create_appDir(datafile = datasett)
  rsconnect::deployApp(appDir = shinydir, appName = name)
}

#' Create an appDir for shiny::runApp and rsconnect::deployApp
#'
#' @param datafile The data set file used by the app
#'
#' @return The created directory
#' @export
#'
#' @examples
create_appDir <- function(datafile = NULL){
  tmpshinydir <- paste0(tempdir(),"/shiny")
  unlink(tmpshinydir, recursive = TRUE, force = TRUE)
  dir.create(tmpshinydir)
  file.copy(system.file("application", package = "dynamiskTabellverk"), tmpshinydir, recursive = TRUE)
  dir.create(paste0(tmpshinydir, "/application/data"))
  file.copy(datafile, paste0(tmpshinydir,"/application/data/data.RData"))
  return(paste0(tmpshinydir, "/application"))
}