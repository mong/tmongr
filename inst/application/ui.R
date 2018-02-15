
shinyUI(function(request){
  fluidPage(theme = shinythemes::shinytheme("cerulean"),
            titlePanel(tags$head(tags$link(rel = "icon", type = "image/png", href = "hn.png"),
                                 tags$title("Pasientstrømmer, Helse Nord RHF"),
                                 tags$style(type = "text/css", "a{color: #808080;}"), # Farge på linker, samt text inaktive faner
                                 #                                 tags$style(type = "text/css", "a{color: #C0C0C0;}"), # Farge på linker, samt text inaktive faner
                                 tags$style(type = "text/css", "h1{color: #003A8C;}"), # Farge på tittel
                                 tags$style(type="text/css", ".container-fluid {  max-width: 1200px;}") # max bredde på side
                                 
            )
            ),
            
            uiOutput('figurtekst'),
            uiOutput('lastned'),
            br(),
            sidebarPanel(
              uiOutput('datasett'),
              uiOutput('valg'),
              uiOutput('rad1'),
              uiOutput('rad2'),
              uiOutput('hdg'),
              uiOutput('kolonner'),
              uiOutput('verdi'),
              br(),
              uiOutput('filter'),
              uiOutput('icd10'),
              uiOutput('fag'),
              uiOutput('bo'),
              uiOutput('beh'),
              uiOutput('aar'),
              #    hr(),
              
              uiOutput('behandlingsniva'),
              uiOutput('hastegrad2'),
              uiOutput('alder'),
              uiOutput('kjonn'),
              br(),
              uiOutput('instilling'),
              uiOutput('knappProsent'),
              uiOutput('knappBeholdNavn'),
              uiOutput('knappForenkling'),
              uiOutput('knappSnitt'),
              #    hr(),
              #    uiOutput('link'),
              width = 3
            ),
            mainPanel(
              uiOutput('tabeller'),
              width = 9
            )
  )
}
)

