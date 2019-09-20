
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
definerValgKol <- function(datasett, valgnr) {

    col_names <- tolower(colnames(datasett))

    valg_kommune <- c()
    if ("kommune" %in% col_names){
        valg_kommune <- c(`Kommune` = "kommune")
    }

    valg_bosykehus <- c()
    if ("boomr_sykehus" %in% col_names){
        valg_bosykehus <- c(`Opptaksområde Sykehus` = "boomr_sykehus")
    }

    valg_bohf <- c()
    if ("boomr_hf" %in% col_names){
        valg_bohf <- c(`Opptaksområde HF` = "boomr_hf")
    }

    valg_borhf <- c()
    if ("boomr_rhf" %in% col_names){
        valg_borhf <- c(`Opptaksområde RHF` = "boomr_rhf")
    }

    valg_boomr <- c(valg_kommune, valg_bosykehus, valg_bohf, valg_borhf)

    valg_aar <- c()
    if ("aar" %in% col_names) {
        valg_aar <- c(År = "aar")
    }

    valg_alder <- c()
    if ("alder" %in% col_names) {
        valg_alder <- c(Alder = "alder")
    }

    valg_kjonn <- c()
    if ("kjonn" %in% col_names) {
        valg_kjonn <- c(Kjønn = "kjonn")
    }

    valg_behandlingsniva <- c()
    if ("behandlingsniva" %in% col_names) {
        valg_behandlingsniva <- c(Behandlingsnivå = "behandlingsniva")
    }

    valg_hastegrad <- c()
    if ("hastegrad" %in% col_names) {
        valg_hastegrad <- c(Hastegrad = "hastegrad")
    }

    valg_drgtypehastegrad <- c()
    if ("drgtypehastegrad" %in% col_names) {
        valg_drgtypehastegrad <- c(DRGtypeHastegrad = "drgtypehastegrad")
    }

    valg_behandler <- c()
    if ("behandler" %in% col_names) {
        valg_behandler <- c(Behandler = "behandler")
    }

    valg_behsh <- c()
    if ("behandlende_sykehus" %in% col_names) {
        valg_behsh <- c(`Behandlende sykehus` = "behandlende_sykehus")
    }

    valg_behhf <- c()
    if ( ("behandlende_hf" %in% col_names) | ("behandlende_hf_hn" %in% col_names) ) {
        valg_behhf <- c(`Behandlende HF` = "behandlende_hf")
    }

    valg_behrhf <- c()
    if ("behandlende_rhf" %in% col_names) {
        valg_behrhf <- c(`Behandlende RHF` = "behandlende_rhf")
    }

    valg_hdg <- c()
    if ("hoveddiagnosegruppe" %in% col_names) {
        valg_hdg <- c(Hoveddiagnosegruppe = "hoveddiagnosegruppe")
    }

    valg_icd10 <- c()
    if ("icd10kap" %in% col_names) {
        valg_icd10 <- c(`ICD10-kapittel` = "icd10kap")
    }

    valg_fag <- c()
    if ("episodefag" %in% col_names) {
        valg_fag <- c(Fagområde = "episodefag")
    }

    valg_fagavtspes <- c()
    if ("fag_skde" %in% col_names) {
        valg_fagavtspes <- c(`Fagfelt avtalespesialist` = "fag_skde")
    }

    # Verdier
    valg_kontakter <- c()
    if ("kontakter" %in% col_names) {
        valg_kontakter <- c(Kontakter = "kontakter")
    }

    valg_rate <- c()
    if ("" %in% col_names) {
        valg_rate <- c(Rater = "rate")
    }

    valg_liggetid <- c()
    if ("" %in% col_names) {
        valg_liggetid <- c(Liggedøgn = "liggetid")
    }

    valg_liggeindex <- c()
    if ("liggedognindex" %in% col_names) {
        valg_liggeindex <- c(`Liggedøgn pr. pasient` = "liggedognindex")
    }

    valg_drg <- c()
    if ("drg_poeng" %in% col_names) {
        valg_drg <- c(`DRG-poeng` = "drg_poeng")
    }

    valg_drgrate <- c()
    if ("drgrate" %in% col_names) {
        valg_drgrate <- c(`DRG-poengrater` = "drgrate")
    }

    valg_drgindex <- c()
    if ("drg_index" %in% col_names) {
        valg_drgindex <- c(`DRG-index` = "drg_index")
    }

    valg_liggerate <- c()
    if ("bosh_liggerate" %in% col_names &
        "bohf_liggerate" %in% col_names &
        "borhf_liggerate" %in% col_names) {
        valg_liggerate <- c(Liggedøgnsrate = "liggedognrate")
    }




    valg_en <- c(valg_boomr, valg_aar, valg_alder, valg_kjonn, valg_behandlingsniva,
                 valg_hastegrad, valg_drgtypehastegrad, valg_hdg, valg_icd10, valg_fag,
                 valg_fagavtspes, valg_behandler, valg_behsh, valg_behhf,
        valg_behrhf)

    valg_to <- c(valg_behandler, valg_behsh, valg_behhf, valg_behrhf, valg_aar,
                 valg_alder, valg_kjonn, valg_behandlingsniva, valg_hastegrad,
                 valg_drgtypehastegrad, valg_hdg, valg_icd10, valg_fag, valg_fagavtspes,
        valg_boomr, Tom = "ingen")

    valg_tre <- c(valg_aar, valg_alder, valg_kjonn, valg_behandlingsniva, valg_hastegrad,
                  valg_drgtypehastegrad, valg_hdg, valg_icd10, valg_fag, valg_fagavtspes)

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
