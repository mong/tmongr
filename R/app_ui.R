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
              tmongr:::common_ui("just_overf"),
              shiny::uiOutput("valg"),
              tmongr:::common_ui("rad1"),
              tmongr:::common_ui("rad2"),
              shiny::uiOutput("hdg"),
              tmongr:::common_ui("kolonner"),
              tmongr:::common_ui("verdi"),
              shiny::br(),
              shiny::uiOutput("filter"),
              tmongr:::common_ui("bo"),
              tmongr:::common_ui("beh"),
              tmongr:::common_ui("aar"),
              tmongr:::common_ui("behandlingsniva"),
              tmongr:::common_ui("hastegrad1"),
              tmongr:::common_ui("hastegrad2"),
              tmongr:::common_ui("alder"),
              tmongr:::common_ui("kjonn"),
              shiny::br(),
              shiny::uiOutput("instilling"),
              tmongr:::common_ui("prosent"),
              tmongr:::common_ui("keep_names"),
              tmongr:::common_ui("snitt"),
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
