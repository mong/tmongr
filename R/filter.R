#' Filter out data from dataset
#'
#' Filter out data from the dataset that is not going to be tabulated
#'
#' @param tabell The dataset that is going to be filtred.
#' @param fane The active tab (effect if 'dogn', 'dag' or 'poli')
#' @param verdi The value that is going to be tabulated (only an effect if 'liggedognindex' or 'drg_index')
#' @param aar The years to be tabulated
#' @param bo Possible values 1:6
#' @param beh  Possible values 1:7
#' @param behandlingsniva Type of contact (admissions, outpatient consultations or day patient treatments)
#' @param alder Age group
#' @param kjonn Gender
#' @param hastegrad2 Degree of urgency
#'
#' @importFrom rlang .data
filtrer_ut <- function(tabell, fane, verdi, aar, bo, beh, behandlingsniva,
                       alder, kjonn, hastegrad1, hastegrad2, fag) {
  if (fane == "dogn") {
    tabell <- filter_behandlingsniva(tabell, c("Døgnopphold"))
  } else if (fane == "dag") {
    tabell <- filter_behandlingsniva(tabell, c("Dagbehandling"))
  } else if (fane == "poli") {
    tabell <- filter_behandlingsniva(tabell, c("Poliklinikk"))
  }

  tabell <- filter_aar(tabell, aar)

  tabell <- filter_fag(tabell, fag)

  if (verdi == "liggedognindex") {
    tabell <- filter_behandlingsniva(tabell, c("Døgnopphold"))
  }

  if (verdi == "drg_index") {
    # ta ut avtalespesialistene
    tabell <- filter_behandlingsniva(tabell, c("Døgnopphold", "Dagbehandling", "Poliklinikk"))
  }

  tabell <- filter_bo(tabell, bo)

  tabell <- filter_beh(tabell, beh)

  tabell <- filter_behandlingsniva(tabell, behandlingsniva)

  tabell <- filter_alder(tabell, alder)

  tabell <- filter_kjonn(tabell, kjonn)

  tabell <- filter_hastegrad1(tabell, hastegrad1)

  tabell <- filter_hastegrad2(tabell, hastegrad2)

  return(tabell)
}


# Kun se på boområdet man er interessert i
filter_bo <- function(datasett, bo) {
  if (bo == 1) {
    return(datasett)
  } else if (bo == 2) {
    tmpsett <- dplyr::filter(datasett, .data[["boomr_rhf"]] == "Boomr Helse Nord RHF")
    return(tmpsett)
  } else if (bo == 3) {
    tmpsett <- dplyr::filter(datasett, .data[["boomr_hf"]] == "Finnmark")
    return(tmpsett)
  } else if (bo == 4) {
    tmpsett <- dplyr::filter(datasett, .data[["boomr_hf"]] == "UNN")
    return(tmpsett)
  } else if (bo == 5) {
    tmpsett <- dplyr::filter(datasett, .data[["boomr_hf"]] == "Nordland")
    return(tmpsett)
  } else if (bo == 6) {
    tmpsett <- dplyr::filter(datasett, .data[["boomr_hf"]] == "Helgeland")
    return(tmpsett)
  }
}

# Kun se på behandlende foretak man er interessert i
filter_beh <- function(datasett, beh) {
  if (beh == "Alle") {
    # ingen filtrering
    return(datasett)
  } else {
    if (beh == "Helse Nord RHF") {
      tmpsett <- dplyr::filter(datasett, .data[["behandlende_rhf"]] == "Helse Nord RHF")
      return(tmpsett)
    } else {
      tmpsett <- dplyr::filter(datasett, .data[["behandlende_hf_hn"]] == beh)
      return(tmpsett)
    }
  }
}

# Disse filter-rutinene burde legges sammen til en rutine
filter_aar <- function(datasett, filter) {
  tabell <- dplyr::filter(datasett, .data[["aar"]] %in% as.numeric(filter))
  return(tabell)
}


filter_behandlingsniva <- function(datasett, filter) {
  if (!("behandlingsniva" %in% colnames(datasett))) {
    return(datasett)
  }

  tabell <- dplyr::filter(datasett, .data[["behandlingsniva"]] %in% filter)
  return(tabell)
}

filter_hastegrad1 <- function(datasett, filter) {
  if (!("hastegrad" %in% colnames(datasett))) {
    return(datasett)
  }
  tabell <- dplyr::filter(datasett, .data[["hastegrad"]] %in% filter)
  return(tabell)
}

filter_hastegrad2 <- function(datasett, filter) {
  if (!("drgtypehastegrad" %in% colnames(datasett))) {
    return(datasett)
  }

  tabell <- dplyr::filter(datasett, .data[["drgtypehastegrad"]] %in% filter)
  return(tabell)
}

filter_alder <- function(datasett, filter) {
  if (!("alder" %in% colnames(datasett))) {
    return(datasett)
  }
  if (length(filter) == 4) {
    return(datasett)
  } else {
    tabell <- dplyr::filter(datasett, .data[["alder"]] %in% filter)
    return(tabell)
  }
}

filter_kjonn <- function(datasett, filter) {
  if (!("kjonn" %in% colnames(datasett))) {
    return(datasett)
  }
  tabell <- dplyr::filter(datasett, .data[["kjonn"]] %in% filter)
  return(tabell)
}

filter_fag <- function(datasett, filter) {
  if (filter == "Alle") {
    return(datasett)
  } else {
    tabell <- dplyr::filter(datasett, .data[["episodefag"]] %in% filter)
    return(tabell)
  }
}
