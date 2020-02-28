
rm(list=ls())

getwd()

uten_overf <- readRDS("../tabellverk/data/behandler.rds")
med_overf <- readRDS("../tabellverk/data/justertoverf.rds")

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

all_data <- rbind(uten_overf, med_overf)

dynamiskTabellverk::launch_application(datasett = all_data)

dynamiskTabellverk::submit_application(datasett = all_data, name = "tabellverk_2019_12_16")
