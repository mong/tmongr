
just_overfUI <- function(id) {
    ns <- NS(id)
    uiOutput(ns("just_overf"))
}

just_overf <- function(input, output, session) {
    renderUI({
#      if ("niva" %in% colnames(datasett)) {
        tags$div(title = "Juster for overføringer mellom sykehus.
Ved justering for overføringer er alle døgn- og dagopphold nær i tid regnet som ett opphold, uavhengig av hvor pasienten er behandlet.",
                 shinyWidgets::materialSwitch(inputId = "overf",
                                              label = "Juster for overføringer",
                                              value = FALSE,
                                              status = "info"))
#      }
    })
}