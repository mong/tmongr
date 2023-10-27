get_data <- function() {
  if (exists("datasett")) {
    return(datasett)
  } else if (file.exists("fag.rds")) {
    datasett <- readRDS("fag.rds")
    return(datasett)
  } else if (file.exists("fag.csv")) {
    datasett <- utils::read.table("fag.csv",
      sep = ",",
      header = TRUE,
      encoding = "UTF-8",
      stringsAsFactors = FALSE
    )

    names(datasett) <- tolower(names(datasett))
    if (file.exists("fag2.csv")) {
      datasett2 <- utils::read.table(
        "fag2.csv",
        sep = ",",
        header = TRUE,
        encoding = "UTF-8",
        stringsAsFactors = FALSE
      )

      names(datasett2) <- tolower(names(datasett2))
      datasett2$niva <- "Uten overf"
      datasett$niva <- "Med overf"
      datasett <- rbind(datasett2, datasett)
    }
    return(datasett)
  } else if (file.exists("behandler.rds") && file.exists("justertoverf.rds")) {
    uten_overf <- readRDS("behandler.rds")
    med_overf <- readRDS("justertoverf.rds")

    uten_overf$niva <- "Uten overf"
    med_overf$niva <- "Med overf"

    return(rbind(uten_overf, med_overf))
  } else {
    return(tmongr::testdata3)
  }
}
