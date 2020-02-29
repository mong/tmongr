shinyServer(

  function(input, output, session) {

    # The data has to be located in the data folder with the name data.RData
    datasett <- NULL
    if (file.exists("data/data.RData")) {
      datasett <- get(load("data/data.RData"))
    }

    meny <- reactiveValues(en = NULL, to = NULL, tre = NULL)

    output$tabeller <- renderUI({

      absolutePanel(
        (tabsetPanel(type = "tabs", id = "tab",
                     tabPanel("Alle kontakter", tableOutput("alle"), value = "alle"),
                     tabPanel("Døgnopphold", tableOutput("dogn"), value = "dogn"),
                     tabPanel("Dagbehandling", tableOutput("dag"), value = "dag"),
                     tabPanel("Poliklinikk", tableOutput("poli"), value = "poli"),
                     tabPanel("Informasjon", fluidPage(
                       includeMarkdown("Rmd/info.Rmd")))
        )
        )
      )
    })

    obsA <- observe({
      meny$en <- dynamiskTabellverk::definerValgKol(datasett, 1)
      meny$to <- dynamiskTabellverk::definerValgKol(datasett, 2)
      meny$tre <- dynamiskTabellverk::definerValgKol(datasett, 3)
      meny$fire <- dynamiskTabellverk::definerValgKol(datasett, 4)

      meny$to_default <<- "behandlende_hf"
      if ("behandler" %in% colnames(datasett)) {
        if (!("behandlende_hf" %in% colnames(datasett)) & !("behandlende_hf_hn" %in% colnames(datasett))) {
          meny$default <<- "behandler"
        }
        valgBeh <- c("Alle" = 1,
                     "Helse Nord" = 2,
                     "Eget lokalsykehus" = 3,
                     "UNN Tromsø" = 4,
                     "NLSH Bodø" = 5,
                     "Annet sykehus i eget HF" = 6,
                     "Annet HF i Helse Nord" = 7,
                     "Utenfor Helse Nord" = 8)
        labelBeh <- "Behandlende sykehus"
      } else {
        valgBeh <- c("Alle" = 1,
                     "Helse Nord" = 2,
                     "Finnmarkssykehuset" = 3,
                     "UNN" = 4,
                     "Nordlandssykehuset" = 5,
                     "Helgelandssykehuset" = 6,
                     "Utenfor Helse Nord" = 7)
        labelBeh <- "Behandlende foretak"
      }
    })

    makeTable <- reactive({
      verdier <- lageParametere()
      if (is.null(verdier$forenkling)) {
        verdier$forenkling <- TRUE
      }
      if (is.null(datasett)) {
        return(NULL)
      }
      if (is.null(input$overf)) {
        input_data <- datasett
      } else {
        niva_values <- unique(datasett$niva)
        if (input$overf) {
          input_data <- dplyr::filter(datasett, niva == niva_values[2])
        } else {
          input_data <- dplyr::filter(datasett, niva == niva_values[1])
        }
      }
      pivot <- dynamiskTabellverk::makeDataTabell(input_data, input$tab, verdier, input$keep_names, input$snitt)
      return(pivot)
    })

    debounced_reactive <- throttle(makeTable, 1000)

    # valg hoveddiagnosegruppe
    output$hdg <- renderUI({
      if ("hoveddiagnosegruppe" %in% colnames(datasett)) {
        tags$div(title = "Velg hvilken hoveddiagnosegruppe som skal vises",
                 selectInput("hdg",
                             label = "Hoveddiagnosegruppe",
                             choices = c("Alle", unique(datasett$hoveddiagnosegruppe)),
                             selected = "Alle"))
      }
    })

    # valg ICD10-kapittel
    output$icd10 <- renderUI({
      if ("icd10kap" %in% colnames(datasett)) {
        tags$div(title = "Velg hvilket ICD10-kapittel som skal vises",
                 selectInput("icd10",
                             label = "ICD10-kapittel",
                             choices = c("Alle", unique(datasett$icd10kap)),
                             selected = "Alle"))
      }
    })

    # valg fagområde
    output$fag <- renderUI({
      if ("episodefag" %in% colnames(datasett)) {
        tags$div(title = "Velg hvilket fagområde (fagområdet for episoden) som skal vises",
                 selectInput("fag",
                             label = "Fagområde",
                             choices = c("Alle", unique(datasett$episodefag)),
                             selected = "Alle"))
      }
    })

    # lage pivot-tabell av totalverdier
    output$alle <- renderTable({
      debounced_reactive()
    })

    # døgnopphold
    output$dogn <- renderTable({
      debounced_reactive()
    })

    # dagopphold
    output$dag <- renderTable({
      debounced_reactive()
    })

    # poliopphold
    output$poli <- renderTable({
      debounced_reactive()
    })

    callModule(dynamiskTabellverk:::rad1_server,
               "rad1",
               pickable = meny$en,
               default = "boomr_rhf")

    callModule(dynamiskTabellverk:::rad2_server,
               "rad2",
               pickable = meny$to,
               default = meny$to_default)

    callModule(dynamiskTabellverk:::kolonner_server,
               "kolonner",
               pickable = meny$tre,
               default = "aar")

    callModule(dynamiskTabellverk:::verdi_server,
               "verdi",
               pickable = meny$fire,
               default = "kontakter")

    callModule(dynamiskTabellverk:::behandlingsniva_server,
               "behandlingsniva",
               colnames = colnames(datasett),
               pickable = unique(datasett$behandlingsniva))

    callModule(dynamiskTabellverk:::hastegrad1_server,
               "hastegrad1",
               colnames = colnames(datasett),
               pickable = unique(datasett$hastegrad))

    callModule(dynamiskTabellverk:::hastegrad2_server,
               "hastegrad2",
               colnames = colnames(datasett),
               pickable = unique(datasett$drgtypehastegrad))

    callModule(dynamiskTabellverk:::just_overf_server, "just_overf",
               colnames = colnames(datasett))

    callModule(dynamiskTabellverk:::alder_server, "alder",
               colnames = colnames(datasett),
               pickable = unique(datasett$alder))

    callModule(dynamiskTabellverk:::kjonn_server, "kjonn",
               colnames = colnames(datasett),
               pickable = unique(datasett$kjonn))

    callModule(dynamiskTabellverk:::aar_server, "aar",
               pickable = unique(datasett$aar))

    callModule(dynamiskTabellverk:::aar_server, "bo")

    output$beh <- renderUI({
      tags$div(title = "Velg hvilke behandlere som skal inkluderes",
               selectInput("beh",
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

    callModule(dynamiskTabellverk:::prosent_server, "prosent")

    callModule(dynamiskTabellverk:::forenkling_server, "forenkling",
               colnames = colnames(datasett))

    callModule(dynamiskTabellverk:::snitt_server, "snitt")

    callModule(dynamiskTabellverk:::keep_names_server, "keep_names")

    # Download table to cvs file
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("tabellverk_HN-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv2(makeTable(), file, fileEncoding = "ISO-8859-1", na = "", row.names = FALSE)
      }
    )

    output$figurtekst <- renderUI({
      verdier <- lageParametere()
      if (is.null(verdier$forenkling)) {
        verdier$forenkling <- FALSE
      }
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
      HTML(paste("<h4>", hjelpetekst, "</h4>", sep = ""))
    })

    output$lastned <- renderUI({
      tags$div(title = "Last ned data i semikolon-delt csv-format. Filen kan åpnes i Excel.",
               downloadButton("downloadData", "Last ned data")
      )
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
      rader <- c(input$xcol1, input$xcol2)
      if (is.null(input$xcol2)) {
        return()
      }
      if ((input$xcol2 == "ingen") | (input$xcol2 == input$xcol1)) {
        rader <- c(input$xcol1)
      }

      forenkling <- parameterDefinert(input$forenkling, NULL)
      bo <- parameterDefinert(input$bo, 2)
      beh <- parameterDefinert(input$beh, 1)
      verdi <- parameterDefinert(input$verdi, "kontakter")
      prosent <- parameterDefinert(input$prosent, FALSE)
      aar <- parameterDefinert(input$ar, unique(datasett$aar))
      kolonner <- parameterDefinert(input$ycol, "aar")
      alder <- parameterDefinert(input$alder, unique(datasett$alder))
      kjonn <- parameterDefinert(input$kjonn, unique(datasett$kjonn))
      hastegrad1 <- parameterDefinert(input$hastegrad1, unique(datasett$hastegrad))
      hastegrad2 <- parameterDefinert(input$hastegrad2, unique(datasett$drgtypehastegrad))
      behandlingsniva <- parameterDefinert(input$behandlingsniva, unique(datasett$behandlingsniva))
      hdg <- parameterDefinert(input$hdg, "Alle")
      icd10 <- parameterDefinert(input$icd10, "Alle")
      fag <- parameterDefinert(input$fag, "Alle")
      verdier <- list(forenkling = forenkling, bo = bo, beh = beh, verdi = verdi, rader = rader,
                      prosent = prosent, aar = aar, kolonner = kolonner, kjonn = kjonn, alder = alder,
                      hastegrad1 = hastegrad1, hastegrad2 = hastegrad2, behandlingsniva = behandlingsniva,
                      hdg = hdg, icd10 = icd10, fag = fag)

      return(verdier)

    })

    parameterDefinert <- function(param, normalverdi) {
      if (is.null(param)) {
        return(normalverdi)
      }
      else {
        return(param)
      }
    }
  })
