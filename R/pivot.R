#' Make a pivot table
#'
#' @param input_dataset The dataset that is going to be tabulated
#' @param fane The active tab (for filtering; effect if "dogn", "dag" or "poli")
#' @param verdier Consist of data specific filter values, such as "rader", "kolonner", "aar", "bo", "beh" etc.
#' @param keep_names Tabulate all names in first row
#' @param snitt Add average/sums to the table
#'
#' @return pivot Pivot table
#' @importFrom rlang .data
#' @export
#'
make_data_tabell <- function(input_dataset,
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
  tabell <- filtrer_ut(tabell, fane, verdi,
                      aar, bo, beh, behandlingsniva, alder, kjonn, hastegrad1, hastegrad2)

  # Returnere ingenting hvis hele tabellen filtreres bort
  if (!nrow(tabell)) {
    return()
  }

  # Erstatte NA med null
  tabell[is.na(tabell)] <- 0

  # lage pivot-tabell av det som er igjen. Rutinen ligger under.
  pivot <- make_pivot(tabell, rad, kol, verdi)
  if (!nrow(pivot)) {
    return()
  }

  # Erstatte NA med null (er dette nødvendig en gang til?)
  pivot[is.na(pivot)] <- 0

  if (is.null(pivot)) {
    return()
  }

  regnet_total <- FALSE

  # Burde vi legge inn snitt i steden for total for de to tilfellene index og liggedognindex?
  if (snitt | prosent) {
    if (!("drg_index" %in% verdi | "liggedognindex" %in% verdi) &
        !(verdi %in% c("rate", "drgrate", "liggedognrate") & length(rad) == 1)) {
      # ikke regn ut total på rater når en rad er bohf og den andre rad er bosh
      if (!((verdi %in% c("rate", "drgrate", "liggedognrate")) &
             ("boomr_hf" %in% rad) &
             ("boomr_sykehus" %in% rad))) {
        regnet_total <- TRUE
        pivot <- add_total(pivot, rad, kol)
      }
    }
  }

  # legge inn sum eller snitt i siste kolonne
  if (snitt) {
    pivot <- add_last_column(pivot, rad, kol, verdi)
  }

  # Prosent blir 100 på alle, hvis sum ikke er beregnet. Har vi noe alternativ?
  if (prosent == TRUE && regnet_total) {
    pivot <- prosent_func(pivot, rad, kol)
  }

  # fjerne navn på rad (1, 2, 3, etc.)
  row.names(pivot) <- NULL

  # bedre navn i kolonneoverskrift
  pivot <- rename_columns(pivot)

  # Hvorfor gjøres den om til matrix?
  pivot <- as.matrix(pivot)

  pivot <- gsub("Boomr ", "", pivot)
  pivot <- gsub("[.]", ",", pivot)

  # sortere ualfabetisk, fra nord til sør
  pivot <- sorter_datasett(pivot, rad, kol)

  # Remove rows with only NA
  # Taken from https://stackoverflow.com/questions/6437164/removing-empty-rows-of-a-data-file-in-r
  if (nrow(pivot) > 1) {
    pivot <- pivot[rowSums(is.na(pivot)) != ncol(pivot), ]
  }

  # Ta bort tekst hvis tekst under er lik
  if (!keep_names & length(rad) != 1) {
    pivot <- remove_double_names(pivot)
  }

  if (verdi %in% c("kontakter", "liggetid")) {
    pivot <- slash_heltall(pivot)
  }

  return(pivot)
}



# lager en pivot-tabell av sum av verdien "agg"
make_pivot <- function(data, rad, kol, agg) {

  #' @importFrom magrittr "%>%"
  # gruppere
  # Burde skrives om, uten if nesting (issue #6)
  group_var <- unique(c(rad, kol))
  if (length(rad) %in% c(1, 2)) {
    tmp <- data %>% dplyr::group_by(.dots = group_var)
  } else{
    return(tom_tabell())
  }

  # Velge ut verdier. Rater avhengig av boområdet!
  if (agg %in% c("rate", "drgrate")) {
    if ("boomr_sykehus" %in% c(rad, kol)) {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[[paste0("bosh_", agg)]]))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_hf" %in% c(rad, kol)) {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[[paste0("bohf_", agg)]]))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_rhf" %in% c(rad, kol)) {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[[paste0("borhf_", agg)]]))
      tmp <- round_df(tmp, digits = 1)
    }
    else {
      return(tom_tabell())
    }
  } else if (agg == "liggedognrate") {
    if ("boomr_sykehus" %in% c(rad, kol)) {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[["bosh_liggerate"]]))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_hf" %in% c(rad, kol)) {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[["bohf_liggerate"]]))
      tmp <- round_df(tmp, digits = 1)
    }
    else if ("boomr_rhf" %in% c(rad, kol)) {
      tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[["borhf_liggerate"]]))
      tmp <- round_df(tmp, digits = 1)
    }
    else {
      return(tom_tabell())
    }
  } else if (agg == "drg_poeng") {
    tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[["drg_poeng"]]))
    tmp <- round_df(tmp, digits = 0)
  } else if (agg == "drg_index") {
    tmp_kontakt <- tmp %>% dplyr::summarise(verdi = sum(.data[["kontakter"]]))
    tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[["drg_poeng"]]))
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
    tmp_kontakt <- tmp %>% dplyr::summarise(verdi = sum(.data[["kontakter"]]))
    tmp <- tmp %>% dplyr::summarise(verdi = sum(.data[["liggetid"]]))
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
} # make_pivot


# rund av alle tall i tabell
# tatt fra http://stackoverflow.com/a/32930130
round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))

  df[, nums] <- round(df[, nums], digits = digits)

  (df)
}

remove_double_names <- function(datasett) {
  # Only keep unique names first row of the table.

  if (is.null(dim(datasett)[1])) {
    return(datasett)
  }

  # Find rows with unique names
  unique_names <- match(unique(datasett[, 1]), datasett[, 1])
  # Use negative index to find cells with non-unique names
  datasett[-unique_names, 1] <- ""

  return(datasett)
}

prosent_func <- function(tabell, rad, kol) {
  # Må kjøres etter "add_total"!
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


add_total <- function(tabell, rad, kol) {

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

rename_columns <- function(tabell) {

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

add_last_column <- function(pivot, rad, kol, verdi) {
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
      # nolint start
      pivot$Snitt <- rowMeans(pivot[, -seq_len(length(rad))], na.rm = TRUE)
      pivot$Snitt <- round(pivot$Snitt, rund)
    } else{
      pivot$Sum <- rowSums(pivot[, -seq_len(length(rad))], na.rm = TRUE)
      pivot$Sum <- round(pivot$Sum, rund)
      # nolint end
    }
  }

  return(pivot)
}

tom_tabell <- function() {
  return(data.frame())
}

slash_heltall <- function(tabell) {
  # erstatte tall mellom 1 og 4 med "-"
  tabell[suppressWarnings(as.numeric(tabell)) < 5 & suppressWarnings(as.numeric(tabell)) > 0] <- "-"
  return(tabell)

}
