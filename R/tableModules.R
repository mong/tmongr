tab_panel_server <- function(input, output, session) {
    output$tabeller <- shiny::renderUI({
      shiny::absolutePanel(
        (shiny::tabsetPanel(type = "tabs", id = "tab",
                     shiny::tabPanel("Alle kontakter", shiny::tableOutput("alle"), value = "alle"),
                     shiny::tabPanel("Døgnopphold", shiny::tableOutput("dogn"), value = "dogn"),
                     shiny::tabPanel("Dagbehandling", shiny::tableOutput("dag"), value = "dag"),
                     shiny::tabPanel("Poliklinikk", shiny::tableOutput("poli"), value = "poli"),
                     shiny::tabPanel("Informasjon", shiny::fluidPage(shiny::includeMarkdown("Rmd/info.Rmd")))
        )
        )
      )
    })
}
