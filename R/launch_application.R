#' @export
launch_application <- function(minedata=NULL){
  print(minedata)
  shiny::runApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}

#' @export
submit_application <- function(){
  rsconnect::deployApp(appDir = system.file("application", package = "dynamiskTabellverk"))
}
