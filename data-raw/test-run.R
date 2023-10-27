rm(list = ls())

getwd()

datasett <- utils::read.table(
  "../tmongrdata/fag.csv",
  sep = ",",
  header = TRUE,
  encoding = "UTF-8",
  stringsAsFactors = FALSE
)

names(datasett) <- tolower(names(datasett))

datasett2 <- utils::read.table(
  "../tmongrdata/fag2.csv",
  sep = ",",
  header = TRUE,
  encoding = "UTF-8",
  stringsAsFactors = FALSE
)

names(datasett2) <- tolower(names(datasett2))
datasett2$niva <- "Uten overf"
datasett$niva <- "Med overf"
datasett <- rbind(datasett2, datasett)

tmongr::run_app()
