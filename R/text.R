
#' Title
#'
#' @param tab Utvalg
#'
#' @return Tekst
#' @export
#'
utvalgTekst <- function(tab){
  pretext = "Utvalg: "
  maintext = ""
  if (tab == "alle"){
    maintext = "alle somatiske kontakter i spesialisthelsetjenesten for beboere i Helse Nord og kontakter med sykehus i Helse Nord RHF"
  } else if (tab == "menisk"){
    maintext = "hoved- eller bidiagnose (ICD-10) M23.2, M23.3 eller S83.2 i kombinasjon med prosedyrekodene (NCSP) i kategoriblokken NGD for ISF-finansierte sykehus, og de samme diagnosekodene i kombinasjon med taksten K05b for avtalespesialister."
  } else if (tab == "dogn"){
    maintext = "alle somatiske døgninnleggelser i spesialisthelsetjenesten for beboere i Helse Nord og kontakter med sykehus i Helse Nord RHF"
  } else if (tab == "dag"){
    maintext = "alle somatiske dagbehandlinger i spesialisthelsetjenesten for beboere i Helse Nord og kontakter med sykehus i Helse Nord RHF"
  } else if (tab == "poli"){
    maintext = "alle somatiske polikliniske kontakter i spesialisthelsetjenesten for beboere i Helse Nord og kontakter med sykehus i Helse Nord RHF"
  } else {
    maintext = "ingen beskrivelse tilgjengelig"
  }
  teksten <- paste(pretext,maintext,sep="")

  return(teksten)
}

# For å lage caption til tabell

#' Title
#'
#' @param tab,rad,kol,verdi,aar,bo,beh,prosent,behandlingsniva,alder,kjonn,hastegrad2,forenkling Beskrivelse
#'
#' @return Tekst
#' @export
#'
lagHjelpetekst <- function(tab, rad, kol, verdi, aar, bo, beh, prosent, behandlingsniva, alder, kjonn, hastegrad2, forenkling){

  tmp_boomr = "..."
  aar_tekst = "..."
  extra = ""
  hjelpetekst = ""

  if (!is.null(rad) & !is.null(aar) & !is.null(verdi)){

    if (tab == "alle"){
      tabell = "Pasientstrømmer"
    } else if (tab == "menisk"){
      tabell = "Meniskoperasjoner"
    } else {
      tabell = "Pasientstrømmer"
    }

    overskrift <- paste("<h1>",tabell, ", Helse Nord RHF",'<img src="skde.png" align="right" width="150" style="padding-right:20px;"/>',"</h1>","<br/>",sep = "")

    if (verdi == "kontakter"){
      verdi_tekst = "Antall kontakter"
    } else if (verdi == "rate"){
      verdi_tekst = "Kjønns- og aldersjusterte rater (antall kontakter pr. 1000 innbygger)"
    } else if (verdi == "liggetid"){
      verdi_tekst = "Antall liggedøgn"
    } else if (verdi == "liggedognindex"){
      verdi_tekst = "Gjennomsnittlig antall liggedøgn pr. innleggelse"
    } else if (verdi == "liggedognrate"){
      verdi_tekst = "Liggedøgnsrater (antall liggedøgn pr. 1000 innbyggere)"
    } else if (verdi == "drg_poeng"){
      verdi_tekst = "Antall DRG-poeng"
    } else if (verdi == "drgrate"){
      verdi_tekst = "Kjønns- og aldersjusterte DRG-poeng-rater (antall DRG-poeng pr. 1000 innbygger)"
    } else if (verdi == "drg_index"){
      verdi_tekst = "DRG-index (antall DRG-poeng pr. pasient)"
    } else {
      verdi_tekst = verdi
    }

    hjelpetekst <- paste(hjelpetekst,verdi_tekst,sep = "")


    if (prosent == TRUE){
      prs_txt = ", i prosent, "
    } else {
      prs_txt = ""
    }

    hjelpetekst <- paste(hjelpetekst,prs_txt, " for pasienter ",sep = "")

    if (bo == 2){
      hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Helse Nord RHF",sep = "")
    } else if (bo == 3){
      hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Finnmarkssykehuset HF",sep = "")
    } else if (bo == 4){
      hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for UNN HF",sep = "")
    } else if (bo == 5){
      hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Helgelandssykehuset HF",sep = "")
    } else if (bo == 6){
      hjelpetekst <- paste(hjelpetekst, "bosatt i opptaktsområdet for Nordlandssykehuset HF",sep = "")
    }

    if (bo %in% c(2,3,4,5,6)){
      if(beh %in% c(2,3,4,5,6,7)){
        hjelpetekst <- paste(hjelpetekst," og ",sep="")
      } else {
        hjelpetekst <- paste(hjelpetekst,", ",sep="")
      }
    }

    if (beh == 2){
      hjelpetekst <- paste(hjelpetekst, "behandlet av Helse Nord RHF",sep = "")
    } else if (beh == 3){
      hjelpetekst <- paste(hjelpetekst, "behandlet av Finnmarkssykehuset HF",sep = "")
    } else if (beh == 4){
      hjelpetekst <- paste(hjelpetekst, "behandlet av UNN HF",sep = "")
    } else if (beh == 5){
      hjelpetekst <- paste(hjelpetekst, "behandlet av Helgelandssykehuset HF",sep = "")
    } else if (beh == 6){
      hjelpetekst <- paste(hjelpetekst, "behandlet av Nordlandsykehuset HF",sep = "")
    } else if (beh == 7){
      hjelpetekst <- paste(hjelpetekst, "behandlet utenfor Helse Nord RHF",sep = "")
    }

    if(beh %in% c(2,3,4,5,6,7)){
      hjelpetekst <- paste(hjelpetekst,", ",sep="")
    }


    tmp_behandl = FALSE
    if ("behandlende_sykehus" %in% rad | kol == "behandlende_sykehus") {
      tmp_beh = "sykehus"
      tmp_behandl = TRUE
    } else if ("behandlende_HF" %in% rad | kol == "behandlende_HF") {
      tmp_beh = "HF"
      tmp_behandl = TRUE
    } else if ("behandlende_RHF" %in% rad | kol == "behandlende_RHF") {
      tmp_beh = "RHF"
      tmp_behandl = TRUE
    } else if ("Behandler" %in% rad | kol == "Behandler") {
      tmp_beh = "sykehus"
      tmp_behandl = TRUE
    }
    if (tmp_behandl){hjelpetekst <- paste(hjelpetekst, "behandlet ved ulike ", tmp_beh ,sep = "")}

    tmp_bo = F
    if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
      tmp_bo = T
      tmp_boomr = "sykehusnivå"
    } else if ("boomr_HF" %in% rad | kol == "boomr_HF") {
      tmp_bo = T
      tmp_boomr = "HF-nivå"
    } else if ("boomr_RHF" %in% rad | kol == "boomr_RHF") {
      tmp_bo = T
      tmp_boomr = "RHF-nivå"
    }

    if (tmp_bo){
      if (tmp_behandl) {

        hjelpetekst <- paste(hjelpetekst, " og ", sep = "")
      }
      hjelpetekst <- paste(hjelpetekst, "bosatt i ulike opptaksområder på ", tmp_boomr ,", ",sep = "")
    } else if (tmp_behandl){
      hjelpetekst <- paste(hjelpetekst, ", ",sep = "")
    }

    k = 0
    annet <- list()
    if ("aar" %in% rad | kol == "aar") {
      k = k + 1
      annet$aar <- "år"
    }
    if ("alder" %in% rad | kol == "alder") {
      k = k + 1
      annet$alder <- "aldersgrupper"
    }
    if ("kjonn" %in% rad | kol == "kjonn") {
      k = k + 1
      annet$kjonn <- "kjønn"
    }
    if ("behandlingsniva" %in% rad | kol == "behandlingsniva") {
      k = k + 1
      annet$behandl <- "behandlingsnivå"
    }
    if ("hastegrad" %in% rad | kol == "hastegrad") {
      k = k + 1
      annet$hastegrd1 <- "hastegrad"
    }
    if ("hastegrad_drgtype_dogn" %in% rad | kol == "hastegrad_drgtype_dogn") {
      k = k + 1
      annet$hastegrd2 <- "hastegrad, innleggelser"
    }

    if (k > 0){
      hjelpetekst <- paste(hjelpetekst, "fordelt på " ,sep = "")
      l = 0
      for (i in annet){
        l = l + 1
        if (l == k & l != 1){
          hjelpetekst <- paste(hjelpetekst, i ,sep = " og ")
        } else if (l == 1) {
          hjelpetekst <- paste(hjelpetekst, i ,sep = "")
        } else {
          hjelpetekst <- paste(hjelpetekst, i ,sep = ", ")
        }
      }
    }

    if (length(aar) > 1 ){
      tmp1 = "årene "
      if (length(aar) == (as.numeric(aar[length(aar)])-as.numeric(aar[1])+1)){
        tmp2 = paste(aar[1], aar[length(aar)], sep=" - ")
        aar_tekst = paste(tmp1, tmp2)
      }
      else {
        tmp2 = paste(aar[1:length(aar)-1], collapse = ', ')
        tmp3 = paste(" og ", aar[length(aar)])
        aar_tekst = paste(tmp1, tmp2, tmp3)
      }

    } else{
      aar_tekst = aar
    }

    hjelpetekst <- paste(hjelpetekst, ", for ", aar_tekst, ".", sep = "")

    all_tekst <- paste(overskrift, "<font size='+1'>", hjelpetekst,"</font>","<br>","<br>", sep="")


    #    all_tekst <- paste(all_tekst, "<li>",utvalgTekst(tab),"</li>",sep="")

    extra = F
    if ((length(alder) < 4)|(length(hastegrad2) < 4)|(length(behandlingsniva) < 3)|(forenkling && beh %in% c(1,7) && !("behandlende_RHF" %in% rad | kol == "behandlende_RHF"))){
      extra = T
    }

    if (extra){
      all_tekst <- paste(all_tekst, "<ul><li>Annet: <ul>",sep = "")
    }

    if (length(alder) != length(aldersgrupper)){
      if (length(alder) == 1){
        tmp1 = "<li>Kun aldersgruppen "
        alder_tekst = paste(tmp1, alder[length(alder)],"</li>",sep="")
      } else {
        tmp1 = "<li>Kun aldersgruppene"
        tmp2 = paste(alder[1:length(alder)-1], collapse = ', ')
        tmp3 = paste(" og ", alder[length(alder)],"</li>",sep="")
        alder_tekst = paste(tmp1, tmp2, tmp3)
      }
      all_tekst <- paste(all_tekst, alder_tekst, sep="")
    }

    if (length(hastegrad2) != length(hastegrd)){
      hast <- sapply(hastegrad2, tolower)
      if (length(hast) == 1){
        tmp1 = "<li>Kun hastegrad "
        hastegrad2_tekst = paste(tmp1, hast[length(hast)],"</li>",sep="")
      } else {
        tmp1 = "<li>Kun hastegradene"
        tmp2 = paste(hast[1:length(hast)-1], collapse = ', ')
        tmp3 = paste(" og ", hast[length(hast)],"</li>",sep="")
        hastegrad2_tekst = paste(tmp1, tmp2, tmp3)
      }
      all_tekst <- paste(all_tekst, hastegrad2_tekst, sep="")
    }

    if (length(behandlingsniva) != length(behniva)){
      behnivaa <- sapply(behandlingsniva, tolower)
      behnivaa <- gsub("dagbehandling","dagbehandlinger",behnivaa)
      behnivaa <- gsub("konsultasjon","konsultasjoner",behnivaa)
      if (length(behnivaa) == 1){
        tmp1 = "<li>Kun "
        behandlingsniva_tekst = paste(tmp1, behnivaa[length(behnivaa)],"</li>",sep="")
      } else {
        tmp1 = "<li>Kun"
        tmp2 = paste(behnivaa[1:length(behnivaa)-1], collapse = ', ')
        tmp3 = paste(" og ", behnivaa[length(behnivaa)],"</li>",sep="")
        behandlingsniva_tekst = paste(tmp1, tmp2, tmp3)
      }
      all_tekst <- paste(all_tekst, behandlingsniva_tekst, sep="")
    }

    if (forenkling && (beh %in% c(1,7)) && !("behandlende_RHF" %in% rad | kol == "behandlende_RHF")){
      all_tekst <- paste(all_tekst, "<li>", " Helseforetak utenfor Helse Nord RHF er slått sammen.","</li>", sep="")
    }

    if(extra){
      all_tekst <- paste(all_tekst, "</ul></li></ul>",sep = "")
    }

#    all_tekst <- paste(all_tekst, "</ul>", sep="")

    # LEGG INN ADVARSLER

    if (verdi %in% c("rate" , "drgrate")){
      if ("alder" %in% rad | "alder" %in% kol | length(alder) != 4){
        warn <- paste("<font color=#b94a48>","ADVARSEL: ratene er beregnet ut i fra totalbefolkningen på ",tmp_boomr, ", og ikke for hver aldersgruppe!","</font>",sep="")
        all_tekst <- paste(all_tekst, warn, sep = "")
      }
      if ("kjonn" %in% rad | "kjonn" %in% kol | length(kjonn) == 1){
        warn <- paste("<font color=#b94a48>","ADVARSEL: ratene er beregnet ut i fra totalbefolkningen på ",tmp_boomr, ", og ikke for hvert enkelt kjønn!","</font>",sep="")
        all_tekst <- paste(all_tekst, warn, sep = "")
      }

    }

    if (("Behandler" %in% rad | kol == "Behandler" | "behandlende_sykehus" %in% rad | kol == "behandlende_sykehus") & ("2016" %in% aar)) {
      warn <- paste("<font color=#b94a48>","ADVARSEL: Feil i rapportering av behandlingssted for innlagte pasienter ved UNN i 2016!","</font>",
                    ' <a href="https://helsedirektoratet.no/nyheter/feil-i-rapportering-av-behandlingssted-for-innlagte-pasienter-i-2016">',
                    'Se pressemelding fra Helsedirektoratet.</a> ',
                    "De innlagte pasientene ved UNN HF sine tre sykehus (Tromsø, Narvik og Harstad) ble alle rapportert som innlagt ved UNN Tromsø. I tabellen er disse lagt til UNN HF.",
                    sep="")
      if("2015" %in% aar){
      warn <- paste(warn, " I tillegg er det ikke rapportert behandlende sykehus for de fleste pasienter behandlet ved Nordlandssykehuset i 2015. Disse pasientene er rapportert som behandlet ved Nordlandssykehuset HF.")
      }
      all_tekst <- paste(all_tekst, warn, sep = "")
    }
    else if (("Behandler" %in% rad | kol == "Behandler" | "behandlende_sykehus" %in% rad | kol == "behandlende_sykehus") & ("2015" %in% aar)) {
      warn <- paste("<font color=#b94a48>","ADVARSEL: Mangler ved rapportering av behandlingssted for pasienter behandlet ved Nordlandssykehuset i 2015!","</font>",
                    "Det er ikke rapportert behandlende sykehus for de fleste pasienter behandlet ved Nordlandssykehuset i 2015. Disse pasientene er rapportert som behandlet ved Nordlandssykehuset HF.",
                    sep="")
      all_tekst <- paste(all_tekst, warn, sep = "")
    }

    return(all_tekst)
  }
}



