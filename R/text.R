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
lagHjelpetekst <- function(tab, rad, kol, verdi, aar, bo, beh, prosent,
                           behandlingsniva, alder, kjonn, hastegrad2) {

    tmp_boomr <- "..."
    aar_tekst <- "..."
    extra <- ""
    hjelpetekst <- ""

    if (!is.null(rad) & !is.null(aar) & !is.null(verdi)) {

        if (tab == "alle") {
            tabell <- "Pasientstrømmer"
        } else if (tab == "menisk") {
            tabell <- "Meniskoperasjoner"
        } else {
            tabell <- "Pasientstrømmer"
        }

        overskrift <- paste0("<h1>", tabell, ", Helse Nord RHF",
                            "<img src=\"skde.png\" ",
                            "align=\"right\" ",
                            "width=\"150\" ",
                            "style=\"padding-right:20px;\"/>",
                            "</h1>", "<br/>")

        if (tab == "Informasjon") {
            # Do not print details about the selection when the user look at the information tab (not relevant).
            infofane <- paste(overskrift, "<font size='+1'>", "Informasjonsfane", "</font>", "<br>", "<br>", sep = "")
            return(infofane)
        }

        if (tab == "poli") {
            type <- "polikliniske konsultasjoner"
        } else if (tab == "dag") {
            type <- "dagbehandlinger"
        } else if (tab == "dogn") {
            type <- "innleggelser"
        } else {
            type <- "kontakter"
        }

        if (verdi == "kontakter") {
            verdi_tekst <- paste0("Antall ", type)
        } else if (verdi == "rate") {
            verdi_tekst <- paste0("Kjønns- og aldersjusterte rater (antall ", type, " pr. 1 000 innbygger)")
        } else if (verdi == "liggetid") {
            verdi_tekst <- "Antall liggedøgn"
        } else if (verdi == "liggedognindex") {
            verdi_tekst <- "Gjennomsnittlig antall liggedøgn pr. innleggelse"
        } else if (verdi == "liggedognrate") {
            verdi_tekst <- "Liggedøgnsrater (antall liggedøgn pr. 1 000 innbyggere)"
        } else if (verdi == "drg_poeng") {
            verdi_tekst <- "Antall DRG-poeng"
        } else if (verdi == "drgrate") {
            verdi_tekst <- "Kjønns- og aldersjusterte DRG-poeng-rater (antall DRG-poeng pr. 1 000 innbygger)"
        } else if (verdi == "drg_index") {
            verdi_tekst <- "DRG-index (antall DRG-poeng pr. pasient)"
        } else {
            verdi_tekst <- verdi
        }

        hjelpetekst <- paste(hjelpetekst, verdi_tekst, sep = "")

        if (prosent == TRUE) {
            prs_txt <- ", i prosent, "
        } else {
            prs_txt <- ""
        }

        hjelpetekst <- paste(hjelpetekst, prs_txt, " for pasienter ", sep = "")

        if (bo == 2) {
            hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Helse Nord RHF", sep = "")
        } else if (bo == 3) {
            hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Finnmarkssykehuset HF", sep = "")
        } else if (bo == 4) {
            hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for UNN HF", sep = "")
        } else if (bo == 5) {
            hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Nordlandssykehuset HF", sep = "")
        } else if (bo == 6) {
            hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Helgelandssykehuset HF", sep = "")
        }

        if (bo %in% c(2, 3, 4, 5, 6)) {
            if (beh %in% c(2, 3, 4, 5, 6, 7)) {
                hjelpetekst <- paste(hjelpetekst, " og ", sep = "")
            } else {
                hjelpetekst <- paste(hjelpetekst, ", ", sep = "")
            }
        }

        if (beh == 2) {
            hjelpetekst <- paste(hjelpetekst, "behandlet av Helse Nord RHF", sep = "")
        } else if (beh == 3) {
            hjelpetekst <- paste(hjelpetekst, "behandlet av Finnmarkssykehuset HF", sep = "")
        } else if (beh == 4) {
            hjelpetekst <- paste(hjelpetekst, "behandlet av UNN HF", sep = "")
        } else if (beh == 5) {
            hjelpetekst <- paste(hjelpetekst, "behandlet av Nordlandsykehuset HF", sep = "")
        } else if (beh == 6) {
            hjelpetekst <- paste(hjelpetekst, "behandlet av Helgelandssykehuset HF", sep = "")
        } else if (beh == 7) {
            hjelpetekst <- paste(hjelpetekst, "behandlet utenfor Helse Nord RHF", sep = "")
        }

        if (beh %in% c(2, 3, 4, 5, 6, 7)) {
            hjelpetekst <- paste(hjelpetekst, ", ", sep = "")
        }

        tmp_behandl <- FALSE
        if ("behandlende_sykehus" %in% rad | kol == "behandlende_sykehus") {
            tmp_beh <- "sykehus"
            tmp_behandl <- TRUE
        } else if ("behandlende_hf" %in% rad | kol == "behandlende_hf") {
            tmp_beh <- "HF"
            tmp_behandl <- TRUE
        } else if ("behandlende_rhf" %in% rad | kol == "behandlende_rhf") {
            tmp_beh <- "RHF"
            tmp_behandl <- TRUE
        } else if ("behandler" %in% rad | kol == "behandler") {
            tmp_beh <- "sykehus"
            tmp_behandl <- TRUE
        }
        if (tmp_behandl) {
            hjelpetekst <- paste(hjelpetekst, "behandlet ved ulike ", tmp_beh, sep = "")
        }

        tmp_bo <- F
        if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
            tmp_bo <- T
            tmp_boomr <- "sykehusnivå"
        } else if ("boomr_hf" %in% rad | kol == "boomr_hf") {
            tmp_bo <- T
            tmp_boomr <- "HF-nivå"
        } else if (("boomr_rhf" %in% rad | kol == "boomr_rhf") & (bo == 1)) {
            tmp_bo <- T
            tmp_boomr <- "RHF-nivå"
        }

        if (tmp_bo) {
            if (tmp_behandl) {
                hjelpetekst <- paste(hjelpetekst, " og ", sep = "")
            }
            hjelpetekst <- paste(hjelpetekst, "bosatt i ulike opptaksområder på ", tmp_boomr, ", ", sep = "")
        } else if (tmp_behandl) {
            hjelpetekst <- paste(hjelpetekst, ", ", sep = "")
        }

        k <- 0
        annet <- list()
        if ("aar" %in% rad | kol == "aar") {
            k <- k + 1
            annet$aar <- "år"
        }
        if ("alder" %in% rad | kol == "alder") {
            k <- k + 1
            annet$alder <- "aldersgrupper"
        }
        if ("kjonn" %in% rad | kol == "kjonn") {
            k <- k + 1
            annet$kjonn <- "kjønn"
        }
        if ("behandlingsniva" %in% rad | kol == "behandlingsniva") {
            k <- k + 1
            annet$behandl <- "behandlingsnivå"
        }
        if ("hastegrad" %in% rad | kol == "hastegrad") {
            k <- k + 1
            annet$hastegrd1 <- "hastegrad"
        }
        if ("hastegrad_drgtype_dogn" %in% rad | kol == "hastegrad_drgtype_dogn") {
            k <- k + 1
            annet$hastegrd2 <- "hastegrad, innleggelser"
        }
        if ("drgtypehastegrad" %in% rad | kol == "drgtypehastegrad") {
            k <- k + 1
            annet$drgtypehastegrad <- "DRGtypeHastegrad"
        }

        if (k > 0) {
            hjelpetekst <- paste(hjelpetekst, "fordelt på ", sep = "")
            l <- 0
            for (i in annet) {
                l <- l + 1
                if (l == k & l != 1) {
                  hjelpetekst <- paste(hjelpetekst, i, sep = " og ")
                } else if (l == 1) {
                  hjelpetekst <- paste(hjelpetekst, i, sep = "")
                } else {
                  hjelpetekst <- paste(hjelpetekst, i, sep = ", ")
                }
            }
        }

        if (length(aar) > 1) {
            tmp1 <- "årene "
            if (length(aar) == (as.numeric(aar[length(aar)]) - as.numeric(aar[1]) + 1)) {
                tmp2 <- paste(aar[1], aar[length(aar)], sep = " - ")
                aar_tekst <- paste(tmp1, tmp2)
            } else {
                tmp2 <- paste(aar[1:length(aar) - 1], collapse = ", ")
                tmp3 <- paste(" og ", aar[length(aar)])
                aar_tekst <- paste(tmp1, tmp2, tmp3)
            }
        } else {
            aar_tekst <- aar
        }

        hjelpetekst <- paste(hjelpetekst, ", for ", aar_tekst, ".", sep = "")

        all_tekst <- paste(overskrift, "<font size='+1'>", hjelpetekst, "</font>", "<br>", "<br>", sep = "")

        extra <- F
        if ((length(alder) < 4) |
            (length(hastegrad2) < 4) |
            (length(behandlingsniva) < 3) |
            (tab %in% c("dag", "dogn", "poli"))) {
            extra <- T
        }

        if (extra) {
            all_tekst <- paste(all_tekst, "<ul><li>Annet: <ul>", sep = "")
        }

        if (length(alder) != 4) {
            if (length(alder) == 1) {
                tmp1 <- "<li>Kun aldersgruppen "
                alder_tekst <- paste(tmp1, alder[length(alder)], "</li>", sep = "")
            } else {
                tmp1 <- "<li>Kun aldersgruppene"
                tmp2 <- paste(alder[1:length(alder) - 1], collapse = ", ")
                tmp3 <- paste(" og ", alder[length(alder)], "</li>", sep = "")
                alder_tekst <- paste(tmp1, tmp2, tmp3)
            }
            all_tekst <- paste(all_tekst, alder_tekst, sep = "")
        }

        if (length(hastegrad2) != 5) {
            hast <- sapply(hastegrad2, tolower)
            if (length(hast) == 1) {
                tmp1 <- "<li>Kun hastegrad "
                hastegrad2_tekst <- paste(tmp1, hast[length(hast)], "</li>", sep = "")
            } else {
                tmp1 <- "<li>Kun hastegradene"
                tmp2 <- paste(hast[1:length(hast) - 1], collapse = ", ")
                tmp3 <- paste(" og ", hast[length(hast)], "</li>", sep = "")
                hastegrad2_tekst <- paste(tmp1, tmp2, tmp3)
            }
            all_tekst <- paste(all_tekst, hastegrad2_tekst, sep = "")
        }

        if (tab == "dag") {
            all_tekst <- paste0(all_tekst, "<li>Kun dagbehandlinger</li>")
        } else if (tab == "dogn") {
            all_tekst <- paste0(all_tekst, "<li>Kun døgnopphold</li>")
        } else if (tab == "poli") {
            all_tekst <- paste0(all_tekst, "<li>Kun polikliniske konsultasjoner</li>")
        } else if (length(behandlingsniva) != 3) {
            behnivaa <- sapply(behandlingsniva, tolower)
            behnivaa <- gsub("dagbehandling", "dagbehandlinger", behnivaa)
            behnivaa <- gsub("konsultasjon", "konsultasjoner", behnivaa)
            if (length(behnivaa) == 1) {
                tmp1 <- "<li>Kun "
                behandlingsniva_tekst <- paste(tmp1, behnivaa[length(behnivaa)], "</li>", sep = "")
            } else {
                tmp1 <- "<li>Kun"
                tmp2 <- paste(behnivaa[1:length(behnivaa) - 1], collapse = ", ")
                tmp3 <- paste(" og ", behnivaa[length(behnivaa)], "</li>", sep = "")
                behandlingsniva_tekst <- paste(tmp1, tmp2, tmp3)
            }
            all_tekst <- paste(all_tekst, behandlingsniva_tekst, sep = "")
        }

        if (extra) {
            all_tekst <- paste(all_tekst, "</ul></li></ul>", sep = "")
        }

        # LEGG INN ADVARSLER

        if (verdi %in% c("rate", "drgrate")) {
            if ("alder" %in% rad | "alder" %in% kol | length(alder) != 4) {
                warn <- paste0("<font color=#b94a48>",
                              "ADVARSEL: ratene er beregnet ut i fra totalbefolkningen ",
                              "på ", tmp_boomr, ", og ikke for hver aldersgruppe!",
                              "</font>")
                all_tekst <- paste(all_tekst, warn, sep = "")
            }
            if ("kjonn" %in% rad | "kjonn" %in% kol | length(kjonn) == 1) {
                warn <- paste0("<font color=#b94a48>",
                               "ADVARSEL: ratene er beregnet ut i fra totalbefolkningen ",
                               "på ", tmp_boomr, ", og ikke for hvert enkelt kjønn!",
                               "</font>")
                all_tekst <- paste(all_tekst, warn, sep = "")
            }
        }

        if (("behandler" %in% rad | kol == "behandler" |
             "behandlende_sykehus" %in% rad |
             kol == "behandlende_sykehus") &
            ("2016" %in% aar)) {
            warn <- paste0("<font color=#b94a48>", "ADVARSEL: Feil i rapportering ",
                          "av behandlingssted for innlagte pasienter ved UNN i 2016!",
                          "</font>", "Se pressemelding fra Helsedirektoratet.</a> ",
                          "De innlagte pasientene ved UNN HF sine tre sykehus ",
                          "(Tromsø, Narvik og Harstad) ble alle rapportert som ",
                          "innlagt ved UNN Tromsø. I tabellen er disse lagt til UNN HF.")
            all_tekst <- paste(all_tekst, warn, sep = "")
        }
        return(all_tekst)
    }
}
