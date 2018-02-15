
shinyServer(
  
  function(input, output) {
    alle_aar <- c("2012", "2013", "2014", "2015", "2016")
    aldersgrupper <- c("0 - 17 år","18 - 49 år","50 - 74 år", "75 år og over")
    behniva <-  c("Døgnopphold","Dagbehandling","Poliklinikk","Avtalespesialist")
    hastegrd <- c("Planlagt medisin","Akutt medisin", "Planlagt kirurgi", "Akutt kirurgi", "Ukjent")
    
    listeDatasett <- names(minedata)
    
    datasett <- reactiveValues(A=NULL)
    meny <- reactiveValues(en = NULL, to = NULL, tre = NULL)
    
    valg_aar <- tail(alle_aar, n=3)
    
    output$tabeller <- renderUI({
      
      absolutePanel(
        (tabsetPanel(type = "tabs", id="tab",
                     tabPanel("Alle kontakter", tableOutput("alle"), value="alle"),
                     tabPanel("Døgnopphold", tableOutput("dogn"), value="dogn"),
                     tabPanel("Dagbehandling", tableOutput("dag"), value="dag"),
                     tabPanel("Poliklinikk", tableOutput("poli"), value="poli"),
                     tabPanel("Informasjon", fluidPage(
                       includeMarkdown("Rmd/info.Rmd")))
#        )
        )
        )#, width = 800
      )
    })
    
    obsA <- observe({
      meny$en <- dynamiskTabellverk::definerValgKol(datasett$A, 1)
      meny$to <- dynamiskTabellverk::definerValgKol(datasett$A, 2)
      meny$tre <- dynamiskTabellverk::definerValgKol(datasett$A, 3)
      meny$fire <- dynamiskTabellverk::definerValgKol(datasett$A, 4)
      
      meny$to_default <<- "behandlende_HF"
      if("Behandler" %in% colnames(datasett$A)){
        if (!("behandlende_HF" %in% colnames(datasett$A)) & !("behandlende_HF_HN" %in% colnames(datasett$A))){
          meny$default <<- "Behandler"
        }
        valgBeh <- c("Alle"=1,
                      "Helse Nord"=2,
                      "Eget lokalsykehus"=3,
                      "UNN Tromsø"=4,
                      "NLSH Bodø"=5,
                      "Annet sykehus i eget HF"=6,
                      "Annet HF i Helse Nord"=7,
                      "Utenfor Helse Nord"=8)
        labelBeh <- "Behandlende sykehus"
      } else {
        valgBeh <- c("Alle"=1,
                      "Helse Nord"=2,
                      "Finnmarkssykehuset"=3,
                      "UNN"=4,
                      "Nordlandssykehuset"=5,
                      "Helgelandssykehuset"=6,
                      "Utenfor Helse Nord"=7)
        labelBeh <- "Behandlende foretak"
      }
      
    })
    obsB <- observe({
      if (is.null(input$datasett)){
        datasett$A <- NULL
      } else {
        dsnavn = input$datasett
        datasett$A <- minedata[[dsnavn]]
      }

    })
    
    makeTable <- reactive({
      verdier <- lageParametere()
      if (is.null(verdier$forenkling)){verdier$forenkling <- TRUE}
      if (is.null(datasett$A)){return(NULL)}
      pivot <- dynamiskTabellverk::makeDataTabell(datasett$A, input$tab, verdier$rader, verdier$kolonner, verdier$verdi,
                                                  verdier$aar, verdier$bo, verdier$beh, verdier$behandlingsniva, verdier$alder, verdier$kjonn, verdier$hastegrad2,
                                                  verdier$prosent, verdier$forenkling, input$keepNames, input$snitt, verdier$hdg, verdier$icd10, verdier$fag)
      return(pivot)
    })
    
    debounced_reactive <- throttle(makeTable, 1000)
    
    
    # valg hoveddiagnosegruppe
    output$hdg <- renderUI({
      if ("Hoveddiagnosegruppe" %in% colnames(datasett$A)){
        selectInput("hdg", 
                    label = "Hoveddiagnosegruppe",
                    choices = c("Alle", unique(datasett$A$Hoveddiagnosegruppe)),
                    selected = "Alle")
      }
    })
    
    # valg ICD10-kapittel
    output$icd10 <- renderUI({
      if ("ICD10Kap" %in% colnames(datasett$A)){
        selectInput("icd10", 
                    label = "ICD10-kapittel",
                    choices = c("Alle", unique(datasett$A$ICD10Kap)),
                    selected = "Alle")
      }
    })
    
    # valg fagområde
    output$fag <- renderUI({
      if ("episodeFag" %in% colnames(datasett$A)){
        selectInput("fag", 
                    label = "Fagområde",
                    choices = c("Alle", unique(datasett$A$episodeFag)),
                    selected = "Alle")
      }
    })
    
    # lage pivot-tabell av totalverdier
    output$alle <- renderTable({
      debounced_reactive()
    })
    
    # døgn-opphold
    output$dogn <- renderTable({
      debounced_reactive()
    })
    
    # dag-opphold
    output$dag <- renderTable({
      debounced_reactive()
    })
    
    # poli-opphold
    output$poli <- renderTable({
      debounced_reactive()
    })
    
    # valg rader 1
    output$rad1 <- renderUI({
      selectInput("xcol1",
                  label = "Grupperingsvariabel en",
                  choices = meny$en,
                  selected = "boomr_RHF"
      )
    })
    
    
    # valg rader 2
    output$rad2 <- renderUI({
      selectInput("xcol2",
                  label = "Grupperingsvariabel to",
                  choices = meny$to,
                  selected = meny$to_default
      )
    })
    
    
    # valg kolonner
    output$kolonner <- renderUI({
      selectInput("ycol", 
                  label = "Kolonner",
                  choices = meny$tre,
                  selected = "aar")
    })
    
    # Velg hva som skal tabuleres
    output$verdi <- renderUI({
      selectInput("verdi", 
                  label = "Verdi",
                  choices = meny$fire,
                  selected = "kontakter")
    })
    
    output$behandlingsniva <- renderUI({
      if ("behandlingsniva" %in% colnames(datasett$A)){
        checkboxGroupInput("behandlingsniva", 
                           label = "Behandlingsnivå",
                           choices = behniva,
                           selected = behniva
        )
      }
    })
    
    output$hastegrad1 <- renderUI({
      if ("hastegrad" %in% colnames(datasett$A)){
        radioButtons("hastegrad1", 
                     label = "Hastegrad",
                     choices = c("Alle", "Akutt","Planlagt"),
                     selected = "Alle"
        )
      }
    })
    
    output$datasett <- renderUI({
      if (length(listeDatasett)>1){
        radioButtons("datasett", 
                     label = "Datasett",
                     choices = listeDatasett,
                     selected = listeDatasett[1]
        )
      }
    })
    
    output$hastegrad2 <- renderUI({
      if ("DRGtypeHastegrad" %in% colnames(datasett$A)){
        checkboxGroupInput("hastegrad2", 
                           label = "DRGtypeHastegrad",
                           choices = hastegrd,
                           selected = hastegrd
        )
      }
    })
    
    output$alder <- renderUI({
      if ("alder" %in% colnames(datasett$A)){
        checkboxGroupInput("alder", 
                           label = "Alder",
                           choices = aldersgrupper,
                           selected = aldersgrupper
        )
      }
    })
    
    output$kjonn <- renderUI({
      if ("kjonn" %in% colnames(datasett$A)){
        checkboxGroupInput("kjonn", 
                           label = "Kjønn",
                           choices = c("Kvinner", "Menn"),
                           selected = c("Kvinner", "Menn")
        )
      }
    })
    
    output$aar <- renderUI({
      checkboxGroupInput("ar", 
                         label = "År",
                         choices = alle_aar,
                         selected = valg_aar
      )
    })
    
    output$bo <- renderUI({
      selectInput("bo", 
                  label = "Opptaksområde",
                  choices = c("Alle"=1,
                              "Helse Nord"=2,
                              "Finnmarkssykehuset"=3,
                              "UNN"=4,
                              "Nordlandssykehuset"=5,
                              "Helgelandssykehuset"=6
                  ),
                  selected = 2)
    })
    
    output$beh <- renderUI({
      selectInput("beh",
                  choices = c("Alle"=1,
                              "Helse Nord"=2,
                              "Finnmarkssykehuset"=3,
                              "UNN"=4,
                              "Nordlandssykehuset"=5,
                              "Helgelandssykehuset"=6,
                              "Utenfor Helse Nord"=7),
                  label = "Behandler",
                  selected = 1
      )
    })
    
    output$knappProsent <- renderUI({
      # Prosentknappen
      # Vises ikke hvis man velger drg_index
      if (is.null(input$verdi)){return()}
      if(input$verdi != "drg_index"){
        checkboxInput("prosent", "Prosent",
                      value = FALSE)
      }
    })
    
    output$knappForenkling <- renderUI({
      if ("behandlende_HF" %in% colnames(datasett$A)){
        checkboxInput("forenkling", "Slå sammen HF utenfor Helse Nord",
                      value = TRUE)
      }
    })
    
    output$knappSnitt <- renderUI({
      checkboxInput("snitt", "Vis snitt/sum",
                    value = TRUE)
    })
    
    output$knappBeholdNavn <- renderUI({
      checkboxInput("keepNames", "Vis alle navn",
                    value = F)
    })
    
    # Download table to cvs file
    output$downloadData <- downloadHandler(
      filename = function() {
        paste('tabellverk_HN-', Sys.Date(), '.csv', sep='')
      },
      content = function(file) {
        write.csv2(makeTable(), file, fileEncoding = "ISO-8859-1", na="", row.names=FALSE)
      }
    )
    
    output$figurtekst <- renderUI({
      verdier <- lageParametere()
      if (is.null(verdier$forenkling)){verdier$forenkling <- FALSE}
      hjelpetekst <- dynamiskTabellverk::lagHjelpetekst(
        input$tab, 
        verdier$rader, 
        verdier$kolonner, 
        verdier$verdi, 
        verdier$aar, 
        verdier$bo, 
        verdier$beh, 
        verdier$prosent, 
        verdier$behandlingsniva, 
        verdier$alder, 
        verdier$kjonn, 
        verdier$hastegrad2, 
        verdier$forenkling)
      HTML(paste("<h4>",hjelpetekst,"</h4>",sep=""))
    })
    
    output$utvalg <- renderUI({
      hjelpetekst <- utvalgTekst(input$tab)
      if (.Platform$OS.type == "windows"){
        hjelpetekst <- iconv(hjelpetekst, "UTF-8", "latin1")}
      hjelpetekst
    })
    
    output$lastned <- renderUI({
      downloadButton('downloadData', 'Last ned data')
    })
    
    output$link <- renderUI({
      bookmarkButton("Lag link", title = "Lag en link med nåværende valg")
    })
    
    output$linje <- renderUI({
      hr()
    })
    
    output$valg <- renderUI({
      HTML("<h4>Valg, tabell</h4>")
    })
    
    output$filter <- renderUI({
      HTML("<h4>Filter</h4>")
    })
    
    output$instilling <- renderUI({
      HTML("<h4>Andre instillinger</h4>")
    })
    
    output$log <- renderUI({
      includeMarkdown("Rmd/log.Rmd")
    })
    
    output$info <- renderUI({
      includeMarkdown("Rmd/info.Rmd")
    })
    
    lageParametere <- reactive({
      
      rader = c(input$xcol1, input$xcol2)
      if (is.null(input$xcol2)){return()}
      if ( (input$xcol2 == "ingen") | (input$xcol2 == input$xcol1)){
        rader = c(input$xcol1)
      }
      
      forenkling <- parameterDefinert(input$forenkling, NULL)
      bo <- parameterDefinert(input$bo, 2)
      beh <- parameterDefinert(input$beh, 1)
      verdi <- parameterDefinert(input$verdi, "kontakter")
      prosent <- parameterDefinert(input$prosent, FALSE)
      aar <- parameterDefinert(input$ar, alle_aar)
      kolonner <- parameterDefinert(input$ycol, "aar")
      alder <- parameterDefinert(input$alder, aldersgrupper)
      kjonn <- parameterDefinert(input$kjonn, c("Kvinner", "Menn"))
      hastegrad2 <- parameterDefinert(input$hastegrad2, hastegrd)
      behandlingsniva <- parameterDefinert(input$behandlingsniva, behniva)
      hdg <- parameterDefinert(input$hdg, "Alle")
      icd10 <- parameterDefinert(input$icd10, "Alle")
      fag <- parameterDefinert(input$fag, "Alle")
      verdier <- list(forenkling = forenkling, bo = bo, beh = beh, verdi = verdi, rader = rader, prosent = prosent, aar = aar, kolonner = kolonner, kjonn = kjonn, alder = alder, hastegrad2 = hastegrad2, behandlingsniva = behandlingsniva, hdg = hdg, icd10 = icd10, fag = fag)
      
      return(verdier)
      
    })
    
    parameterDefinert <- function(param, normalverdi){
      if (is.null(param)){
        return(normalverdi)
      }
      else {
        return(param)
      }
    }
  })
