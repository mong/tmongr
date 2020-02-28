
rad1_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("rad1"))
}

rad2_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("rad2"))
}

kolonner_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("kolonner"))
}

verdi_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("verdi"))
}

rad1_server <- function(input, output, session, pickable, default) {
    # valg rader 1
    output$rad1 <- shiny::renderUI({
      shiny::tags$div(title = "Velg første grupperingsvariabel",
               shiny::selectInput("xcol1",
                           label = "Grupperingsvariabel en",
                           choices = pickable,
                           selected = default
               ))
    })

}

rad2_server <- function(input, output, session, pickable, default) {
    # valg rader 2
    output$rad2 <- shiny::renderUI({
      shiny::tags$div(title = "Velg andre grupperingsvariabel",
               shiny::selectInput("xcol2",
                           label = "Grupperingsvariabel to",
                           choices = pickable,
                           selected = default
               ))
    })

}

kolonner_server <- function(input, output, session, pickable, default) {
    # valg kolonner
    output$kolonner <- shiny::renderUI({
      shiny::tags$div(title = "Velg kolonner",
               shiny::selectInput("ycol",
                           label = "Kolonner",
                           choices = pickable,
                           selected = default
                           ))
    })

}

verdi_server <- function(input, output, session, pickable, default) {
    # Velg hva som skal tabuleres
    output$verdi <- shiny::renderUI({
      shiny::tags$div(title = "Velg hva som skal vises",
               shiny::selectInput("verdi",
                           label = "Verdi",
                           choices = pickable,
                           selected = default
                           ))
    })

}
