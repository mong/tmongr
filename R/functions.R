
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
definerValgKol <- function(datasett, valgnr){
  valg_boomr <- c(
    "Opptaksområde Sykehus" = "boomr_sykehus",
    "Opptaksområde HF" = "boomr_hf",
    "Opptaksområde RHF" = "boomr_rhf")

  valg_aar <- c("År" = "aar")

  valg_alder <- c()
  valg_kjonn <- c()
  valg_behandlingsniva <- c()
  valg_DRGtypeHastegrad <- c()
  valg_Behandler <- c()
  valg_behsh <- c()
  valg_behhf <- c()
  valg_behrhf <- c()
  valg_alder <- c()
  valg_alder <- c()
  valg_hdg <- c()
  valg_icd10 <- c()
  valg_fag <- c()
  valg_fagavtspes <- c()
  
  # Verdier
  valg_kontakter <- c("Kontakter"="kontakter")
  valg_rate <- c("Rater"="rate")
  valg_liggetid <- c("Liggedøgn" = "liggetid")
  valg_liggerate <- c()
  valg_liggeindex <- c("Liggedøgn pr. pasient" = "liggedognindex")
  valg_drg <- c("DRG-poeng"="drg_poeng")
  valg_drgrate <- c("DRG-poengrater"="drgrate")
  valg_drgindex <- c("DRG-index"="drg_index")

  col_names <- tolower(colnames(datasett))

  if ("alder" %in% col_names){
    valg_alder <- c("Alder" = "alder")
  }
  if ("kjonn" %in% col_names){
    valg_kjonn <- c("Kjønn" = "kjonn")
  }
  if ("behandlingsniva" %in% col_names){
    valg_behandlingsniva <- c("Behandlingsnivå" = "behandlingsniva")
  }
  if ("drgtypehastegrad" %in% col_names){
    valg_DRGtypeHastegrad <- c("DRGtypeHastegrad" = "drgtypehastegrad")
  }
  if ("behandler" %in% col_names){
    valg_Behandler <- c("Behandler" = "behandler")
  }
  if ("behandlende_sykehus" %in% col_names){
    valg_behsh <- c("Behandlende sykehus" = "behandlende_sykehus")
  }
  if (("behandlende_hf" %in% col_names) | ("behandlende_hf_hn" %in% col_names)){
    valg_behhf <- c("Behandlende HF" = "behandlende_hf")
  }
  if ("behandlende_rhf" %in% col_names){
    valg_behrhf <- c("Behandlende RHF" = "behandlende_rhf")
  }
  if ("hoveddiagnosegruppe" %in% col_names){
    valg_hdg <- c("Hoveddiagnosegruppe" = "hoveddiagnosegruppe")
  }
  if ("bosh_liggerate" %in% col_names & "bohf_liggerate" %in% col_names & "borhf_liggerate" %in% col_names){
    valg_liggerate <- c("Liggedøgnsrate" = "liggedognrate")
  }

  if ("icd10kap" %in% col_names){
    valg_icd10 <- c("ICD10-kapittel" = "icd10kap")
  }

  if ("episodefag" %in% col_names){
    valg_fag <- c("Fagområde" = "episodefag")
  }
  
  if ("fag_skde" %in% col_names){
    valg_fagavtspes <- c("Fagfelt avtalespesialist" = "fag_skde")
  }
  
  valg_en <- c(
    valg_boomr,
    valg_aar,
    valg_alder,
    valg_kjonn,
    valg_behandlingsniva,
    valg_DRGtypeHastegrad,
    valg_hdg,
    valg_icd10,
    valg_fag,
    valg_fagavtspes,
    valg_Behandler,
    valg_behsh,
    valg_behhf,
    valg_behrhf
  )

  valg_to <- c(
    valg_Behandler,
    valg_behsh,
    valg_behhf,
    valg_behrhf,
    valg_aar,
    valg_alder,
    valg_kjonn,
    valg_behandlingsniva,
    valg_DRGtypeHastegrad,
    valg_hdg,
    valg_icd10,
    valg_fag,
    valg_fagavtspes,
    valg_boomr,
    "Tom" = "ingen"
  )

  valg_tre <- c(
    valg_aar,
    valg_alder,
    valg_kjonn,
    valg_behandlingsniva,
    valg_DRGtypeHastegrad,
    valg_hdg,
    valg_icd10,
    valg_fag,
    valg_fagavtspes
  )

  valg_fire <- c(
    valg_kontakter,
    valg_rate,
    valg_liggetid,
    valg_liggerate,
    valg_liggeindex,
    valg_drg,
    valg_drgrate,
    valg_drgindex
  )

  if (valgnr == 1){return(valg_en)}
  else if (valgnr == 2){return(valg_to)}
  else if (valgnr == 3){return(valg_tre)}
  else if (valgnr == 4){return(valg_fire)}
  else {return()}

}
