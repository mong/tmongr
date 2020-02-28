
#' @param id Shiny id
#'
#' @return
#' @name checkbox
NULL
#> NULL


#' @title Module for the year checkbox
#'
#' @rdname checkbox
#' @export
aar_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("aar"))
}

aar_server <- function(input, output, session, pickable) {
    output$aar <- shiny::renderUI({
      shiny::tags$div(title = "Velg år som skal inkluderes",
               shiny::checkboxGroupInput("ar",
                                  label = "År",
                                  choices = pickable,
                                  selected = tail(pickable, 3)
               ))
    })
}

#' @title Module for the behandlingsniva checkbox
#'
#' @rdname checkbox
#' @export
behandlingsniva_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("behandlingsniva"))
}

#' @title Module for the hastegrad1 checkbox
#'
#' @rdname checkbox
#' @export
hastegrad1_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("hastegrad1"))
}

#' @title Module for the hastegrad2 checkbox
#'
#' @rdname checkbox
#' @export
hastegrad2_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("hastegrad2"))
}

#' @title Module for the kjonn checkbox
#'
#' @rdname checkbox
#' @export
kjonn_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("kjonn"))
}

#' @title Module for the knappProsent checkbox
#'
#' @rdname checkbox
#' @export
knappProsent_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("knappProsent"))
}

#' @title Module for the knappForenkling checkbox
#'
#' @rdname checkbox
#' @export
knappForenkling_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("knappForenkling"))
}

#' @title Module for the knappSnitt checkbox
#'
#' @rdname checkbox
#' @export
knappSnitt_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::uiOutput(ns("knappSnitt"))
}
