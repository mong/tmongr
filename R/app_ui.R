#' Shiny UI
#'
#' @return user interface
#' @export
app_ui <- function() {
  fluidPage(theme = shinythemes::shinytheme("cerulean"),
            titlePanel(tags$head(tags$link(rel = "icon", type = "image/png", href = "www/hn.png"),
                                 tags$title("Pasientstrømmer, Helse Nord RHF"),
                                 # Farge på linker, samt text inaktive faner
                                 tags$style(type = "text/css", "a{color: #808080;}"),
                                 # Farge på tittel
                                 tags$style(type = "text/css", "h1{color: #003A8C;}"),
                                 # max bredde på side
                                 tags$style(type = "text/css", ".container-fluid {  max-width: 1200px;}")

            )
            ),

            uiOutput("figurtekst"),
            uiOutput("lastned"),
            br(),
            sidebarPanel(
              dynamiskTabellverk:::common_ui("just_overf"),
              uiOutput("valg"),
              dynamiskTabellverk:::common_ui("rad1"),
              dynamiskTabellverk:::common_ui("rad2"),
              uiOutput("hdg"),
              dynamiskTabellverk:::common_ui("kolonner"),
              dynamiskTabellverk:::common_ui("verdi"),
              br(),
              uiOutput("filter"),
              dynamiskTabellverk:::common_ui("bo"),
              dynamiskTabellverk:::common_ui("beh"),
              dynamiskTabellverk:::common_ui("aar"),
              dynamiskTabellverk:::common_ui("behandlingsniva"),
              dynamiskTabellverk:::common_ui("hastegrad1"),
              dynamiskTabellverk:::common_ui("hastegrad2"),
              dynamiskTabellverk:::common_ui("alder"),
              dynamiskTabellverk:::common_ui("kjonn"),
              br(),
              uiOutput("instilling"),
              dynamiskTabellverk:::common_ui("prosent"),
              dynamiskTabellverk:::common_ui("keep_names"),
              dynamiskTabellverk:::common_ui("snitt"),
              width = 3
            ),
            mainPanel(
                shiny::tabsetPanel(type = "tabs", id = "tab",
                     shiny::tabPanel("Alle kontakter", shiny::tableOutput("alle"), value = "alle"),
                     shiny::tabPanel("Døgnopphold", shiny::tableOutput("dogn"), value = "dogn"),
                     shiny::tabPanel("Dagbehandling", shiny::tableOutput("dag"), value = "dag"),
                     shiny::tabPanel("Poliklinikk", shiny::tableOutput("poli"), value = "poli"),
                     shiny::tabPanel("Informasjon", shiny::fluidPage(shiny::includeMarkdown(system.file("app/Rmd/info.Rmd", package = getPackageName()))))
                     ),
              width = 9
            )
  )
}