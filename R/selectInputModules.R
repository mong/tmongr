
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
    output$rad1 <- renderUI({
      tags$div(title = "Velg første grupperingsvariabel",
               selectInput("xcol1",
                           label = "Grupperingsvariabel en",
                           choices = pickable,
                           selected = default
               ))
    })

}

rad2_server <- function(input, output, session, pickable, default) {
    # valg rader 2
    output$rad2 <- renderUI({
      tags$div(title = "Velg andre grupperingsvariabel",
               selectInput("xcol2",
                           label = "Grupperingsvariabel to",
                           choices = pickable,
                           selected = default
               ))
    })

}

kolonner_server <- function(input, output, session, pickable, default) {
    # valg kolonner
    output$kolonner <- renderUI({
      tags$div(title = "Velg kolonner",
               selectInput("ycol",
                           label = "Kolonner",
                           choices = pickable,
                           selected = default
                           ))
    })

}

verdi_server <- function(input, output, session, pickable, default) {
    # Velg hva som skal tabuleres
    output$verdi <- renderUI({
      tags$div(title = "Velg hva som skal vises",
               selectInput("verdi",
                           label = "Verdi",
                           choices = pickable,
                           selected = default
                           ))
    })

}
