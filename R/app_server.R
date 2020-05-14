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
    meny <- shiny::reactiveValues(en = definer_valg_kol(tolower(colnames(datasett)), 1),
                                  to = definer_valg_kol(tolower(colnames(datasett)), 2),
                                  tre = definer_valg_kol(tolower(colnames(datasett)), 3),
                                  fire = definer_valg_kol(tolower(colnames(datasett)), 4)
                                  )

    make_table <- shiny::reactive({
      verdier <- lage_parametere()
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
      pivot <- make_data_tabell(input_data, input$tab, verdier, input$keep_names, input$snitt)
      return(pivot)
    })

    debounced_reactive <- shiny::throttle(make_table, 1000)

    output$alle <- shiny::renderTable({
      debounced_reactive()
    })

    output$dogn <- shiny::renderTable({
      debounced_reactive()
    })

    output$dag <- shiny::renderTable({
      debounced_reactive()
    })

    output$poli <- shiny::renderTable({
      debounced_reactive()
    })

    rad1_server("rad1",
               pickable = meny$en,
               default = "boomr_rhf")

    rad2_server("rad2",
               pickable = meny$to,
               default = "behandlende_hf")

    kolonner_server("kolonner",
               pickable = meny$tre,
               default = "aar")

    verdi_server("verdi",
               pickable = meny$fire,
               default = "kontakter")

    behandlingsniva_server("behandlingsniva",
               colnames = colnames(datasett),
               pickable = unique(datasett$behandlingsniva))

    hastegrad1_server("hastegrad1",
               colnames = colnames(datasett),
               pickable = unique(datasett$hastegrad))

    hastegrad2_server("hastegrad2",
               colnames = colnames(datasett),
               pickable = unique(datasett$drgtypehastegrad))

    just_overf_server("just_overf",
               colnames = colnames(datasett))

    alder_server("alder",
               colnames = colnames(datasett),
               pickable = sort(unique(datasett$alder)))

    kjonn_server("kjonn",
               colnames = colnames(datasett),
               pickable = unique(datasett$kjonn))

    aar_server("aar",
               pickable = sort(unique(datasett$aar)))

    bo_server("bo")

    beh_server("beh",
               pickable = c("Alle",
                            "Helse Nord RHF",
                            sorter_datasett(unique(datasett$behandlende_hf_hn),
                                            rad = "behandlende_hf_hn"
                                            )
                            ),
               default = "Alle")

    prosent_server("prosent")

    snitt_server("snitt")

    keep_names_server("keep_names")

    # Download table to cvs file
    output$download_data <- shiny::downloadHandler(
      filename = function() {
        paste("tabellverk_HN-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        utils::write.csv2(make_table(), file, fileEncoding = "ISO-8859-1", na = "", row.names = FALSE)
      }
    )

    output$figurtekst <- shiny::renderUI({
      verdier <- lage_parametere()
      hjelpetekst <- lag_hjelpetekst(
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
      shiny::tags$div(title = "Last ned data i semikolon-delt csv-format. Filen kan \u00e5pnes i Excel.",
               shiny::downloadButton("download_data", "Last ned data")
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

    lage_parametere <- shiny::reactive({
      rader <- c(input$xcol1, input$xcol2)
      if (is.null(input$xcol2)) {
        return()
      }
      if ((input$xcol2 == "ingen") | (input$xcol2 == input$xcol1)) {
        rader <- c(input$xcol1)
      }

      bo <- parameter_definert(input$bo, 2)
      beh <- parameter_definert(input$beh, "Alle")
      verdi <- parameter_definert(input$verdi, "kontakter")
      prosent <- parameter_definert(input$prosent, FALSE)
      aar <- parameter_definert(input$ar, unique(datasett$aar))
      kolonner <- parameter_definert(input$ycol, "aar")
      alder <- parameter_definert(input$alder, unique(datasett$alder))
      kjonn <- parameter_definert(input$kjonn, unique(datasett$kjonn))
      hastegrad1 <- parameter_definert(input$hastegrad1, unique(datasett$hastegrad))
      hastegrad2 <- parameter_definert(input$hastegrad2, unique(datasett$drgtypehastegrad))
      behandlingsniva <- parameter_definert(input$behandlingsniva, unique(datasett$behandlingsniva))
      verdier <- list(bo = bo, beh = beh, verdi = verdi, rader = rader,
                      prosent = prosent, aar = aar, kolonner = kolonner, kjonn = kjonn, alder = alder,
                      hastegrad1 = hastegrad1, hastegrad2 = hastegrad2, behandlingsniva = behandlingsniva)

      return(verdier)

    })

    parameter_definert <- function(param, normalverdi) {
      if (is.null(param)) {
        return(normalverdi)
      }
      else {
        return(param)
      }
    }
}
