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
  print("TEST")
  shinydir <- create_appDir(datafile = datasett)
  print("shinydir")
  print(shinydir)
  rsconnect::deployApp(appDir = shinydir, appName = name)
}

#' Create an appDir for shiny::runApp and rsconnect::deployApp
#'
#' @param datafile The data set file used by the app
#'
#' @return The created directory
#'
create_appDir <- function(datafile = NULL){
  print("#1")
  tmpshinydir <- paste0(tempdir(),"/shiny")
  print("#2")
  unlink(tmpshinydir, recursive = TRUE, force = TRUE)
  print("#3")
  dir.create(tmpshinydir)
  print("#4")
  file.copy(system.file("application", package = "dynamiskTabellverk"), tmpshinydir, recursive = TRUE)
  print("#5")
  dir.create(paste0(tmpshinydir, "/application/data"))
  print("#6")
  print(datafile)
#  for (i in datafile) {
    save(datafile, file = paste0(tmpshinydir,"/application/data/data.RData"))
#  }
  print("#7")
  print("Innhold 1")
  print(list.files(path = paste0(tmpshinydir, "/application/")))
  print("Innhold 2")
  print(list.files(path = paste0(tmpshinydir,"/application/data/")))

  return(paste0(tmpshinydir, "/application"))
}