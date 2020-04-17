rad1_server <- function(id, pickable, default) {
  shiny::moduleServer(id, function(input, output, session) {
    # valg rader 1
    output$rad1 <- shiny::renderUI({
      shiny::tags$div(title = "Velg første grupperingsvariabel",
               shiny::selectInput("xcol1",
                           label = "Grupperingsvariabel en",
                           choices = pickable,
                           selected = default
               ))
    })
})
}

rad2_server <- function(id, pickable, default) {
  shiny::moduleServer(id, function(input, output, session) {
    # valg rader 2
    output$rad2 <- shiny::renderUI({
      shiny::tags$div(title = "Velg andre grupperingsvariabel",
               shiny::selectInput("xcol2",
                           label = "Grupperingsvariabel to",
                           choices = pickable,
                           selected = default
               ))
    })
})
}

kolonner_server <- function(id, pickable, default) {
  shiny::moduleServer(id, function(input, output, session) {
    # valg kolonner
    output$kolonner <- shiny::renderUI({
      shiny::tags$div(title = "Velg kolonner",
               shiny::selectInput("ycol",
                           label = "Kolonner",
                           choices = pickable,
                           selected = default
                           ))
    })
})
}

verdi_server <- function(id, pickable, default) {
  shiny::moduleServer(id, function(input, output, session) {
    # Velg hva som skal tabuleres
    output$verdi <- shiny::renderUI({
      shiny::tags$div(title = "Velg hva som skal vises",
               shiny::selectInput("verdi",
                           label = "Verdi",
                           choices = pickable,
                           selected = default
                           ))
    })

})
}

bo_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    output$bo <- shiny::renderUI({
      shiny::tags$div(title = "Velg hvilke pasienter som skal inkluderes, basert på pasientens bosted",
               shiny::selectInput("bo",
                           label = "Opptaksområde",
                           choices = c("Alle" = 1,
                                       "Helse Nord" = 2,
                                       "Finnmarkssykehuset" = 3,
                                       "UNN" = 4,
                                       "Nordlandssykehuset" = 5,
                                       "Helgelandssykehuset" = 6
                           ),
                           selected = 2))
    })
})
}

beh_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    output$beh <- shiny::renderUI({
      shiny::tags$div(title = "Velg hvilke behandlere som skal inkluderes",
               shiny::selectInput("beh",
                           choices = c("Alle" = 1,
                                       "Helse Nord RHF" = 2,
                                       "Finnmarkssykehuset HF" = 3,
                                       "UNN HF" = 4,
                                       "Nordlandssykehuset HF" = 5,
                                       "Helgelandssykehuset HF" = 6,
                                       "Avtalespesialister" = 8,
                                       "Private sykehus" = 9,
                                       "Utenfor Helse Nord RHF" = 7),
                           label = "Behandler",
                           selected = 1
               ))
    })
})
}
