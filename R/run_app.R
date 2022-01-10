#' Run the Shiny Application
#'
#' @export
#'
run_app <- function(port = 80) {
  shiny::addResourcePath(
    "www", system.file("app/www", package = methods::getPackageName())
  )

  shiny::shinyApp(
    ui = app_ui, server = app_server, options = c(port = port)
  )
}
