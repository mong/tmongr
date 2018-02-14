#' @export
launch_application <- function(){
  shiny::runApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}

#' @export
submit_application <- function(){
  rsconnect::deployApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}
