
shinyUI(function(request){
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
              dynamiskTabellverk:::just_overfUI("num1"),
              uiOutput("valg"),
              uiOutput("rad1"),
              uiOutput("rad2"),
              uiOutput("hdg"),
              uiOutput("kolonner"),
              uiOutput("verdi"),
              br(),
              uiOutput("filter"),
              uiOutput("icd10"),
              uiOutput("fag"),
              uiOutput("bo"),
              uiOutput("beh"),
              uiOutput("aar"),

              uiOutput("behandlingsniva"),
              uiOutput("hastegrad1"),
              uiOutput("hastegrad2"),
              uiOutput("alder"),
              uiOutput("kjonn"),
              br(),
              uiOutput("instilling"),
              uiOutput("knappProsent"),
              tags$div(title = "
Legg på tekst i alle celler i første kolonne.
Bør gjøres før man laster ned data hvis man vil etterbehandle dataene eksternt (f.eks i Excel).",
                       uiOutput("knappBeholdNavn")
              ),
              uiOutput("knappForenkling"),
              uiOutput("knappSnitt"),
              width = 3
            ),
            mainPanel(
              uiOutput("tabeller"),
              width = 9
            )
  )
}
)
