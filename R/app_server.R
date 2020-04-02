#' Server side logic of the application
#'
#' @param input shiny input components
#' @param output shiny output components
#' @param session the shiny session parameter
#'
#' @return ignored
#' @importFrom rlang .data
#' @export
app_server <- function(input, output, session) {

    datasett <- get_data()
    meny <- shiny::reactiveValues(en = NULL, to = NULL, tre = NULL)

    obsA <- shiny::observe({
      meny$en <- definerValgKol(datasett, 1)
      meny$to <- definerValgKol(datasett, 2)
      meny$tre <- definerValgKol(datasett, 3)
      meny$fire <- definerValgKol(datasett, 4)

      meny$to_default <<- "behandlende_hf"
    })

    makeTable <- shiny::reactive({
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
      pivot <- makeDataTabell(input_data, input$tab, verdier, input$keep_names, input$snitt)
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

    shiny::callModule(rad1_server,
               "rad1",
               pickable = meny$en,
               default = "boomr_rhf")

    shiny::callModule(rad2_server,
               "rad2",
               pickable = meny$to,
               default = meny$to_default)

    shiny::callModule(kolonner_server,
               "kolonner",
               pickable = meny$tre,
               default = "aar")

    shiny::callModule(verdi_server,
               "verdi",
               pickable = meny$fire,
               default = "kontakter")

    shiny::callModule(behandlingsniva_server,
               "behandlingsniva",
               colnames = colnames(datasett),
               pickable = unique(datasett$behandlingsniva))

    shiny::callModule(hastegrad1_server,
               "hastegrad1",
               colnames = colnames(datasett),
               pickable = unique(datasett$hastegrad))

    shiny::callModule(hastegrad2_server,
               "hastegrad2",
               colnames = colnames(datasett),
               pickable = unique(datasett$drgtypehastegrad))

    shiny::callModule(just_overf_server, "just_overf",
               colnames = colnames(datasett))

    shiny::callModule(alder_server, "alder",
               colnames = colnames(datasett),
               pickable = unique(datasett$alder))

    shiny::callModule(kjonn_server, "kjonn",
               colnames = colnames(datasett),
               pickable = unique(datasett$kjonn))

    shiny::callModule(aar_server, "aar",
               pickable = unique(datasett$aar))

    shiny::callModule(bo_server, "bo")

    shiny::callModule(beh_server, "beh")

    shiny::callModule(prosent_server, "prosent")

    shiny::callModule(snitt_server, "snitt")

    shiny::callModule(keep_names_server, "keep_names")

    # Download table to cvs file
    output$downloadData <- shiny::downloadHandler(
      filename = function() {
        paste("tabellverk_HN-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv2(makeTable(), file, fileEncoding = "ISO-8859-1", na = "", row.names = FALSE)
      }
    )

    output$figurtekst <- shiny::renderUI({
      verdier <- lageParametere()
      hjelpetekst <- lagHjelpetekst(
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

    output$lastned <- shiny::renderUI({
      shiny::tags$div(title = "Last ned data i semikolon-delt csv-format. Filen kan åpnes i Excel.",
               shiny::downloadButton("downloadData", "Last ned data")
      )
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

    lageParametere <- shiny::reactive({
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
