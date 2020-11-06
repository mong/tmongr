#' Run the Shiny Application
#'
#' @export
#'
run_app <- function(data = NULL) {

  shiny::addResourcePath(
    "www", system.file("app/www", package = methods::getPackageName())
  )

  if (!is.null(data)) {
    # put data somewhere for app to read it
    saveRDS(object = data, file = "data.rds")
  }

  shiny::shinyApp(
    ui = app_ui, server = app_server
  )

}
