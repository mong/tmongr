
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
behandlingsniva_server <- function(input, output, session, pickable, colnames) {
    output$behandlingsniva <- shiny::renderUI({
      if ("behandlingsniva" %in% colnames) {
        shiny::tags$div(title = "Velg hvilke behandlingsnivå som skal inkluderes",
                 shiny::checkboxGroupInput("behandlingsniva",
                                    label = "Behandlingsnivå",
                                    choices = pickable,
                                    selected = pickable
                 ))
      }
    })

}

#' @title Module for the hastegrad1 checkbox
#'
#' @rdname checkbox
#' @export
hastegrad1_server <- function(input, output, session, pickable, colnames) {
    output$hastegrad1 <- shiny::renderUI({
      if ("hastegrad" %in% colnames) {
        shiny::tags$div(title = "Velg hvilke hastegrader som skal inkluderes",
                 shiny::checkboxGroupInput("hastegrad1",
                                    label = "Hastegrad",
                                    choices = pickable,
                                    selected = pickable
                 ))
      }
    })
}


#' @title Module for the hastegrad2 checkbox
#'
#' @rdname checkbox
#' @export
hastegrad2_server <- function(input, output, session, pickable, colnames) {
    output$hastegrad2 <- shiny::renderUI({
      if ("drgtypehastegrad" %in% colnames) {
        shiny::tags$div(title = "Velg DRGtypeHastegrad som skal inkluderes.
DRGtypeHastegrad er en kombinasjon av hastegrad og type DRG
(om episoden har en kirurgisk eller medisinsk DRG).",
                 shiny::checkboxGroupInput("hastegrad2",
                                    label = "DRGtypeHastegrad",
                                    choices = pickable,
                                    selected = pickable
                 ))
      }
    })

}


#' @title Module for the kjonn checkbox
#'
#' @rdname checkbox
#' @export
kjonn_server <- function(input, output, session, pickable, colnames) {
    output$kjonn <- shiny::renderUI({
      if ("kjonn" %in% colnames) {
        shiny::tags$div(title = "Velg kjønn som skal inkluderes",
                 shiny::checkboxGroupInput("kjonn",
                                    label = "Kjønn",
                                    choices = pickable,
                                    selected = pickable)
        )
      }
    })
}

#' @title Module for the alder checkbox
#'
#' @rdname checkbox
#' @export
alder_server <- function(input, output, session, pickable, colnames) {
    output$alder <- shiny::renderUI({
      if ("alder" %in% colnames) {
        shiny::tags$div(title = "Velg aldersgrupper som skal inkluderes",
                 shiny::checkboxGroupInput("alder",
                                    label = "Alder",
                                    choices = pickable,
                                    selected = pickable)
        )
      }
    })
}


#' @title Module for the knappProsent checkbox
#'
#' @rdname checkbox
#' @export
prosent_server <- function(input, output, session, pickable) {
    output$prosent <- shiny::renderUI({
      # Prosentknappen
      shiny::tags$div(title = "Vis prosent (vil ikke ha noen effekt for verdi lik DRG-index).",
               shiny::checkboxInput("prosent", "Prosent",
                             value = FALSE))
    })

}

#' @title Module for the knappSnitt checkbox
#'
#' @rdname checkbox
#' @export
snitt_server <- function(input, output, session) {
    output$snitt <- shiny::renderUI({
      shiny::tags$div(title = "Vis snitt i siste kolonne og sum for hver grupperingsvariabel",
               shiny::checkboxInput("snitt", "Vis snitt/sum",
                             value = TRUE))
    })
}

#' @title Module for the keep_name checkbox
#'
#' @rdname checkbox
#' @export
keep_names_server <- function(input, output, session) {
    output$keep_names <- shiny::renderUI({
      shiny::tags$div(title = "Vis repeterende kategori i første kolonne.
Hensiktsmessig før nedlasting av data og videre arbeid i f.eks. Excel.",
               shiny::checkboxInput("keep_names",
                             "Vis alle navn",
                             value = FALSE))
    })
}
