
rm(list=ls())

getwd()

uten_overf <- readRDS("../tabellverk/data/behandler.rds")
med_overf <- readRDS("../tabellverk/data/justertoverf.rds")

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

datasett <- rbind(uten_overf, med_overf)

run_app()
