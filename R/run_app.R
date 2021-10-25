#' Run the Shiny Application
#'
#' @export
#'
run_app <- function() {

  shiny::addResourcePath(
    "www", system.file("app/www", package = methods::getPackageName())
  )

  shiny::shinyApp(
    ui = app_ui, server = app_server, options = c(port = 80)
  )

}
