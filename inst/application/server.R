shiny::shinyServer(
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

    list_datasets <- names(minedata)

    datasett <- shiny::reactive({
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

    meny <- shiny::reactiveValues(en = NULL, to = NULL, tre = NULL)

    output$tabeller <- shiny::renderUI({
      shiny::absolutePanel(
        (shiny::tabsetPanel(
          type = "tabs", id = "tab",
          shiny::tabPanel("Alle kontakter", shiny::tableOutput("alle"), value = "alle"),
          shiny::tabPanel("Døgnopphold", shiny::tableOutput("dogn"), value = "dogn"),
          shiny::tabPanel("Dagbehandling", shiny::tableOutput("dag"), value = "dag"),
          shiny::tabPanel("Poliklinikk", shiny::tableOutput("poli"), value = "poli"),
          shiny::tabPanel("Informasjon", shiny::fluidPage(
            shiny::includeMarkdown("Rmd/info.Rmd")
          ))
        )
        ) # , width = 800
      )
    })

    obs_a <- shiny::observe({
      meny$en <- dynamiskTabellverk::definerValgKol(datasett(), 1)
      meny$to <- dynamiskTabellverk::definerValgKol(datasett(), 2)
      meny$tre <- dynamiskTabellverk::definerValgKol(datasett(), 3)
      meny$fire <- dynamiskTabellverk::definerValgKol(datasett(), 4)
      meny$to_default <<- "behandlende_hf"
    })

    make_table <- shiny::reactive({
      verdier <- lage_parametere()
      if (is.null(verdier$forenkling)) {
        verdier$forenkling <- TRUE
      }
      if (is.null(datasett())) {
        return(NULL)
      }
      pivot <- dynamiskTabellverk::makeDataTabell(
        datasett(),
        input$tab,
        verdier,
        input$keep_names,
        input$snitt
      )
      return(pivot)
    })

    debounced_reactive <- shiny::throttle(make_table, 1000)


    # valg hoveddiagnosegruppe
    output$hdg <- shiny::renderUI({
      if ("hoveddiagnosegruppe" %in% colnames(datasett())) {
        shiny::selectInput("hdg",
          label = "Hoveddiagnosegruppe",
          choices = c("Alle", unique(datasett()$hoveddiagnosegruppe)),
          selected = "Alle"
        )
      }
    })

    # valg ICD10-kapittel
    output$icd10 <- shiny::renderUI({
      if ("icd10kap" %in% colnames(datasett())) {
        shiny::selectInput("icd10",
          label = "ICD10-kapittel",
          choices = c("Alle", unique(datasett()$icd10kap)),
          selected = "Alle"
        )
      }
    })

    # valg fagområde
    output$fag <- shiny::renderUI({
      if ("episodefag" %in% colnames(datasett())) {
        shiny::selectInput("fag",
          label = "Fagområde",
          choices = c("Alle", unique(datasett()$episodefag)),
          selected = "Alle"
        )
      }
    })

    # lage pivot-tabell av totalverdier
    output$alle <- shiny::renderTable({
      debounced_reactive()
    })

    # dognopphold
    output$dogn <- shiny::renderTable({
      debounced_reactive()
    })

    # dagopphold
    output$dag <- shiny::renderTable({
      debounced_reactive()
    })

    # poliopphold
    output$poli <- shiny::renderTable({
      debounced_reactive()
    })

    # valg rader 1
    output$rad1 <- shiny::renderUI({
      shiny::selectInput("xcol1",
        label = "Grupperingsvariabel en",
        choices = meny$en,
        selected = "boomr_rhf"
      )
    })


    # valg rader 2
    output$rad2 <- shiny::renderUI({
      shiny::selectInput("xcol2",
        label = "Grupperingsvariabel to",
        choices = meny$to,
        selected = meny$to_default
      )
    })


    # valg kolonner
    output$kolonner <- shiny::renderUI({
      shiny::selectInput("ycol",
        label = "Kolonner",
        choices = meny$tre,
        selected = "aar"
      )
    })

    # Velg hva som skal tabuleres
    output$verdi <- shiny::renderUI({
      shiny::selectInput("verdi",
        label = "Verdi",
        choices = meny$fire,
        selected = "kontakter"
      )
    })

    output$behandlingsniva <- shiny::renderUI({
      if ("behandlingsniva" %in% colnames(datasett())) {
        shiny::checkboxGroupInput("behandlingsniva",
          label = "Behandlingsnivå",
          choices = unique(datasett()$behandlingsniva),
          selected = unique(datasett()$behandlingsniva)
        )
      }
    })

    output$hastegrad1 <- shiny::renderUI({
      if ("hastegrad" %in% colnames(datasett())) {
        shiny::checkboxGroupInput("hastegrad1",
          label = "Hastegrad",
          choices = c(unique(datasett()$hastegrad)),
          selected = unique(datasett()$hastegrad)
        )
      }
    })

    output$datasetttekst <- shiny::renderUI({
      if (length(list_datasets) > 1) {
        shiny::HTML("<h4>Datagrunnlag</h4>")
      }
    })

    output$datasett <- shiny::renderUI({
      if (length(list_datasets) > 1) {
        shiny::radioButtons("valg_datasett",
          label = NULL,
          choices = list_datasets,
          selected = list_datasets[1]
        )
      }
    })

    output$br_datasett <- shiny::renderUI({
      # <br> only if more than one dataset
      if (length(list_datasets) > 1) {
        shiny::HTML("<br>")
      }
    })

    output$hastegrad2 <- shiny::renderUI({
      if ("drgtypehastegrad" %in% colnames(datasett())) {
        shiny::checkboxGroupInput("hastegrad2",
          label = "DRGtypeHastegrad",
          choices = unique(datasett()$drgtypehastegrad),
          selected = unique(datasett()$drgtypehastegrad)
        )
      }
    })

    output$alder <- shiny::renderUI({
      if ("alder" %in% colnames(datasett())) {
        shiny::checkboxGroupInput("alder",
          label = "Alder",
          choices = unique(datasett()$alder),
          selected = unique(datasett()$alder)
        )
      }
    })

    output$kjonn <- shiny::renderUI({
      if ("kjonn" %in% colnames(datasett())) {
        shiny::checkboxGroupInput("kjonn",
          label = "Kjønn",
          choices = unique(datasett()$kjonn),
          selected = unique(datasett()$kjonn)
        )
      }
    })

    output$aar <- shiny::renderUI({
      shiny::checkboxGroupInput("ar",
        label = "År",
        choices = unique(datasett()$aar),
        selected = tail(unique(datasett()$aar), 3)
      )
    })

    output$bo <- shiny::renderUI({
      shiny::selectInput("bo",
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

    output$beh <- shiny::renderUI({
      shiny::selectInput("beh",
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

    output$knapp_prosent <- shiny::renderUI({
      # Prosentknappen
      # Vises ikke hvis man velger drg_index
      if (is.null(input$verdi)) {
        return()
      }
      if (input$verdi != "drg_index") {
        shiny::checkboxInput("prosent", "Prosent",
          value = FALSE
        )
      }
    })

    output$knapp_forenkling <- shiny::renderUI({
      if ("behandlende_HF" %in% colnames(datasett())) {
        shiny::checkboxInput("forenkling", "Slå sammen HF utenfor Helse Nord",
          value = TRUE
        )
      }
    })

    output$knapp_snitt <- shiny::renderUI({
      shiny::checkboxInput("snitt", "Vis snitt/sum",
        value = TRUE
      )
    })

    output$knapp_behold_navn <- shiny::renderUI({
      shiny::checkboxInput("keep_names", "Vis alle navn",
        value = F
      )
    })

    # Download table to cvs file
    output$download_data <- shiny::downloadHandler(
      filename = function() {
        paste("tabellverk_HN-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv2(make_table(), file, fileEncoding = "ISO-8859-1", na = "", row.names = FALSE)
      }
    )

    output$figurtekst <- shiny::renderUI({
      verdier <- lage_parametere()
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
      shiny::HTML(paste("<h4>", hjelpetekst, "</h4>", sep = ""))
    })

    output$lastned <- shiny::renderUI({
      downloadButton("download_data", "Last ned data")
    })

    output$link <- shiny::renderUI({
      bookmarkButton("Lag link", title = "Lag en link med nåværende valg")
    })

    output$linje <- shiny::renderUI({
      hr()
    })

    output$valg <- shiny::renderUI({
      shiny::HTML("<h4>Variabler</h4>")
    })

    output$filter <- shiny::renderUI({
      shiny::HTML("<h4>Filter</h4>")
    })

    output$instilling <- shiny::renderUI({
      shiny::HTML("<h4>Andre instillinger</h4>")
    })

    output$log <- shiny::renderUI({
      includeMarkdown("Rmd/log.Rmd")
    })

    output$info <- shiny::renderUI({
      includeMarkdown("Rmd/info.Rmd")
    })

    lage_parametere <- reactive({
      rader <- c(input$xcol1, input$xcol2)
      if (is.null(input$xcol2)) {
        return()
      }
      if ((input$xcol2 == "ingen") | (input$xcol2 == input$xcol1)) {
        rader <- c(input$xcol1)
      }
      verdier <- list(
        forenkling = def_param(input$forenkling, NULL),
        bo = def_param(input$bo, 2),
        beh = def_param(input$beh, 1),
        verdi = def_param(input$verdi, "kontakter"),
        rader = rader,
        prosent = def_param(input$prosent, FALSE),
        aar = def_param(input$ar, unique(datasett()$aar)),
        kolonner = def_param(input$ycol, "aar"),
        kjonn = def_param(input$kjonn, unique(datasett()$kjonn)),
        alder = def_param(input$alder, unique(datasett()$alder)),
        hastegrad1 = def_param(
          input$hastegrad1,
          unique(datasett()$hastegrad)
        ),
        hastegrad2 = def_param(
          input$hastegrad2,
          unique(datasett()$drgtypehastegrad)
        ),
        behandlingsniva = def_param(
          input$behandlingsniva,
          unique(datasett()$behandlingsniva)
        ),
        hdg = def_param(input$hdg, "Alle"),
        icd10 = def_param(input$icd10, "Alle"),
        fag = def_param(input$fag, "Alle")
      )

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
