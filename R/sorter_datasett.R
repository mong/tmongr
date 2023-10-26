sorter_datasett <- function(datasett, rad = NULL, kol = NULL) {
  # Sortere datasett i forhold til boområdet og behandlingsområdet

  filter_sort <- function(condition, df) {
    output <- df %>%
      dplyr::filter(.data$variable == condition)
    return(output)
  }

  sort_list <- lapply(rad, filter_sort, tmongr::sortdataset)

  datasett <- as.data.frame(datasett, stringsAsFactors = FALSE)
  column_names <- colnames(datasett)
  colnames(datasett) <- stringi::stri_rand_strings(length(column_names), 5)

  datasett$value <- datasett[[1]]

  if (rad[1] %in% kol) {
    datasett <- dplyr::left_join(datasett, sort_list[[2]], by = "value", copy = TRUE)
  } else {
    datasett <- dplyr::left_join(datasett, sort_list[[1]], by = "value", copy = TRUE)
  }

  datasett[["sort1"]] <- datasett$sort
  datasett$sort <- NULL
  datasett$variable <- NULL
  datasett$value <- NULL

  if (length(rad) == 1 || rad[1] %in% kol) {
    datasett <- dplyr::arrange(datasett, .data$sort1)
    datasett$sort1 <- NULL
  } else if (length(rad) == 2) {
    datasett$value <- datasett[[2]]
    datasett <- dplyr::left_join(datasett, sort_list[[2]], by = "value", copy = TRUE)
    datasett[["sort2"]] <- datasett$sort
    datasett$sort <- NULL
    datasett$variable <- NULL
    datasett$value <- NULL
    datasett <- dplyr::arrange(datasett, .data$sort1, .data$sort2)
    datasett$sort1 <- NULL
    datasett$sort2 <- NULL
  }

  colnames(datasett) <- column_names

  datasett <- as.matrix(datasett)

  return(datasett)
}
