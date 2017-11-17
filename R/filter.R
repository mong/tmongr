#' Filtrere ut data fra datasett
#' 
#' Filtrerer ut data fra datasett som ikke skal tabuleres
#' 
#' @param tabell Datasettet som skal filtreres.
#' @param fane,rad,kol,verdi,aar,bo,beh,behandlingsniva,alder,kjonn,hastegrad2,hdg,icd10 Filteringsvalg.
#' 
filtrerUt <- function(tabell, fane, rad, kol, verdi,
          aar, bo, beh, behandlingsniva, alder, kjonn, hastegrad2, hdg, icd10){

  if (fane == "dogn"){
    tabell <- filterBehandlingsniva(tabell, c("Døgnopphold"))
  }
  else if (fane == "dag"){
    tabell <- filterBehandlingsniva(tabell, c("Dagbehandling"))
  }
  else if (fane == "poli"){
    tabell <- filterBehandlingsniva(tabell, c("Poliklinikk"))
  }
  
  tabell <- filterHDG(tabell, hdg)

  tabell <- filterICD10(tabell, icd10)
  
  tabell <- filterAar(tabell, aar)

  if (verdi == "liggedognindex"){
    tabell <- filterBehandlingsniva(tabell, c("Døgnopphold"))
  }

  if (verdi == "drg_index"){# ta ut avtalespesialistene
    tabell <- filterBehandlingsniva(tabell, c("Døgnopphold","Dagbehandling","Poliklinikk"))
  }
#  if ("hastegrad" %in% rad | "hastegrad" %in% kol){
#    tabell <- filter(tabell, hastegrad !="Ukjent")
#  }
  
  tabell <- filterBo(tabell,bo)
  
  tabell <- filterBeh(tabell,beh)  
  
  tabell <- filterBehandlingsniva(tabell, behandlingsniva)
  
  tabell <- filterAlder(tabell,alder)
  
  tabell <- filterKjonn(tabell,kjonn)
  
  tabell <- filterHastegrad2(tabell, hastegrad2)
  
  return(tabell)
}


# Kun se på boområdet man er interessert i
filterBo <- function(datasett, bo){
  if (bo == 1){
    return(datasett)
  }
  else if (bo == 2){
    tmpsett <- filter(datasett, boomr_RHF == "Boomr Helse Nord RHF")
    return(tmpsett)
  }
  else if (bo == 3){
    tmpsett <- filter(datasett, boomr_HF == "Finnmark")
    return(tmpsett)
  }
  else if (bo == 4){
    tmpsett <- filter(datasett, boomr_HF == "UNN")
    return(tmpsett)
  }
  else if (bo == 5){
    tmpsett <- filter(datasett, boomr_HF == "Nordland")
    return(tmpsett)
  }
  else if (bo == 6){
    tmpsett <- filter(datasett, boomr_HF == "Helgeland")
    return(tmpsett)
  }
}

# Kun se på behandlende foretak man er interessert i
filterBeh <- function(datasett, beh){
  if (beh == 1){
    # ingen filtrering
    return(datasett)
  }
  else if(FALSE){
    if (beh == 2){
      tmpsett <- filter(datasett, Behandler %in% c("Eget lokalsykehus","UNN Tromsø","NLSH Bodø","Annet sykehus i eget HF","Annet HF i HN"))
      return(tmpsett)
    }
    if (beh == 3){
      tmpsett <- filter(datasett, Behandler == "Eget lokalsykehus")
      return(tmpsett)
    }
    if (beh == 4){
      tmpsett <- filter(datasett, Behandler == "UNN Tromsø")
      return(tmpsett)
    }
    if (beh == 5){
      tmpsett <- filter(datasett, Behandler == "NLSH Bodø")
      return(tmpsett)
    }
    if (beh == 6){
      tmpsett <- filter(datasett, Behandler == "Annet sykehus i eget HF")
      return(tmpsett)
    }
    if (beh == 7){
      tmpsett <- filter(datasett, Behandler == "Annet HF i HN")
      return(tmpsett)
    }
    if (beh == 8){
      tmpsett <- filter(datasett, Behandler == "HF i andre RHF")
      return(tmpsett)
    }
  }
  else {
    if (beh == 2){
      tmpsett <- filter(datasett, behandlende_RHF == "Helse Nord RHF")
      return(tmpsett)
    }
    else if (beh == 3){
      tmpsett <- filter(datasett, behandlende_HF_HN == "Finnmarkssykehuset HF")
      return(tmpsett)
    }
    else if (beh == 4){
      tmpsett <- filter(datasett, behandlende_HF_HN == "UNN HF")
      return(tmpsett)
    }
    else if (beh == 5){
      tmpsett <- filter(datasett, behandlende_HF_HN == "Nordlandssykehuset HF")
      return(tmpsett)
    }
    else if (beh == 6){
      tmpsett <- filter(datasett, behandlende_HF_HN == "Helgelandssykehuset HF")
      return(tmpsett)
    }
    else if (beh == 7){
      tmpsett <- filter(datasett, behandlende_RHF != "Helse Nord RHF")
      return(tmpsett)
    }
  }
}

# Disse filter-rutinene burde legges sammen til en rutine
filterAar <- function(datasett, ar){
  tabell <- filter(datasett, aar %in% as.numeric(ar))
  return(tabell)
}


filterBehandlingsniva <- function(datasett, filter){
  if (!("behandlingsniva" %in% colnames(datasett))){
    return(datasett)
  }
  if (length(filter) == length(behniva)){
    return(datasett)
  } else {
    tabell <- filter(datasett, behandlingsniva %in% filter)
    return(tabell)
  }
}

filterHastegrad1 <- function(datasett, filter){
  if (!("hastegrad" %in% colnames(datasett))){
    return(datasett)
  }
  if (filter == "Alle"){
    return(datasett)
  } else {
    tabell <- filter(datasett, hastegrad == filter)
    return(tabell)
  }
}

filterHastegrad2 <- function(datasett, filter){
  if (!("DRGtypeHastegrad" %in% colnames(datasett))){
    return(datasett)
  }
  if (length(filter) == length(hastegrd)){
    return(datasett)
  } else {
    tabell <- filter(datasett, DRGtypeHastegrad %in% filter)
    return(tabell)
  }
}

filterAlder <- function(datasett, filter){
  if (!("alder" %in% colnames(datasett))){
    return(datasett)
  }
  if (length(filter) == 4){
    return(datasett)
  } else {
    tabell <- filter(datasett, alder %in% filter)
    return(tabell)
  }
}

filterKjonn <- function(datasett, filter){
  if (!("kjonn" %in% colnames(datasett))){
    return(datasett)
  }
  tabell <- filter(datasett, kjonn %in% filter)
  return(tabell)
}

filterHDG <- function(datasett, filter){
  if (filter == "Alle"){
    return(datasett)
  } else {
    tabell <- filter(datasett, Hoveddiagnosegruppe %in% filter)
  }
  
}

filterICD10 <- function(datasett, filter){
  if (filter == "Alle"){
    return(datasett)
  } else {
    tabell <- filter(datasett, ICD10Kap %in% filter)
  }
  
}
