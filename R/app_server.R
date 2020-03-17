#' Server side logic of the application
#'
#' @param input shiny input components
#' @param output shiny output components
#' @param session the shiny session parameter
#'
#' @return ignored
#' @export
#' @importFrom rlang .data
app_server <- function(input, output, session) {

  if (!exists("datasett")) {
    datasett <- dynamiskTabellverk::testdata3
  }
    meny <- shiny::reactiveValues(en = NULL, to = NULL, tre = NULL)

    obsA <- observe({
      meny$en <- dynamiskTabellverk::definerValgKol(datasett, 1)
      meny$to <- dynamiskTabellverk::definerValgKol(datasett, 2)
      meny$tre <- dynamiskTabellverk::definerValgKol(datasett, 3)
      meny$fire <- dynamiskTabellverk::definerValgKol(datasett, 4)

      meny$to_default <<- "behandlende_hf"
    })

    makeTable <- reactive({
      verdier <- lageParametere()
      if (is.null(input$overf)) {
        input_data <- datasett
      } else {
        niva_values <- unique(datasett$niva)
        if (input$overf) {
          input_data <- dplyr::filter(datasett, .data[["niva"]] == niva_values[2])
        } else {
          input_data <- dplyr::filter(datasett, .data[["niva"]] == niva_values[1])
        }
      }
      pivot <- dynamiskTabellverk::makeDataTabell(input_data, input$tab, verdier, input$keep_names, input$snitt)
      return(pivot)
    })

    debounced_reactive <- shiny::throttle(makeTable, 1000)

    # lage pivot-tabell av totalverdier
    output$alle <- shiny::renderTable({
      debounced_reactive()
    })

    # døgnopphold
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

    shiny::callModule(dynamiskTabellverk:::rad1_server,
               "rad1",
               pickable = meny$en,
               default = "boomr_rhf")

    shiny::callModule(dynamiskTabellverk:::rad2_server,
               "rad2",
               pickable = meny$to,
               default = meny$to_default)

    shiny::callModule(dynamiskTabellverk:::kolonner_server,
               "kolonner",
               pickable = meny$tre,
               default = "aar")

    shiny::callModule(dynamiskTabellverk:::verdi_server,
               "verdi",
               pickable = meny$fire,
               default = "kontakter")

    shiny::callModule(dynamiskTabellverk:::behandlingsniva_server,
               "behandlingsniva",
               colnames = colnames(datasett),
               pickable = unique(datasett$behandlingsniva))

    shiny::callModule(dynamiskTabellverk:::hastegrad1_server,
               "hastegrad1",
               colnames = colnames(datasett),
               pickable = unique(datasett$hastegrad))

    shiny::callModule(dynamiskTabellverk:::hastegrad2_server,
               "hastegrad2",
               colnames = colnames(datasett),
               pickable = unique(datasett$drgtypehastegrad))

    shiny::callModule(dynamiskTabellverk:::just_overf_server, "just_overf",
               colnames = colnames(datasett))

    shiny::callModule(dynamiskTabellverk:::alder_server, "alder",
               colnames = colnames(datasett),
               pickable = unique(datasett$alder))

    shiny::callModule(dynamiskTabellverk:::kjonn_server, "kjonn",
               colnames = colnames(datasett),
               pickable = unique(datasett$kjonn))

    shiny::callModule(dynamiskTabellverk:::aar_server, "aar",
               pickable = unique(datasett$aar))

    shiny::callModule(dynamiskTabellverk:::bo_server, "bo")

    shiny::callModule(dynamiskTabellverk:::beh_server, "beh")

    shiny::callModule(dynamiskTabellverk:::prosent_server, "prosent")

    shiny::callModule(dynamiskTabellverk:::snitt_server, "snitt")

    shiny::callModule(dynamiskTabellverk:::keep_names_server, "keep_names")

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
        verdier$hastegrad2)
      shiny::HTML(paste("<h4>", hjelpetekst, "</h4>", sep = ""))
    })

    output$lastned <- renderUI({
      tags$div(title = "Last ned data i semikolon-delt csv-format. Filen kan åpnes i Excel.",
               downloadButton("downloadData", "Last ned data")
      )
    })

    output$valg <- renderUI({
      shiny::HTML("<h4>Variabler</h4>")
    })

    output$filter <- renderUI({
      shiny::HTML("<h4>Filter</h4>")
    })

    output$instilling <- renderUI({
      shiny::HTML("<h4>Andre instillinger</h4>")
    })

    lageParametere <- reactive({
      rader <- c(input$xcol1, input$xcol2)
      if (is.null(input$xcol2)) {
        return()
      }
      if ((input$xcol2 == "ingen") | (input$xcol2 == input$xcol1)) {
        rader <- c(input$xcol1)
      }

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
      verdier <- list(bo = bo, beh = beh, verdi = verdi, rader = rader,
                      prosent = prosent, aar = aar, kolonner = kolonner, kjonn = kjonn, alder = alder,
                      hastegrad1 = hastegrad1, hastegrad2 = hastegrad2, behandlingsniva = behandlingsniva)

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
}
