
shinyUI(function(request) {
  fluidPage(theme = shinythemes::shinytheme("cerulean"),
            titlePanel(tags$head(tags$link(rel = "icon", type = "image/png", href = "hn.png"),
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
              dynamiskTabellverk:::just_overf_ui("just_overf"),
              uiOutput("valg"),
              dynamiskTabellverk:::rad1_ui("rad1"),
              dynamiskTabellverk:::rad2_ui("rad2"),
              uiOutput("hdg"),
              dynamiskTabellverk:::kolonner_ui("kolonner"),
              dynamiskTabellverk:::verdi_ui("verdi"),
              br(),
              uiOutput("filter"),
              uiOutput("icd10"),
              uiOutput("fag"),
              dynamiskTabellverk:::aar_ui("bo"),
              dynamiskTabellverk:::aar_ui("beh"),
              dynamiskTabellverk:::aar_ui("aar"),
              dynamiskTabellverk:::behandlingsniva_ui("behandlingsniva"),
              dynamiskTabellverk:::hastegrad1_ui("hastegrad1"),
              dynamiskTabellverk:::hastegrad2_ui("hastegrad2"),
              dynamiskTabellverk:::alder_ui("alder"),
              dynamiskTabellverk:::kjonn_ui("kjonn"),
              br(),
              uiOutput("instilling"),
              dynamiskTabellverk:::prosent_ui("prosent"),
              dynamiskTabellverk:::keep_names_ui("keep_names"),
              dynamiskTabellverk:::forenkling_ui("forenkling"),
              dynamiskTabellverk:::snitt_ui("snitt"),
              width = 3
            ),
            mainPanel(
              uiOutput("tabeller"),
              width = 9
            )
  )
}
)
