shinyServer(

  function(input, output) {

    # The data has to be located in the data folder with the name data.RData
    minedata <- NULL
    if (file.exists("data/data.RData")){
      minedata <- get(load("data/data.RData"))
    }

    if (!exists("minedata")){
      minedata <- NULL
    }
    
    listeDatasett <- NULL
    if (exists("minedata")){listeDatasett <- names(minedata)}

    datasett <- reactiveValues(A=NULL)
    meny <- reactiveValues(en = NULL, to = NULL, tre = NULL)

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

      meny$to_default <<- "behandlende_hf"
      if("behandler" %in% colnames(datasett$A)){
        if (!("behandlende_hf" %in% colnames(datasett$A)) & !("behandlende_hf_hn" %in% colnames(datasett$A))){
          meny$default <<- "behandler"
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
        if (length(minedata) == 1){
          dsnavn = names(minedata[1])
          datasett$A <- minedata[[dsnavn]]
        } else {
          datasett$A <- NULL
        }
      } else {
        dsnavn = input$datasett
        datasett$A <- minedata[[dsnavn]]
      }

    })

    makeTable <- reactive({
      verdier <- lageParametere()
      if (is.null(verdier$forenkling)){verdier$forenkling <- TRUE}
      if (is.null(datasett$A)){return(NULL)}
      pivot <- dynamiskTabellverk::makeDataTabell(datasett$A, input$tab, verdier, input$keepNames, input$snitt)
      return(pivot)
    })

    debounced_reactive <- throttle(makeTable, 1000)


    # valg hoveddiagnosegruppe
    output$hdg <- renderUI({
      if ("hoveddiagnosegruppe" %in% colnames(datasett$A)){
        selectInput("hdg",
                    label = "Hoveddiagnosegruppe",
                    choices = c("Alle", unique(datasett$A$hoveddiagnosegruppe)),
                    selected = "Alle")
      }
    })

    # valg ICD10-kapittel
    output$icd10 <- renderUI({
      if ("icd10kap" %in% colnames(datasett$A)){
        selectInput("icd10",
                    label = "ICD10-kapittel",
                    choices = c("Alle", unique(datasett$A$icd10kap)),
                    selected = "Alle")
      }
    })

    # valg fagområde
    output$fag <- renderUI({
      if ("episodefag" %in% colnames(datasett$A)){
        selectInput("fag",
                    label = "Fagområde",
                    choices = c("Alle", unique(datasett$A$episodefag)),
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
                  selected = "boomr_rhf"
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
                           choices = unique(datasett$A$behandlingsniva),
                           selected = unique(datasett$A$behandlingsniva)
        )
      }
    })

    output$hastegrad1 <- renderUI({
      if ("hastegrad" %in% colnames(datasett$A)){
        radioButtons("hastegrad1",
                     label = "Hastegrad",
                     choices = c("Alle", unique(datasett$A$hastegrad)),
                     selected = "Alle"
        )
      }
    })

    output$datasetttekst <- renderUI({
      if (length(listeDatasett)>1){
        HTML("<h4>Datagrunnlag</h4>")
      }
    })

    output$datasett <- renderUI({
      if (length(listeDatasett)>1){
        radioButtons("datasett",
                     label = NULL,
                     choices = listeDatasett,
                     selected = listeDatasett[1]
        )
      }
    })

    output$br_datasett <- renderUI({
      # <br> only if more than one dataset
      if (length(listeDatasett)>1){
        HTML("<br>")
      }
    })

    output$hastegrad2 <- renderUI({
      if ("drgtypehastegrad" %in% colnames(datasett$A)){
        checkboxGroupInput("hastegrad2",
                           label = "DRGtypeHastegrad",
                           choices = unique(datasett$A$drgtypehastegrad),
                           selected = unique(datasett$A$drgtypehastegrad)
        )
      }
    })

    output$alder <- renderUI({
      if ("alder" %in% colnames(datasett$A)){
        checkboxGroupInput("alder",
                           label = "Alder",
                           choices = unique(datasett$A$alder),
                           selected = unique(datasett$A$alder)
        )
      }
    })

    output$kjonn <- renderUI({
      if ("kjonn" %in% colnames(datasett$A)){
        checkboxGroupInput("kjonn",
                           label = "Kjønn",
                           choices = unique(datasett$A$kjonn),
                           selected = unique(datasett$A$kjonn)
        )
      }
    })

    output$aar <- renderUI({
      checkboxGroupInput("ar",
                         label = "År",
                         choices = unique(datasett$A$aar),
                         selected = tail(unique(datasett$A$aar),3)
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
                              "Avtalespesialister" = 8,
                              "Private sykehus" = 9,
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
      HTML("<h4>Variabler</h4>")
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
      aar <- parameterDefinert(input$ar, unique(datasett$A$aar))
      kolonner <- parameterDefinert(input$ycol, "aar")
      alder <- parameterDefinert(input$alder, unique(datasett$A$alder))
      kjonn <- parameterDefinert(input$kjonn, unique(datasett$A$kjonn))
      hastegrad2 <- parameterDefinert(input$hastegrad2, unique(datasett$A$drgtypehastegrad))
      behandlingsniva <- parameterDefinert(input$behandlingsniva, unique(datasett$A$behandlingsniva))
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
