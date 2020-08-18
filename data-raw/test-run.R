
rm(list=ls())

getwd()

uten_overf <- read.table('../tmongrdata/avd_behandlert19.csv', 
                         sep = ",", 
                         header=T, 
                         encoding = 'UTF-8', 
                         stringsAsFactors = FALSE)

med_overf <- read.table('../tmongrdata/avd_justoverft19.csv', 
                        sep = ",", 
                        header=T, 
                        encoding = 'UTF-8', 
                        stringsAsFactors = FALSE)


uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

datasett <- rbind(uten_overf, med_overf)

names(datasett) <- tolower(names(datasett))

run_app()
