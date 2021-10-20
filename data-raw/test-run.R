
rm(list=ls())

getwd()

uten_overf <- readRDS("../tabellverk/data/behandler.rds")
med_overf <- readRDS("../tabellverk/data/justertoverf.rds")

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

datasett <- rbind(uten_overf, med_overf)

run_app()


datasett <- read.table('../tmongrdata/fag.csv', 
                   sep = ",", 
                   header=T, 
                   encoding = 'UTF-8', 
                   stringsAsFactors = FALSE)

names(datasett) <- tolower(names(datasett))

run_app()
