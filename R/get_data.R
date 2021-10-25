get_data <- function() {
  if (exists("datasett")) {
    return(datasett)
  } else if (file.exists("fag.csv")) {
    datasett <- read.table("fag.csv",
                           sep = ",",
                           header = T,
                           encoding = "UTF-8",
                           stringsAsFactors = FALSE)

    names(datasett) <- tolower(names(datasett))
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
