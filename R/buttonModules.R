#' Module for the "adjust for transfers" button
#'
#' @param id Shiny id
#'
#' @param colnames Column names in the data
#'
#' @return
#' @export
#'
just_overf_server <- function(id, colnames) {
  shiny::moduleServer(id, function(input, output, session) {
    output$just_overf <- shiny::renderUI({
      if ("niva" %in% colnames) {
        shiny::tags$div(title = "Juster for overføringer mellom sykehus.
Ved justering for overføringer er alle døgn- og dagopphold nær i tid regnet som ett opphold, uavhengig av hvor pasienten er behandlet.",# nolint
                 shinyWidgets::materialSwitch(inputId = "overf",
                                              label = "Juster for overføringer",
                                              value = FALSE,
                                              status = "info"))
      }
    })
})
}
