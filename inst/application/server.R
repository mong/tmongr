shinyServer(
  function(input, output) {

    # The data has to be located in the data folder with the name data.RData
    if (file.exists("data/data.RData")) {
      minedata <- get(load("data/data.RData"))
    }

    if (!exists("minedata") | isTRUE(getOption("shiny.testmode"))) {
      # Load static/dummy data if this is a test run
      data <- dynamiskTabellverk::testdata
      data2 <- dynamiskTabellverk::testdata2
      minedata <- list(data, data2)
      names(minedata) <- c("data1", "data2")
    }

    listeDatasett <- names(minedata)

    datasett <- reactive({
      if (is.null(input$valg_datasett)) {
        if (length(minedata) == 1) {
          dsnavn <- names(minedata[1])
          return(minedata[[dsnavn]])
        } else {
          return(NULL)
        }
      } else {
        dsnavn <- input$valg_datasett
        return(minedata[[dsnavn]])
      }
    })

    meny <- reactiveValues(en = NULL, to = NULL, tre = NULL)

    output$tabeller <- renderUI({
      absolutePanel(
        (tabsetPanel(
          type = "tabs", id = "tab",
          tabPanel("Alle kontakter", tableOutput("alle"), value = "alle"),
          tabPanel("Døgnopphold", tableOutput("dogn"), value = "dogn"),
          tabPanel("Dagbehandling", tableOutput("dag"), value = "dag"),
          tabPanel("Poliklinikk", tableOutput("poli"), value = "poli"),
          tabPanel("Informasjon", fluidPage(
            includeMarkdown("Rmd/info.Rmd")
          ))
        )
        ) # , width = 800
      )
    })

    obsA <- observe({
      meny$en <- dynamiskTabellverk::definerValgKol(datasett(), 1)
      meny$to <- dynamiskTabellverk::definerValgKol(datasett(), 2)
      meny$tre <- dynamiskTabellverk::definerValgKol(datasett(), 3)
      meny$fire <- dynamiskTabellverk::definerValgKol(datasett(), 4)

      meny$to_default <<- "behandlende_hf"
      if ("behandler" %in% colnames(datasett())) {
        if (!("behandlende_hf" %in% colnames(datasett())) &
            !("behandlende_hf_hn" %in% colnames(datasett()))) {
          meny$default <<- "behandler"
        }
        valgBeh <- c(
          "Alle" = 1,
          "Helse Nord" = 2,
          "Eget lokalsykehus" = 3,
          "UNN Tromsø" = 4,
          "NLSH Bodø" = 5,
          "Annet sykehus i eget HF" = 6,
          "Annet HF i Helse Nord" = 7,
          "Utenfor Helse Nord" = 8
        )
        labelBeh <- "Behandlende sykehus"
      } else {
        valgBeh <- c(
          "Alle" = 1,
          "Helse Nord" = 2,
          "Finnmarkssykehuset" = 3,
          "UNN" = 4,
          "Nordlandssykehuset" = 5,
          "Helgelandssykehuset" = 6,
          "Utenfor Helse Nord" = 7
        )
        labelBeh <- "Behandlende foretak"
      }
    })

    makeTable <- reactive({
      verdier <- lageParametere()
      if (is.null(verdier$forenkling)) {
        verdier$forenkling <- TRUE
      }
      if (is.null(datasett())) {
        return(NULL)
      }
      pivot <- dynamiskTabellverk::makeDataTabell(datasett(),
                                                  input$tab,
                                                  verdier,
                                                  input$keepNames,
                                                  input$snitt)
      return(pivot)
    })

    debounced_reactive <- throttle(makeTable, 1000)


    # valg hoveddiagnosegruppe
    output$hdg <- renderUI({
      if ("hoveddiagnosegruppe" %in% colnames(datasett())) {
        selectInput("hdg",
          label = "Hoveddiagnosegruppe",
          choices = c("Alle", unique(datasett()$hoveddiagnosegruppe)),
          selected = "Alle"
        )
      }
    })

    # valg ICD10-kapittel
    output$icd10 <- renderUI({
      if ("icd10kap" %in% colnames(datasett())) {
        selectInput("icd10",
          label = "ICD10-kapittel",
          choices = c("Alle", unique(datasett()$icd10kap)),
          selected = "Alle"
        )
      }
    })

    # valg fagområde
    output$fag <- renderUI({
      if ("episodefag" %in% colnames(datasett())) {
        selectInput("fag",
          label = "Fagområde",
          choices = c("Alle", unique(datasett()$episodefag)),
          selected = "Alle"
        )
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
        selected = "aar"
      )
    })

    # Velg hva som skal tabuleres
    output$verdi <- renderUI({
      selectInput("verdi",
        label = "Verdi",
        choices = meny$fire,
        selected = "kontakter"
      )
    })

    output$behandlingsniva <- renderUI({
      if ("behandlingsniva" %in% colnames(datasett())) {
        checkboxGroupInput("behandlingsniva",
          label = "Behandlingsnivå",
          choices = unique(datasett()$behandlingsniva),
          selected = unique(datasett()$behandlingsniva)
        )
      }
    })

    output$hastegrad1 <- renderUI({
      if ("hastegrad" %in% colnames(datasett())) {
        checkboxGroupInput("hastegrad1",
          label = "Hastegrad",
          choices = c(unique(datasett()$hastegrad)),
          selected = unique(datasett()$hastegrad)
        )
      }
    })

    output$datasetttekst <- renderUI({
      if (length(listeDatasett) > 1) {
        HTML("<h4>Datagrunnlag</h4>")
      }
    })

    output$datasett <- renderUI({
      if (length(listeDatasett) > 1) {
        radioButtons("valg_datasett",
          label = NULL,
          choices = listeDatasett,
          selected = listeDatasett[1]
        )
      }
    })

    output$br_datasett <- renderUI({
      # <br> only if more than one dataset
      if (length(listeDatasett) > 1) {
        HTML("<br>")
      }
    })

    output$hastegrad2 <- renderUI({
      if ("drgtypehastegrad" %in% colnames(datasett())) {
        checkboxGroupInput("hastegrad2",
          label = "DRGtypeHastegrad",
          choices = unique(datasett()$drgtypehastegrad),
          selected = unique(datasett()$drgtypehastegrad)
        )
      }
    })

    output$alder <- renderUI({
      if ("alder" %in% colnames(datasett())) {
        checkboxGroupInput("alder",
          label = "Alder",
          choices = unique(datasett()$alder),
          selected = unique(datasett()$alder)
        )
      }
    })

    output$kjonn <- renderUI({
      if ("kjonn" %in% colnames(datasett())) {
        checkboxGroupInput("kjonn",
          label = "Kjønn",
          choices = unique(datasett()$kjonn),
          selected = unique(datasett()$kjonn)
        )
      }
    })

    output$aar <- renderUI({
      checkboxGroupInput("ar",
        label = "År",
        choices = unique(datasett()$aar),
        selected = tail(unique(datasett()$aar), 3)
      )
    })

    output$bo <- renderUI({
      selectInput("bo",
        label = "Opptaksområde",
        choices = c(
          "Alle" = 1,
          "Helse Nord" = 2,
          "Finnmarkssykehuset" = 3,
          "UNN" = 4,
          "Nordlandssykehuset" = 5,
          "Helgelandssykehuset" = 6
        ),
        selected = 2
      )
    })

    output$beh <- renderUI({
      selectInput("beh",
        choices = c(
          "Alle" = 1,
          "Helse Nord" = 2,
          "Finnmarkssykehuset" = 3,
          "UNN" = 4,
          "Nordlandssykehuset" = 5,
          "Helgelandssykehuset" = 6,
          "Avtalespesialister" = 8,
          "Private sykehus" = 9,
          "Utenfor Helse Nord" = 7
        ),
        label = "Behandler",
        selected = 1
      )
    })

    output$knappProsent <- renderUI({
      # Prosentknappen
      # Vises ikke hvis man velger drg_index
      if (is.null(input$verdi)) {
        return()
      }
      if (input$verdi != "drg_index") {
        checkboxInput("prosent", "Prosent",
          value = FALSE
        )
      }
    })

    output$knappForenkling <- renderUI({
      if ("behandlende_HF" %in% colnames(datasett())) {
        checkboxInput("forenkling", "Slå sammen HF utenfor Helse Nord",
          value = TRUE
        )
      }
    })

    output$knappSnitt <- renderUI({
      checkboxInput("snitt", "Vis snitt/sum",
        value = TRUE
      )
    })

    output$knappBeholdNavn <- renderUI({
      checkboxInput("keepNames", "Vis alle navn",
        value = F
      )
    })

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
        verdier$forenkling
      )
      HTML(paste("<h4>", hjelpetekst, "</h4>", sep = ""))
    })

    output$lastned <- renderUI({
      downloadButton("downloadData", "Last ned data")
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
      verdier <- list(forenkling = def_param(input$forenkling, NULL),
                      bo = def_param(input$bo, 2),
                      beh = def_param(input$beh, 1),
                      verdi = def_param(input$verdi, "kontakter"),
                      rader = rader,
                      prosent = def_param(input$prosent, FALSE),
                      aar = def_param(input$ar, unique(datasett()$aar)),
                      kolonner = def_param(input$ycol, "aar"),
                      kjonn = def_param(input$kjonn, unique(datasett()$kjonn)),
                      alder = def_param(input$alder, unique(datasett()$alder)),
                      hastegrad1 = def_param(input$hastegrad1,
                                             unique(datasett()$hastegrad)),
                      hastegrad2 = def_param(input$hastegrad2,
                                             unique(datasett()$drgtypehastegrad)),
                      behandlingsniva = def_param(input$behandlingsniva,
                                                  unique(datasett()$behandlingsniva)),
                      hdg = def_param(input$hdg, "Alle"),
                      icd10 = def_param(input$icd10, "Alle"),
                      fag = def_param(input$fag, "Alle"))

      return(verdier)
    })

    def_param <- function(param, normalverdi) {
      if (is.null(param)) {
        return(normalverdi)
      }
      else {
        return(param)
      }
    }
  }
)