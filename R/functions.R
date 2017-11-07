
#' Title
#'
#' @param datasett Datasett
#' @param valgnr Hvilket valg
#'
#' @return valg_en valg_to valg_tre
#' @export
#'
definerValgKol <- function(datasett, valgnr){
  valg_boomr <- c(
    "Boområde Sykehus" = "boomr_sykehus",
    "Boområde HF" = "boomr_HF",
    "Boområde RHF" = "boomr_RHF")

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

  if ("alder" %in% colnames(datasett)){
    valg_alder <- c("Alder" = "alder")
  }
  if ("kjonn" %in% colnames(datasett)){
    valg_kjonn <- c("Kjønn" = "kjonn")
  }
  if ("behandlingsniva" %in% colnames(datasett)){
    valg_behandlingsniva <- c("Behandlingsnivå" = "behandlingsniva")
  }
  if ("DRGtypeHastegrad" %in% colnames(datasett)){
    valg_DRGtypeHastegrad <- c("DRGtypeHastegrad")
  }
  if ("Behandler" %in% colnames(datasett)){
    valg_Behandler <- c("Behandler")
  }
  if ("behandlende_sykehus" %in% colnames(datasett)){
    valg_behsh <- c("Behandlende sykehus" = "behandlende_sykehus")
  }
  if (("behandlende_HF" %in% colnames(datasett)) | ("behandlende_HF_HN" %in% colnames(datasett))){
    valg_behhf <- c("Behandlende HF" = "behandlende_HF")
  }
  if ("behandlende_RHF" %in% colnames(datasett)){
    valg_behrhf <- c("Behandlende RHF" = "behandlende_RHF")
  }
  if ("Hoveddiagnosegruppe" %in% colnames(datasett)){
    valg_hdg <- c("Hoveddiagnosegruppe")
  }

  if ("ICD10Kap" %in% colnames(datasett)){
    valg_icd10 <- c("ICD10-kapittel" = "ICD10Kap")
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
    valg_icd10)

  if (valgnr == 1){return(valg_en)}
  else if (valgnr == 2){return(valg_to)}
  else if (valgnr == 3){return(valg_tre)}
  else {return()}

}
