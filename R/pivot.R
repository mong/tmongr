#' Make a pivot table
#'
#' @param input_dataset The dataset that is going to be tabulated
#' @param fane The active tab (for filtering; effect if "dogn", "dag" or "poli")
#' @param verdier Consist of data specific filter values, such as "rader", "kolonner", "aar", "bo", "beh" etc.
#' @param keep_names Tabulate all names in first row
#' @param snitt Add average/sums to the table
#'
#' @return pivot Pivot table
#' @export
#'
makeDataTabell <- function(input_dataset,
                           fane,
                           verdier,
                           keep_names,
                           snitt) {


  rad <- verdier$rader
  kol <- verdier$kolonner
  verdi <- verdier$verdi
  aar <- verdier$aar
  bo <- verdier$bo
  beh <- verdier$beh
  behandlingsniva <- verdier$behandlingsniva
  alder <- verdier$alder
  kjonn <- verdier$kjonn
  hastegrad1 <- verdier$hastegrad1
  hastegrad2 <- verdier$hastegrad2
  prosent <- verdier$prosent

  if (is.null(aar)) {
    # for å unngå feilmelding
    return(NULL)
  }

  if (length(rad) == length(kol)) {
    if (rad == kol) {
      return(NULL)
    }
  }

  if (verdi == "drg_index") {
    prosent <- FALSE
  }

  tabell <- input_dataset

  # for å slå sammen helseforetak i sør-norge
  if ("behandlende_hf_hn" %in% colnames(tabell)) {
    rad <- gsub("behandlende_hf", "behandlende_hf_hn", rad)
    kol <- gsub("behandlende_hf", "behandlende_hf_hn", kol)
  }

  # Filtrer ut det som ikke skal tabuleres. Rutinen ligger i filter.R
  tabell <- filtrerUt(tabell, fane, verdi,
                      aar, bo, beh, behandlingsniva, alder, kjonn, hastegrad1, hastegrad2)

  # Returnere ingenting hvis hele tabellen filtreres bort
  if (!nrow(tabell)) {
    return()
  }

  # Erstatte NA med null
  tabell[is.na(tabell)] <- 0

  # lage pivot-tabell av det som er igjen. Rutinen ligger under.
  pivot <- makePivot(tabell, rad, kol, verdi)
  if (!nrow(pivot)) {
    return()
  }

  # Erstatte NA med null (er dette nødvendig en gang til?)
  pivot[is.na(pivot)] <- 0

  if (is.null(pivot)) {
    return()
  }

  regnetTotal <- FALSE

  # Burde vi legge inn snitt i steden for total for de to tilfellene index og liggedognindex?
  if (snitt | prosent) {
    if (!("drg_index" %in% verdi | "liggedognindex" %in% verdi) &
        !(verdi %in% c("rate", "drgrate", "liggedognrate") & length(rad) == 1)) {
      # ikke regn ut total på rater når en rad er bohf og den andre rad er bosh
      if (!((verdi %in% c("rate", "drgrate", "liggedognrate")) &
             ("boomr_hf" %in% rad) &
             ("boomr_sykehus" %in% rad))) {
        regnetTotal <- TRUE
        pivot <- addTotal(pivot, rad, kol)
      }
    }
  }

  # legge inn sum eller snitt i siste kolonne
  if (snitt) {
    pivot <- addLastColumn(pivot, rad, kol, verdi)
  }

  # Prosent blir 100 på alle, hvis sum ikke er beregnet. Har vi noe alternativ?
  if (prosent == TRUE && regnetTotal) {
    pivot <- prosentFunc(pivot, rad, kol)
  }

  # fjerne navn på rad (1, 2, 3, etc.)
  row.names(pivot) <- NULL

  # bedre navn i kolonneoverskrift
  pivot <- renameColumns(pivot)

  # Hvorfor gjøres den om til matrix?
  pivot <- as.matrix(pivot)

  pivot <- gsub("Boomr ", "", pivot)
  pivot <- gsub("[.]", ",", pivot)

  # sortere ualfabetisk, fra nord til sør
  pivot <- sorterDatasett(pivot)

  # Remove rows with only NA
  # Taken from https://stackoverflow.com/questions/6437164/removing-empty-rows-of-a-data-file-in-r
  if (nrow(pivot) > 1) {
    pivot <- pivot[rowSums(is.na(pivot)) != ncol(pivot), ]
  }

  # Ta bort tekst hvis tekst under er lik
  if (!keep_names & length(rad) != 1) {
    pivot <- removeDoubleNames(pivot)
  }

  if (verdi %in% c("kontakter", "liggetid")) {
    pivot <- slashHeltall(pivot)
  }

  return(pivot)
}



# lager en pivot-tabell av sum av verdien "agg"
makePivot <- function(data, rad, kol, agg) {

  #' @importFrom magrittr "%>%"
  # gruppere
  # Burde skrives om, uten if nesting (issue #6)
  if (length(rad) == 1) {
    tmp <- data %>% dplyr::group_by_(rad, kol)
  }
  else if (length(rad) == 2) {
    tmp <- data %>% dplyr::group_by_(rad[1], rad[2], kol)
  }
  else{
    return(tomTabell())
  }

  # Velge ut verdier. Rater avhengig av boområdet!
  if (agg == "rate") {
    if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(bosh_rate))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_hf" %in% rad | kol == "boomr_hf") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(bohf_rate))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_rhf" %in% rad | kol == "boomr_rhf") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(borhf_rate))
      tmp <- round_df(tmp, digits = 1)
    }
    else {
      return(tomTabell())
    }
  } else if (agg == "drgrate") {
    if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(bosh_drgrate))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_hf" %in% rad | kol == "boomr_hf") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(bohf_drgrate))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_rhf" %in% rad | kol == "boomr_rhf") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(borhf_drgrate))
      tmp <- round_df(tmp, digits = 1)
    }
    else {
      return(tomTabell())
    }
  } else if (agg == "liggedognrate") {
    if ("boomr_sykehus" %in% rad | kol == "boomr_sykehus") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(bosh_liggerate))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_hf" %in% rad | kol == "boomr_hf") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(bohf_liggerate))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_rhf" %in% rad | kol == "boomr_rhf") {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(borhf_liggerate))
      tmp <- round_df(tmp, digits = 1)
    }
    else {
      return(tomTabell())
    }
  } else if (agg == "drg_poeng") {
    tmp <- tmp %>% dplyr::summarise(verdi = sum(drg_poeng))
    tmp <- round_df(tmp, digits = 0)
  } else if (agg == "drg_index") {
    tmp_kontakt <- tmp %>% dplyr::summarise(verdi = sum(kontakter))
    tmp <- tmp %>% dplyr::summarise(verdi = sum(drg_poeng))
    if (kol %in% rad) {
      start <- length(rad) + 1
    }
    else {
      start <- length(rad) + 2
    }
    for (i in start:length(names(tmp))) {
      tmp[, i] <- tmp[, i] / tmp_kontakt[, i]
      tmp <- round_df(tmp, digits = 3)
    }
  } else if (agg == "liggedognindex") {
    tmp_kontakt <- tmp %>% dplyr::summarise(verdi = sum(kontakter))
    tmp <- tmp %>% dplyr::summarise(verdi = sum(liggetid))
    for (i in (length(rad) + 2):length(names(tmp))) {
      tmp[, i] <- tmp[, i] / tmp_kontakt[, i]
      tmp <- round_df(tmp, digits = 1)
    }
  } else {
    tmp <- tmp %>% dplyr::summarise_(verdi = lazyeval::interp(~sum(var), var = as.name(agg)))
    tmp <- round_df(tmp, digits = 1)
  }

  tmp2 <- tidyr::spread_(tmp, kol, "verdi")

  return(tmp2)
} # makePivot


# rund av alle tall i tabell
# tatt fra http://stackoverflow.com/a/32930130
round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))

  df[, nums] <- round(df[, nums], digits = digits)

  (df)
}

removeDoubleNames <- function(datasett) {
  # Only keep unique names first row of the table.

  if (is.null(dim(datasett)[1])) {
    return(datasett)
  }

  # Find rows with unique names
  uniqueNames <- match(unique(datasett[, 1]), datasett[, 1])
  # Use negative index to find cells with non-unique names
  datasett[-uniqueNames, 1] <- ""

  return(datasett)
}

sorterDatasett <- function(datasett) {
  # Sortere datasett i forhold til boområdet og behandlingsområdet

  # Hvis det kun er en rad, vil denne rutinen "ødelegge" tabellen.
  if (nrow(datasett) == 1) {
    return(datasett)
  }

  names1 <- c(
    "Eget lokalsykehus", # 1
    "Annet sykehus i eget HF", # 2
    "UNN Troms", # 3
    "UNN HF", # 4
    "NLSH Bod", # 5
    "Nordlandssyk", # 6
    "Annet HF i HN", # 7
    "HF i andre RHF", # 8 #A
    "Kirkenes", "Hammerfest", "Troms", "Harstad", "Narvik", "Vester", "Lofoten", "Bod", "Rana", "Mosj", "Sandnessj", # B
    "Finnmark", "Klinikk", "UNN", "Nordland", "Helgeland", "HF i S", # C
    "Bor utenfor", "Resterende", "Andre offentlige", "Private", # D
    "Helse Nord RHF", "Helse Midt-Norge", "Helse Vest RHF", "Helse S", # E
    "Døgnopphold", "Dagbehandling", "Poliklinikk", "Avtalespesialister", "Avtalespesialist", # F
    "Planlagt medisin", "Akutt medisin", "Planlagt kirurgi", "Akutt kirurgi", # G
    "Sum", "Akutt", "Planlagt" # H
  )

  names2 <- c(
    "aaa", "aab", "baa", "bab", "bac", "bae", "caa", "cab", #A
    "daa", "dab", "dac", "dad", "dae", "daf", "dag", "dah", "dai", "daj", "dak", #B
    "aba", "abb", "baf", "bag", "cba", "cbb", #C
    "xaa", "xbb", "xcc", "xxx", # D
    "aca", "acb", "acc", "acd", # E
    "ada", "adb", "adc", "yyy", "add", # F
    "aea", "aeb", "aec", "aed", # G
    "zzz", "mmm", "nnn" # H
  )
  tmp <- datasett

  for (i in seq_along(names1)) tmp <- gsub(names1[i], names2[i], tmp)

  tmp <- tmp[order(tmp[, 1], tmp[, 2]), ]

  for (i in seq_along(names1)) tmp <- gsub(names2[i], names1[i], tmp)

  return(tmp)
}


prosentFunc <- function(tabell, rad, kol) {
  # Må kjøres etter "addTotal"!
  if (kol != "aar") {
    # beregne prosent bortover
    for (i in (length(rad) + 1):length(names(tabell))) {
      tabell[, i] <- 100 * tabell[, i] / tabell[, length(names(tabell))]
      tabell <- round_df(tabell, digits = 1)
    }
  } else {
    # beregne prosent nedover
    tmp_tab <- tabell
    k <- 0
    for (i in ((1):nrow(tmp_tab))) {
      k <- k + 1
      if (tmp_tab[i, length(rad)] == "Sum") {
        for (j in (0:(k - 1))) {
          tmp_tab[(i - j), ] <- tmp_tab[i, ]
          k <- 0
        }
      }
    }
    for (i in ((1):nrow(tabell))) {
      for (j in ((length(rad) + 1):length(names(tabell)))) {
        tabell[i, j] <- 100 * tabell[i, j] / tmp_tab[i, j]
      }
    }
    tabell <- round_df(tabell, digits = 1)
  }

  return(tabell)
}


addTotal <- function(tabell, rad, kol) {

  if ("aar" %in% colnames(tabell)) {
    tabell$aar <- as.character(tabell$aar)
  }

  new_tab <- tabell
  myname <- "tmp"

  k <- 0
  num_val <- 0

  for (i in ((1):nrow(new_tab))) {
    k <- k + 1
    if (myname != "tmp") {
      num_val <- num_val + 1
    }
    if (((new_tab[i, 1] != myname) | (num_val == 0)) & (length(rad) != 1 | (num_val == 0))) {
      # telle på nytt hvis kolonne 1 er ulik i forrige rad
      for (j in (length(rad) + 1):length(names(new_tab))) {
        new_tab[i, j] <- new_tab[i, j]
      }
      if (k != 1) {
        new_row <- new_tab[i - 1, ]
        new_row[2] <- "Sum"
        if (num_val != 1) {
          tabell <- dplyr::bind_rows(tabell[1:k - 1, ], new_row, tabell[- (1:k - 1), ])
        } else {
          num_val <- 0
        }
        k <- k + 1
      }
    } else {
      # Legg til verdi i celle hvis kolonne 1 heter det samme i forrige rad
      for (j in (length(rad) + 1):length(names(new_tab))) {
        new_tab[i, j] <- (new_tab[i, j] + new_tab[i - 1, j])
      }
    }
    myname <- new_tab[i, 1]
  }
  new_row <- utils::tail(new_tab, 1)
  new_row[length(rad)] <- "Sum"

  if (num_val != 0) {
    tabell <- rbind(tabell[1:k, ], new_row, tabell[- (1:k), ])
  }

  return(tabell)
}

renameColumns <- function(tabell) {

  names(tabell) <- sub("behandlende_sykehus", "Behandlende sykehus", names(tabell))
  names(tabell) <- sub("behandlende_hf_hn", "Behandlende HF", names(tabell))
  names(tabell) <- sub("behandlende_hf", "Behandlende HF", names(tabell))
  names(tabell) <- sub("behandlende_rhf", "Behandlende RHF", names(tabell))
  names(tabell) <- sub("behandler", "Behandler", names(tabell))
  names(tabell) <- sub("boomr_sykehus", "Opptaksområde", names(tabell))
  names(tabell) <- sub("boomr_hf", "Opptaksområde", names(tabell))
  names(tabell) <- sub("boomr_rhf", "Opptaksområde", names(tabell))
  names(tabell) <- sub("alder", "Alder", names(tabell))
  names(tabell) <- sub("kjonn", "Kjønn", names(tabell))
  names(tabell) <- sub("behandlingsniva", "Behandlingsnivå", names(tabell))
  names(tabell) <- sub("drgtypehastegrad", "DRGtypeHastegrad", names(tabell))
  names(tabell) <- sub("hastegrad", "Hastegrad", names(tabell))
  names(tabell) <- sub("aar", "År", names(tabell))

  return(tabell)

}

addLastColumn <- function(pivot, rad, kol, verdi) {
  if (verdi %in% c("kontakter", "liggetid")) {
    rund <- 0
  } else if (verdi %in% c("drg_poeng")) {
    rund <- 1
  } else if (verdi %in% c("drg_index")) {
    rund <- 3
  } else {
    rund <- 1
  }

  if (((length(names(pivot)) - length(rad)) != 1)) {
    if ("aar" %in% kol) {
      pivot$Snitt <- rowMeans(pivot[, -seq_len(length(rad))], na.rm = TRUE)
      pivot$Snitt <- round(pivot$Snitt, rund)
    } else{
      pivot$Sum <- rowSums(pivot[, -seq_len(length(rad))], na.rm = TRUE)
      pivot$Sum <- round(pivot$Sum, rund)
    }
  }

  return(pivot)
}

tomTabell <- function() {
  return(data.frame())
}

slashHeltall <- function(tabell) {
  # erstatte tall mellom 1 og 4 med "-"
  tabell[suppressWarnings(as.numeric(tabell)) < 5 & suppressWarnings(as.numeric(tabell)) > 0] <- "-"
  return(tabell)

}
