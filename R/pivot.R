#' Title
#'
#' @param inpDatasett 
#' @param fane 
#' @param rad 
#' @param kol 
#' @param verdi 
#' @param aar 
#' @param bo 
#' @param beh 
#' @param behandlingsniva 
#' @param alder 
#' @param kjonn 
#' @param hastegrad2 
#' @param prosent 
#' @param forenkling 
#' @param keepNames 
#' @param snitt 
#' @param hdg 
#' @param icd10 
#'
#' @return pivot
#' @export
#'
#' @examples TBA
makeDataTabell <- function(inpDatasett, fane, rad, kol, verdi, 
                           aar, bo, beh, behandlingsniva, alder, kjonn, hastegrad2,
                           prosent, forenkling, keepNames, snitt, hdg, icd10){
  
  if (is.null(forenkling)){return(NULL)} # for å unngå feilmelding
  if (is.null(aar)){return(NULL)} # for å unngå feilmelding
  
  
  if (verdi == "drg_index"){
    prosent = FALSE
  }
  
  tabell <- inpDatasett

  # for å slå sammen helseforetak i sør-norge
  if (( forenkling & ("behandlende_HF" %in% colnames(tabell))) | (!("behandlende_HF" %in% colnames(tabell)&("behandlende_HF_HN" %in% colnames(tabell))))){
    rad <- gsub("behandlende_HF", "behandlende_HF_HN", rad)
    kol <- gsub("behandlende_HF", "behandlende_HF_HN", kol)
  }

#  if (!("behandlende_HF" %in% colnames(tabell)&("behandlende_HF_HN" %in% colnames(tabell)))){
#    rad <- gsub("behandlende_HF", "behandlende_HF_HN", rad)
#    kol <- gsub("behandlende_HF", "behandlende_HF_HN", kol)
#  }
  
  
  # Filtrer ut det som ikke skal tabuleres. Rutinen ligger i filter.R
  tabell <- filtrerUt(tabell, fane, rad, kol, verdi,
                      aar, bo, beh, behandlingsniva, alder, kjonn, hastegrad2, hdg, icd10)

  # Returnere ingenting hvis hele tabellen filtreres bort
  if(!nrow(tabell)){return()}
  
  # Erstatte NA med null
  tabell[is.na(tabell)] <- 0

  # lage pivot-tabell av det som er igjen. Rutinen ligger under.  
  pivot <- makePivot(tabell, rad, kol, verdi)
  if(!nrow(pivot)){return()}

  # Erstatte NA med null (er dette nødvendig en gang til?)
  pivot[is.na(pivot)] <- 0

  if (is.null(pivot)){return()}

  regnetTotal = FALSE

  # Burde vi legge inn snitt i steden for total for de to tilfellene index og liggedognrate?
  if(snitt | prosent){
    if (!("drg_index" %in% verdi | "liggedognrate" %in% verdi) & !(verdi %in% c("rate","drgrate") & length(rad) == 1)){
      # ikke regn ut total på rater når en rad er bohf og den andre rad er bosh
      if (!( (verdi %in% c("rate","drgrate")) & ('boomr_HF' %in% rad) & ('boomr_sykehus' %in% rad))){
        regnetTotal = TRUE
        pivot <- addTotal(pivot, rad, kol)
      }
    }
  }

  # legge inn sum eller snitt i siste kolonne
  if(snitt){
    pivot <- addLastColumn(pivot,rad,kol,verdi)
  }

  # Prosent blir 100 på alle, hvis sum ikke er beregnet. Har vi noe alternativ?
  if (prosent == TRUE && regnetTotal){
    pivot <- prosentFunc(pivot, rad, kol)
  }

  # fjerne navn på rad (1, 2, 3, etc.)
  row.names(pivot) <- NULL

  # bedre navn i kolonneoverskrift
  pivot <- renameColumns(pivot)

  pivot <- as.matrix(pivot)

  pivot <- gsub("Boomr ","", pivot)
  pivot <- gsub("[.]",",", pivot)
  
  # sortere ualfabetisk, fra nord til sør
  pivot <- sorterDatasett(pivot)

  # Ta bort tekst hvis tekst under er lik
  if (!keepNames & length(rad) != 1){
      pivot <- removeDoubleNames(pivot)
  }
  
  if (verdi %in% c("kontakter", "liggetid")){
    pivot <- slashHeltall(pivot)
  }

  return(pivot)
}



# lager en pivot-tabell av sum av verdien "agg"
makePivot <- function(data, rad, kol, agg){
  
  # gruppere
  # Burde skrives om, uten if nesting (issue #6)
  if (length(rad) == 1){
    tmp <- data %>% group_by_(rad, kol)
  }
  else if (length(rad) == 2){
    tmp <- data %>% group_by_(rad[1], rad[2], kol)
  }
  else{
    return(tomTabell())
  }
  
  # Velge ut verdier. Rater avhengig av boområdet!
  if (agg == "rate"){
    if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
      tmp <- tmp %>% summarise(verdi=sum(bosh_rate))
      tmp <- round_df(tmp, digits=1)
    }
    else if ("boomr_HF" %in% rad | kol == "boomr_HF") {
      tmp <- tmp %>% summarise(verdi=sum(bohf_rate))
      tmp <- round_df(tmp, digits=1)
    }
    else if ("boomr_RHF" %in% rad | kol == "boomr_RHF") {
      tmp <- tmp %>% summarise(verdi=sum(borhf_rate))
      tmp <- round_df(tmp, digits=1)
    }
    else {
      return(tomTabell())
    }
  } else if (agg == "drgrate"){
    if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
      tmp <- tmp %>% summarise(verdi=sum(bosh_drgrate))
      tmp <- round_df(tmp, digits=1)
    }
    else if ("boomr_HF" %in% rad | kol == "boomr_HF") {
      tmp <- tmp %>% summarise(verdi=sum(bohf_drgrate))
      tmp <- round_df(tmp, digits=1)
    }
    else if ("boomr_RHF" %in% rad | kol == "boomr_RHF") {
      tmp <- tmp %>% summarise(verdi=sum(borhf_drgrate))
      tmp <- round_df(tmp, digits=1)
    }
    else {
      return(tomTabell())
    }
  } else if (agg == "drg_poeng"){
#    valg = as.name(agg)
    tmp <- tmp %>% summarise(verdi=sum(drg_poeng))
    tmp <- round_df(tmp, digits=0)
  } else if(agg == "drg_index"){
    tmp_kontakt <- tmp %>% summarise(verdi = sum(kontakter))
    tmp <- tmp %>% summarise(verdi = sum(drg_poeng))
    if (kol %in% rad){
      start = length(rad)+1
    } 
    else {
      start = length(rad)+2
    }
    for (i in start:length(names(tmp))){
      tmp[,i] <- tmp[,i]/tmp_kontakt[,i]
      tmp <- round_df(tmp, digits=3)
    }
  } else if(agg == "liggedognrate"){
    tmp_kontakt <- tmp %>% summarise(verdi = sum(kontakter))
    tmp <- tmp %>% summarise(verdi = sum(liggetid))
    for (i in (length(rad)+2):length(names(tmp))){
      tmp[,i] <- tmp[,i]/tmp_kontakt[,i]
      tmp <- round_df(tmp, digits=1)
    }
  } else{
#    valg = as.name(agg)
    tmp <- tmp %>% summarise_(verdi=interp(~sum(var), var = as.name(agg)))
    tmp <- round_df(tmp, digits=1)
  }
  
  tmp2 <- spread_(tmp, kol, "verdi")

  return(tmp2)
}

# rund av alle tall i tabell
# tatt fra http://stackoverflow.com/a/32930130
round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
  
  df[,nums] <- round(df[,nums], digits = digits)
  
  (df)
}

removeDoubleNames <- function(datasett){
  # rutine for å fjerne gjentagende navn nedover i tabellen
  
  if (is.null(dim(datasett)[1])){return(datasett)}

  k <- "abc"
  for (i in 1:dim(datasett)[1]){
    if(datasett[i,1] == k){
      datasett[i,1] <- ""
    }
    if (datasett[i,1] != ""){
      k <- datasett[i,1]
    }
  }
  return(datasett)
}

sorterDatasett <- function(datasett){
  # Sortere datasett i forhold til boområdet og behandlingsområdet
  # fungerer ikke med ø-hjelp

  # Hvis det kun er en rad, vil denne rutinen "ødelegge" tabellen.
  if (nrow(datasett) == 1){return(datasett)}

  names1 <- c(
    "Eget lokalsykehus", "Annet sykehus i eget HF", "UNN Troms", "NLSH Bod", "Annet HF i HN", "HF i andre RHF",
    "Kirkenes", "Hammerfest", "Troms", "Narvik", "Harstad", "Vester", "Lofoten", "Bod", "Rana", "Sandnessj", 
    "Finnmark", "Klinikk", "UNN", "Nordland", "Helgeland", "HF i S",
    "Bor utenfor","Resterende", "Private",
    "Helse Nord RHF", "Helse Midt-Norge", "Helse Vest RHF", "Helse S",
    "Døgnopphold","Dagbehandling","Poliklinikk","Avtalespesialister", "Avtalespesialist",
    "Planlagt medisin","Akutt medisin", "Planlagt kirurgi", "Akutt kirurgi",
    "Sum", "Akutt", "Planlagt")
  names2 <- c(
    "baa","bab","bac","bad","bae","baf",
    "aaa","aab","aac","aad","aae","aaf","aag","aah","aai","aaj",
    "aba","abb","abc","abd","abe","abf",
    "xaa","xbb","xxx",
    "aca","acb","acc","acd",
    "ada","adb","adc","yyy","add",
    "aea","aeb","aec","aed",
    "zzz", "mmm", "nnn")
  tmp <- datasett
  
  for(i in seq_along(names1)) tmp <- gsub(names1[i], names2[i], tmp)
  
  tmp <- tmp[order(tmp[,1], tmp[,2]),]
  
  for(i in seq_along(names1)) tmp <- gsub(names2[i], names1[i], tmp)
  
  return(tmp)
}


prosentFunc <- function(tabell, rad, kol){
  # Må kjøres etter "addTotal"!
  if (kol != "aar"){
    # beregne prosent bortover
    for (i in (length(rad)+1):length(names(tabell))){
      tabell[,i] <- 100*tabell[,i]/tabell[,length(names(tabell))]
      tabell <- round_df(tabell, digits=1)
    }
  } else {
    # beregne prosent nedover
    tmp_tab <- tabell
    k = 0
    for (i in ((1):nrow(tmp_tab))){
      k = k + 1
      if (tmp_tab[i,length(rad)] == "Sum"){
        for (j in (0:(k-1))){
          tmp_tab[(i-j),] <- tmp_tab[i,]
          k = 0
        }
      }
    }
    for (i in ((1):nrow(tabell))){
      for (j in ((length(rad)+1):length(names(tabell)))){
        tabell[i,j] <- 100*tabell[i,j]/tmp_tab[i,j]
      }
    }
    tabell <- round_df(tabell, digits=1)
  }
  
  return(tabell)    
}


addTotal <- function(tabell, rad, kol){

  if("aar" %in% colnames(tabell)){
    tabell$aar = as.character(tabell$aar)
  }
  
  new_tab <- tabell
  myname = "tmp"
  
  k = 0
  num_val = 0

  for (i in ((1):nrow(new_tab))){
    k = k + 1
    if(myname != "tmp"){
      num_val = num_val + 1
    }
    if (((new_tab[i,1] != myname) | (num_val == 0)) & (length(rad) != 1 | (num_val == 0))){
      # telle på nytt hvis kolonne 1 er ulik i forrige rad
      for (j in (length(rad)+1):length(names(new_tab))){
        new_tab[i,j] <- new_tab[i,j]
      }
      if (k != 1){
        new_row = new_tab[i-1,]
        new_row[2] = "Sum"
        if (num_val != 1){
           tabell <- bind_rows(tabell[1:k-1,],new_row,tabell[-(1:k-1),])
        } else {num_val = 0}
        k = k + 1
      }
    } else{
      # Legg til verdi i celle hvis kolonne 1 heter det samme i forrige rad
      for (j in (length(rad)+1):length(names(new_tab))){
        new_tab[i,j] <- (new_tab[i,j] + new_tab[i-1,j])
      }
    }
    myname = new_tab[i,1]
  }
  new_row = tail(new_tab,1)
  new_row[length(rad)] = "Sum"
  
  if (num_val != 0){
    tabell <- rbind(tabell[1:k,],new_row,tabell[-(1:k),])
  }

  return(tabell)
}

renameColumns <- function(tabell){
  
  names(tabell) <- sub("behandlende_sykehus", "Behandlende sykehus", names(tabell))
  names(tabell) <- sub("behandlende_HF_HN", "Behandlende HF", names(tabell))
  names(tabell) <- sub("behandlende_HF", "Behandlende HF", names(tabell))
  names(tabell) <- sub("behandlende_RHF", "Behandlende RHF", names(tabell))
  names(tabell) <- sub("boomr_sykehus", "Bo-sykehus", names(tabell))
  names(tabell) <- sub("boomr_HF", "Bo-HF", names(tabell))
  names(tabell) <- sub("boomr_RHF", "Bo-RHF", names(tabell))
  names(tabell) <- sub("alder", "Alder", names(tabell))
  names(tabell) <- sub("behandlingsniva", "Behandlingsniva", names(tabell))
#  names(tabell) <- sub("hastegrad_drgtype_dogn", "Hastegrad - innleggelser", names(tabell))
  names(tabell) <- sub("hastegrad", "Hastegrad", names(tabell))
  names(tabell) <- sub("aar", "År", names(tabell))
  
  return(tabell)
  
}

addLastColumn <- function(pivot,rad,kol,verdi){
  if (verdi %in% c("kontakter", "liggetid")){
    rund = 0
  } else if (verdi %in% c("drg_poeng")){
    rund = 1
  } else if (verdi %in% c("drg_index")){
    rund = 3
  } else {
    rund = 1
  }
  
  if (((length(names(pivot))-length(rad)) != 1)){
    if ("aar" %in% kol){
      pivot$Snitt <- rowMeans(pivot[,-seq_len(length(rad))], na.rm = TRUE)
      pivot$Snitt <- round(pivot$Snitt,rund)
    } else{
      pivot$Sum <- rowSums(pivot[,-seq_len(length(rad))], na.rm = TRUE)
      pivot$Sum <- round(pivot$Sum, rund)
    }
  }
  
  return(pivot)
}

tomTabell <- function(){
  return(data.frame())
}

slashHeltall <- function(tabell){
  # erstatte tall mellom 1 og 4 med "-"
  tabell[suppressWarnings(as.numeric(tabell)) < 5 & suppressWarnings(as.numeric(tabell)) > 0] <- "-"
  return(tabell)
  
}