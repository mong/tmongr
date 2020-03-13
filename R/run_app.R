#' Run the Shiny Application
#'
#' @export
#'
run_app <- function() {
  shiny::addResourcePath(
    "www", system.file("app/www", package = getPackageName())
  )
  shiny::addResourcePath(
    "Rmd", system.file("app/Rmd", package = getPackageName())
  )

  shiny::shinyApp(
    ui = app_ui, server = app_server
  )
}
