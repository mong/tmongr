
#' Define the possible selections
#'
#' Based on the content of the data
#'
#' @param datasett Datasett
#' @param valgnr Hvilket valg
#'
#' @return valg_en valg_to valg_tre
#' @export
#'
definer_valg_kol <- function(col_names, valgnr) {
  config <- get_config()$menus

  valg_boomr_sh <- stats::setNames(config$valg_boomr_sh$variable,
                            config$valg_boomr_sh$txt)
  valg_boomr_hf <- stats::setNames(config$valg_boomr_hf$variable,
                            config$valg_boomr_hf$txt)
  valg_boomr_rhf <- stats::setNames(config$valg_boomr_rhf$variable,
                             config$valg_boomr_rhf$txt)

  valg_aar <- stats::setNames(config$valg_aar$variable,
                       config$valg_aar$txt)

    valg_alder <- c()
    valg_kjonn <- c()
    valg_behandlingsniva <- c()
    valg_hastegrad <- c()
    valg_drgtypehastegrad <- c()
    valg_behandler <- c()
    valg_behsh <- c()
    valg_behhf <- c()
    valg_behrhf <- c()
    valg_alder <- c()
    valg_alder <- c()
    valg_fag <- c()
    valg_fagavtspes <- c()

    # Verdier
    valg_kontakter <- stats::setNames(config$valg_kontakter$variable,
                               config$valg_kontakter$txt)
    valg_rate <- stats::setNames(config$valg_rate$variable,
                          config$valg_rate$txt)
    valg_liggetid <- stats::setNames(config$valg_liggetid$variable,
                              config$valg_liggetid$txt)
    valg_liggerate <- c()
    valg_liggeindex <- stats::setNames(config$valg_liggeindex$variable,
                                config$valg_liggeindex$txt)
    valg_drg <- stats::setNames(config$valg_drg$variable,
                        config$valg_drg$txt)
    valg_drgrate <- stats::setNames(config$valg_drgrate$variable,
                             config$valg_drgrate$txt)
    valg_drgindex <- stats::setNames(config$valg_drgindex$variable,
                              config$valg_drgindex$txt)

    if ("alder" %in% col_names) {
        valg_alder <- stats::setNames(config$valg_alder$variable,
                               config$valg_alder$txt)
    }
    if ("kjonn" %in% col_names) {
        valg_kjonn <- stats::setNames(config$valg_kjonn$variable,
                               config$valg_kjonn$txt)
    }
    if ("behandlingsniva" %in% col_names) {
        valg_behandlingsniva <- stats::setNames(config$valg_behandlingsniva$variable,
                                         config$valg_behandlingsniva$txt)
    }
    if ("hastegrad" %in% col_names) {
        valg_hastegrad <- stats::setNames(config$valg_hastegrad$variable,
                                   config$valg_hastegrad$txt)
    }
    if ("drgtypehastegrad" %in% col_names) {
        valg_drgtypehastegrad <- stats::setNames(config$valg_drgtypehastegrad$variable,
                                          config$valg_drgtypehastegrad$txt)
    }
    if ("behandler" %in% col_names) {
        valg_behandler <- stats::setNames(config$valg_behandler$variable,
                                   config$valg_behandler$txt)
    }
    if ("behandlende_sykehus" %in% col_names) {
        valg_behsh <- stats::setNames(config$valg_behsh$variable,
                               config$valg_behsh$txt)
    }
    if (("behandlende_hf" %in% col_names) | ("behandlende_hf_hn" %in% col_names)) {
        valg_behhf <- stats::setNames(config$valg_behhf$variable,
                               config$valg_behhf$txt)
    }
    if ("behandlende_rhf" %in% col_names) {
        valg_behrhf <- stats::setNames(config$valg_behrhf$variable,
                                config$valg_behrhf$txt)
    }
    if ("bosh_liggerate" %in% col_names &
        "bohf_liggerate" %in% col_names &
        "borhf_liggerate" %in% col_names) {
        valg_liggerate <- stats::setNames(config$valg_liggerate$variable,
                                   config$valg_liggerate$txt)
    }

    if ("episodefag" %in% col_names) {
      valg_fag <- stats::setNames(config$valg_fag$variable,
                                  config$valg_fag$txt)
    }

    if ("fag_skde" %in% col_names) {
      valg_fagavtspes <- c(`Fagfelt avtalespesialist` = "fag_skde")
    }

    valg_en <- c(valg_boomr_sh, valg_boomr_hf, valg_boomr_rhf, valg_aar, valg_alder, valg_kjonn, valg_behandlingsniva,
                 valg_hastegrad, valg_drgtypehastegrad, valg_fag,
                 valg_fagavtspes, valg_behandler, valg_behsh, valg_behhf,
        valg_behrhf)

    valg_to <- c(valg_behandler, valg_behsh, valg_behhf, valg_behrhf, valg_aar,
                 valg_alder, valg_kjonn, valg_behandlingsniva, valg_hastegrad,
                 valg_drgtypehastegrad, valg_fag,
                 valg_fagavtspes, valg_boomr_sh, valg_boomr_hf, valg_boomr_rhf,
                 Tom = "ingen")

    valg_tre <- c(valg_aar, valg_alder, valg_kjonn, valg_behandlingsniva, valg_hastegrad,
                  valg_drgtypehastegrad, valg_fag, valg_fagavtspes)

    valg_fire <- c(valg_kontakter, valg_rate, valg_liggetid, valg_liggerate, valg_liggeindex,
                   valg_drg, valg_drgrate, valg_drgindex)

    if (valgnr == 1) {
        return(valg_en)
    } else if (valgnr == 2) {
        return(valg_to)
    } else if (valgnr == 3) {
        return(valg_tre)
    } else if (valgnr == 4) {
        return(valg_fire)
    } else {
        return()
    }

}
