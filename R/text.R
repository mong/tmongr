define_boomr <- function(rad, bo) {
  if ("boomr_sykehus" %in% rad) {
    return("sykehusnivå")
  } else if ("boomr_hf" %in% rad) {
    return("HF-nivå")
  } else if (("boomr_rhf" %in% rad) && (bo == 1)) {
    return("RHF-nivå")
  } else {
    return("...")
  }
}

get_heading <- function() {
  overskrift <- paste0(
    "<h1>", "Pasientstrømmer", ", Helse Nord RHF",
    "<img src=\"www/skde.png\" ",
    "align=\"right\" ",
    "width=\"150\" ",
    "style=\"padding-right:20px;\"/>",
    "</h1>", "<br/>"
  )

  return(overskrift)
}

get_type <- function(tab) {
  if (tab == "poli") {
    type <- "polikliniske konsultasjoner"
  } else if (tab == "dag") {
    type <- "dagbehandlinger"
  } else if (tab == "dogn") {
    type <- "innleggelser"
  } else {
    type <- "kontakter"
  }
  return(type)
}

get_value_text <- function(value, type) {
  if (value == "kontakter") {
    verdi_tekst <- paste0("Antall ", type)
  } else if (value == "rate") {
    verdi_tekst <- paste0("Kjønns- og aldersjusterte rater (antall ", type, " pr. 1 000 innbygger)")
  } else if (value == "liggetid") {
    verdi_tekst <- "Antall liggedøgn"
  } else if (value == "liggedognindex") {
    verdi_tekst <- "Gjennomsnittlig antall liggedøgn pr. innleggelse"
  } else if (value == "liggedognrate") {
    verdi_tekst <- "Liggedøgnsrater (antall liggedøgn pr. 1 000 innbyggere)"
  } else if (value == "drg_poeng") {
    verdi_tekst <- "Antall DRG-poeng"
  } else if (value == "drgrate") {
    verdi_tekst <- "Kjønns- og aldersjusterte DRG-poeng-rater (antall DRG-poeng pr. 1 000 innbygger)"
  } else if (value == "drg_index") {
    verdi_tekst <- "DRG-index (antall DRG-poeng pr. pasient)"
  } else {
    verdi_tekst <- value
  }
  return(verdi_tekst)
}

get_bo_text <- function(bo, beh) {
  if (bo == 2) {
    hjelpetekst <- "bosatt i opptaktsområdet for Helse Nord RHF"
  } else if (bo == 3) {
    hjelpetekst <- "bosatt i opptaktsområdet for Finnmarkssykehuset HF"
  } else if (bo == 4) {
    hjelpetekst <- "bosatt i opptaktsområdet for UNN HF"
  } else if (bo == 5) {
    hjelpetekst <- "bosatt i opptaktsområdet for Nordlandssykehuset HF"
  } else if (bo == 6) {
    hjelpetekst <- "bosatt i opptaktsområdet for Helgelandssykehuset HF"
  } else {
    hjelpetekst <- ""
  }

  if (bo %in% c(2, 3, 4, 5, 6)) {
    if (beh %in% c(2, 3, 4, 5, 6, 7)) {
      hjelpetekst <- paste(hjelpetekst, " og ", sep = "")
    } else {
      hjelpetekst <- paste(hjelpetekst, ", ", sep = "")
    }
  }

  if (beh == 2) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet av Helse Nord RHF")
  } else if (beh == 3) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet av Finnmarkssykehuset HF")
  } else if (beh == 4) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet av UNN HF")
  } else if (beh == 5) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet av Nordlandsykehuset HF")
  } else if (beh == 6) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet av Helgelandssykehuset HF")
  } else if (beh == 7) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet utenfor Helse Nord RHF")
  }

  if (beh %in% c(2, 3, 4, 5, 6, 7)) {
    hjelpetekst <- paste0(hjelpetekst, ", ")
  }

  return(hjelpetekst)
}

get_beh_text <- function(rad, bo) {
  tmp_behandl <- FALSE
  hjelpetekst <- ""
  if ("behandlende_sykehus" %in% rad) {
    tmp_beh <- "sykehus"
    tmp_behandl <- TRUE
  } else if ("behandlende_hf" %in% rad) {
    tmp_beh <- "HF"
    tmp_behandl <- TRUE
  } else if ("behandlende_rhf" %in% rad) {
    tmp_beh <- "RHF"
    tmp_behandl <- TRUE
  } else if ("behandler" %in% rad) {
    tmp_beh <- "sykehus"
    tmp_behandl <- TRUE
  }
  if (tmp_behandl) {
    hjelpetekst <- paste0(hjelpetekst, "behandlet ved ulike ", tmp_beh)
  }

  tmp_bo <- FALSE
  if ("boomr_sykehus" %in% rad) {
    tmp_bo <- TRUE
  } else if ("boomr_hf" %in% rad) {
    tmp_bo <- TRUE
  } else if (("boomr_rhf" %in% rad) && (bo == 1)) {
    tmp_bo <- TRUE
  }

  tmp_boomr <- define_boomr(rad, bo)

  if (tmp_bo) {
    if (tmp_behandl) {
      hjelpetekst <- paste0(hjelpetekst, " og ")
    }
    hjelpetekst <- paste0(hjelpetekst, "bosatt i ulike opptaksområder på ", tmp_boomr, ", ")
  } else if (tmp_behandl) {
    hjelpetekst <- paste0(hjelpetekst, ", ")
  }

  return(hjelpetekst)
}

get_annet_text <- function(rad) {
  hjelpetekst <- ""
  k <- 0
  annet <- list()
  if ("aar" %in% rad) {
    k <- k + 1
    annet$aar <- "år"
  }
  if ("alder" %in% rad) {
    k <- k + 1
    annet$alder <- "aldersgrupper"
  }
  if ("kjonn" %in% rad) {
    k <- k + 1
    annet$kjonn <- "kjønn"
  }
  if ("behandlingsniva" %in% rad) {
    k <- k + 1
    annet$behandl <- "behandlingsnivå"
  }
  if ("hastegrad" %in% rad) {
    k <- k + 1
    annet$hastegrd1 <- "hastegrad"
  }
  if ("hastegrad_drgtype_dogn" %in% rad) {
    k <- k + 1
    annet$hastegrd2 <- "hastegrad, innleggelser"
  }
  if ("episodefag" %in% rad) {
    k <- k + 1
    annet$episode_fag <- "fagområdet for episoden"
  }
  if ("fag_skde" %in% rad) {
    k <- k + 1
    annet$fagskde <- "fagfelt til avtalespesialist"
  }
  if ("drgtypehastegrad" %in% rad) {
    k <- k + 1
    annet$drgtypehastegrad <- "DRGtypeHastegrad"
  }

  if (k > 0) {
    hjelpetekst <- paste(hjelpetekst, "fordelt på ", sep = "")
    l <- 0
    for (i in annet) {
      l <- l + 1
      if (l == k && l != 1) {
        hjelpetekst <- paste(hjelpetekst, i, sep = " og ")
      } else if (l == 1) {
        hjelpetekst <- paste(hjelpetekst, i, sep = "")
      } else {
        hjelpetekst <- paste(hjelpetekst, i, sep = ", ")
      }
    }
  }
  return(hjelpetekst)
}

get_aar_text <- function(aar) {
  hjelpetekst <- ""
  if (length(aar) > 1) {
    tmp1 <- "årene "
    if (length(aar) == (as.numeric(aar[length(aar)]) - as.numeric(aar[1]) + 1)) {
      tmp2 <- paste(aar[1], aar[length(aar)], sep = "–")
      aar_tekst <- paste(tmp1, tmp2)
    } else {
      tmp2 <- paste(aar[seq_len(length(aar)) - 1], collapse = ", ")
      tmp3 <- paste(" og ", aar[length(aar)])
      aar_tekst <- paste(tmp1, tmp2, tmp3)
    }
  } else {
    aar_tekst <- aar
  }

  hjelpetekst <- paste0(hjelpetekst, ", for ", aar_tekst, ".")
  return(hjelpetekst)
}

extra_text <- function(alder, hastegrad2, behandlingsniva, tab, rad) {
  all_tekst <- ""
  extra <- FALSE
  if ("episodefag" %in% rad) {
    extra <- TRUE
    all_tekst <- paste0(
      all_tekst,
      "<li> Fagområdet for episoden er rapportert av sykehusene og rapporteringspraksis vil variere. ",
      "Samme type episode vil derfor kunne ha forskjellig fagområde, blant annet avhengig av ved ",
      "hvilket sykehus eller avdeling episoden fant sted.</li>",
      "<li> For en del konsultasjoner hos ",
      "avtalespesialister er ikke fagområdet ",
      "for episoden rapport inn til NPR. ",
      "Disse konsultasjonene har fått definert ",
      "fagområdet for episoden basert på fagområdet ",
      "til avtalespesialisten.</li>"
    )
  }

  if (length(alder) < 4 && !is.null(alder)) {
    extra <- TRUE
    if (length(alder) == 1) {
      tmp1 <- "<li>Kun aldersgruppen "
      alder_tekst <- paste0(tmp1, alder[length(alder)], "</li>")
    } else {
      tmp1 <- "<li>Kun aldersgruppene"
      tmp2 <- paste(alder[seq_len(length(alder)) - 1], collapse = ", ")
      tmp3 <- paste0(" og ", alder[length(alder)], "</li>")
      alder_tekst <- paste(tmp1, tmp2, tmp3)
    }
    all_tekst <- paste(all_tekst, alder_tekst, sep = "")
  }

  if (length(hastegrad2) != 5 && !is.null(hastegrad2)) {
    extra <- TRUE
    hast <- sapply(hastegrad2, tolower)
    if (length(hast) == 1) {
      tmp1 <- "<li>Kun hastegrad "
      hastegrad2_tekst <- paste(tmp1, hast[length(hast)], "</li>", sep = "")
    } else {
      tmp1 <- "<li>Kun hastegradene"
      tmp2 <- paste(hast[seq_len(length(hast)) - 1], collapse = ", ")
      tmp3 <- paste(" og ", hast[length(hast)], "</li>", sep = "")
      hastegrad2_tekst <- paste(tmp1, tmp2, tmp3)
    }
    all_tekst <- paste(all_tekst, hastegrad2_tekst, sep = "")
  }

  if (tab == "dag") {
    extra <- TRUE
    all_tekst <- paste0(all_tekst, "<li>Kun dagbehandlinger</li>")
  } else if (tab == "dogn") {
    extra <- TRUE
    all_tekst <- paste0(all_tekst, "<li>Kun døgnopphold</li>")
  } else if (tab == "poli") {
    extra <- TRUE
    all_tekst <- paste0(all_tekst, "<li>Kun polikliniske konsultasjoner</li>")
  } else if (length(behandlingsniva) != 3) {
    extra <- TRUE
    behnivaa <- sapply(behandlingsniva, tolower)
    behnivaa <- gsub("dagbehandling", "dagbehandlinger", behnivaa)
    behnivaa <- gsub("konsultasjon", "konsultasjoner", behnivaa)
    if (length(behnivaa) == 1) {
      tmp1 <- "<li>Kun "
      behandlingsniva_tekst <- paste0(tmp1, behnivaa[length(behnivaa)], "</li>")
    } else {
      tmp1 <- "<li>Kun"
      tmp2 <- paste(behnivaa[seq_len(length(behnivaa)) - 1], collapse = ", ")
      tmp3 <- paste0(" og ", behnivaa[length(behnivaa)], "</li>")
      behandlingsniva_tekst <- paste(tmp1, tmp2, tmp3)
    }
    all_tekst <- paste0(all_tekst, behandlingsniva_tekst)
  }

  if (extra) {
    all_tekst <- paste0("<ul><li>Annet: <ul>", all_tekst, "</ul></li></ul>")
  }
  return(all_tekst)
}

warning_text <- function(rad, verdi, bo, aar, alder, kjonn) {
  # LEGG INN ADVARSLER
  all_tekst <- ""
  tmp_boomr <- define_boomr(rad, bo)
  if (verdi %in% c("rate", "drgrate")) {
    if (("alder" %in% rad || length(alder) != 4) && !is.null(alder)) {
      warn <- paste0(
        "<font color=#b94a48>",
        "ADVARSEL: ratene er beregnet ut i fra totalbefolkningen ",
        "på ", tmp_boomr, ", og ikke for hver aldersgruppe!",
        "</font>"
      )
      all_tekst <- paste0(all_tekst, warn)
    }
    if ("kjonn" %in% rad || length(kjonn) == 1) {
      warn <- paste0(
        "<font color=#b94a48>",
        "ADVARSEL: ratene er beregnet ut i fra totalbefolkningen ",
        "på ", tmp_boomr, ", og ikke for hvert enkelt kjønn!",
        "</font>"
      )
      all_tekst <- paste0(all_tekst, warn)
    }
  }

  if (
    ("behandler" %in% rad ||
       "behandlende_sykehus" %in% rad) &&
      ("2016" %in% aar)
  ) {
    warn <- paste0(
      "<font color=#b94a48>", "ADVARSEL: Feil i rapportering ",
      "av behandlingssted for innlagte pasienter ved UNN i 2016!",
      "</font>", "Se pressemelding fra Helsedirektoratet.</a> ",
      "De innlagte pasientene ved UNN HF sine tre sykehus ",
      "(Tromsø, Narvik og Harstad) ble alle rapportert som ",
      "innlagt ved UNN Tromsø. I tabellen er disse lagt til UNN HF."
    )
    all_tekst <- paste0(all_tekst, warn)
  }
  return(all_tekst)
}

#' Make caption above the table
#' @param tab The active tab
#' @param rad What to tabulate on the row
#' @param kol What to tabulate on the column
#' @param verdi The value that is going to be tabulated
#' @param aar The years to be tabulated
#' @param bo Living area. Possible values 1:6
#' @param beh Hospital Health Trust. Possible values 1:7
#' @param behandlingsniva Type of contact (admissions, outpatient consultations or day patient treatments)
#' @param alder Age group
#' @param kjonn Gender
#' @param hastegrad2 Degree of urgency
#' @param prosent Show percentage
#'
#' @return Tekst Some text that describe the selection made by the user.
#' @export
#'
lag_hjelpetekst <- function(tab, rad, kol, verdi, aar, bo, beh, prosent,
                            behandlingsniva, alder, kjonn, hastegrad2,
                            overskrift = TRUE) {
  if (is.null(rad) || is.null(aar) || is.null(verdi)) {
    return(NULL)
  }

  if (overskrift) {
    overskrift <- get_heading()
  } else {
    overskrift <- "<h1></h1>"
  }

  if (tab == "Informasjon") {
    # Do not show text if on information tab
    return(paste0(
      overskrift, "<font size='+1'>",
      "Informasjonsfane", "</font>",
      "<br>", "<br>"
    ))
  }

  type <- get_type(tab)

  verdi_tekst <- get_value_text(verdi, type)

  prs_txt <- ""
  if (prosent == TRUE) {
    prs_txt <- ", i prosent, "
  }

  hjelpetekst <- paste0(verdi_tekst, prs_txt, " for pasienter ")

  hjelpetekst <- paste0(hjelpetekst, get_bo_text(bo, beh))

  hjelpetekst <- paste0(hjelpetekst, get_beh_text(c(rad, kol), bo))

  hjelpetekst <- paste0(hjelpetekst, get_annet_text(c(rad, kol)))

  hjelpetekst <- paste0(hjelpetekst, get_aar_text(aar))

  all_tekst <- paste0(overskrift, "<font size='+1'>", hjelpetekst, "</font>", "<br>", "<br>")

  all_tekst <- paste0(all_tekst, extra_text(alder, hastegrad2, behandlingsniva, tab, c(rad, kol)))

  all_tekst <- paste0(all_tekst, warning_text(c(rad, kol), verdi, bo, aar, alder, kjonn))


  return(enc2utf8(all_tekst))
}
