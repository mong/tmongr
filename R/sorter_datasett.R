sorter_datasett <- function(datasett, rad, kol) {
  # Sortere datasett i forhold til boområdet og behandlingsområdet

  filter_sort <- function(condition, df) {
    output <- df %>%
      dplyr::filter(variable == condition)
    return(output)
  }

  sort_list <- lapply(rad, filter_sort, tmongr::sort)

  datasett <- as.data.frame(datasett, stringsAsFactors = FALSE)
  column_names <- colnames(datasett)
  colnames(datasett) <- stringi::stri_rand_strings(length(column_names), 5)

  k <- 0
  if (length(rad) == 1) {
    datasett$value <- datasett[[1]]
    datasett <- dplyr::left_join(datasett, sort_list[[1]], by = "value", copy = TRUE)
    datasett[["sort1"]] <- datasett$sort
    datasett$sort <- NULL
    datasett$variable <- NULL
    datasett$value <- NULL
    datasett <- dplyr::arrange(datasett, sort1)
    datasett$sort1 <- NULL
  } else if (length(rad) == 2 && rad[1] %in% kol) {
    datasett$value <- datasett[[1]]
    datasett <- dplyr::left_join(datasett, sort_list[[2]], by = "value", copy = TRUE)
    datasett[["sort1"]] <- datasett$sort
    datasett$sort <- NULL
    datasett$variable <- NULL
    datasett$value <- NULL
    datasett <- dplyr::arrange(datasett, sort1)
    datasett$sort1 <- NULL
  } else if (length(rad) > 1) {
    for (i in sort_list) {
      k <- k + 1
      datasett$value <- datasett[[k]]
      datasett <- dplyr::left_join(datasett, i, by = "value", copy = TRUE)
      datasett[[paste0("sort", k)]] <- datasett$sort
      datasett$sort <- NULL
      datasett$variable <- NULL
      datasett$value <- NULL
    }
  }

 if (k == 2) {
    datasett <- dplyr::arrange(datasett, sort1, sort2)
    datasett$sort1 <- NULL
    datasett$sort2 <- NULL
  }

  colnames(datasett) <- column_names

  datasett <- as.matrix(datasett)

  return(datasett)
}
