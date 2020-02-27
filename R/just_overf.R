#' Module for the "adjust for transfers" button
#'
#' @param id Shiny id
#'
#' @return
#' @export
#'
just_overfUI <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("just_overf"))
}

#' Server side of the "adjust for transfers" button module
#'
#' @param input internal
#' @param output internal
#' @param session internal
#' @param colnames Column names in the data
#'
#' @return
#' @export
#'
just_overf <- function(input, output, session, colnames) {
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
}
