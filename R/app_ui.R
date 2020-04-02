#' Shiny UI
#'
#' @return user interface
#' @export
app_ui <- function() {
  shiny::fluidPage(theme = shinythemes::shinytheme("cerulean"),
            shiny::titlePanel(
              shiny::tags$head(
                shiny::tags$link(rel = "icon",
                                 type = "image/png",
                                 href = "www/hn.png"),
              shiny::tags$title("Pasientstrømmer, Helse Nord RHF"),
              # Farge på linker, samt text inaktive faner
              shiny::tags$style(type = "text/css", "a{color: #808080;}"),
              # Farge på tittel
              shiny::tags$style(type = "text/css", "h1{color: #003A8C;}"),
              # max bredde på side
              shiny::tags$style(type = "text/css",
                                ".container-fluid {  max-width: 1200px;}")
              )
            ),

            shiny::uiOutput("figurtekst"),
            shiny::uiOutput("lastned"),
            shiny::br(),
            shiny::sidebarPanel(
              common_ui("just_overf"),
              shiny::uiOutput("valg"),
              common_ui("rad1"),
              common_ui("rad2"),
              shiny::uiOutput("hdg"),
              common_ui("kolonner"),
              common_ui("verdi"),
              shiny::br(),
              shiny::uiOutput("filter"),
              common_ui("bo"),
              common_ui("beh"),
              common_ui("aar"),
              common_ui("behandlingsniva"),
              common_ui("hastegrad1"),
              common_ui("hastegrad2"),
              common_ui("alder"),
              common_ui("kjonn"),
              shiny::br(),
              shiny::uiOutput("instilling"),
              common_ui("prosent"),
              common_ui("keep_names"),
              common_ui("snitt"),
              width = 3
            ),
            shiny::mainPanel(
                shiny::tabsetPanel(type = "tabs", id = "tab",
                     shiny::tabPanel("Alle kontakter",
                                     shiny::tableOutput("alle"),
                                     value = "alle"),
                     shiny::tabPanel("Døgnopphold",
                                     shiny::tableOutput("dogn"),
                                     value = "dogn"),
                     shiny::tabPanel("Dagbehandling",
                                     shiny::tableOutput("dag"),
                                     value = "dag"),
                     shiny::tabPanel("Poliklinikk",
                                     shiny::tableOutput("poli"),
                                     value = "poli"),
                     shiny::tabPanel("Informasjon",
                                     shiny::fluidPage(
                                       shiny::includeMarkdown(
                                         system.file("app/Rmd/info.Rmd",
                                                     package = getPackageName()
                                                     )
                                         )
                                       )
                                     )
                     ),
              width = 9
            )
  )
}
