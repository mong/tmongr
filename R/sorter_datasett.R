sorter_datasett <- function(datasett, rad) {
  # Sortere datasett i forhold til boområdet og behandlingsområdet

  # Hvis det kun er en rad, vil denne rutinen "ødelegge" tabellen.
  if (nrow(datasett) == 1) {
    return(datasett)
  }

  filter_sort <- function(condition, df) {
    output <- df %>%
      dplyr::filter(variable == condition)
    return(output)
  }

  sort_list <- lapply(rad, filter_sort, tmongr::sort)

  datasett <- as.data.frame(datasett, stringsAsFactors = FALSE)

  k <- 0
  for (i in sort_list) {
    k <- k + 1
    datasett$value <- datasett[[k]]
    datasett <- dplyr::left_join(datasett, i, by = "value", copy = TRUE)
    datasett[[paste0("sort", k)]] <- datasett$sort
    datasett$sort <- NULL
    datasett$variable <- NULL
    datasett$value <- NULL
  }

  if (k == 1) {
    datasett <- dplyr::arrange(datasett, sort1)
    datasett$sort1 <- NULL
  } else if (k == 2) {
    datasett <- dplyr::arrange(datasett, sort1, sort2)
    datasett$sort1 <- NULL
    datasett$sort2 <- NULL
  } else if (k == 3) {
    datasett <- dplyr::arrange(datasett, sort1, sort2, sort3)
    datasett$sort1 <- NULL
    datasett$sort2 <- NULL
    datasett$sort3 <- NULL
  }

  datasett <- as.matrix(datasett)

  return(datasett)
}
