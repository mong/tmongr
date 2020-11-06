
rm(list=ls())

getwd()

uten_overf <- read.table('../tmongrdata/avd_behandlert19.csv', 
                         sep = ",", 
                         header=T, 
                         fileEncoding = "LATIN1", 
                         stringsAsFactors = FALSE)

data_2019 <- read.table('../tmongrdata/avd_behandler_2019.csv', 
                         sep = ",", 
                         header=T, 
                         fileEncoding = "LATIN1", 
                         stringsAsFactors = FALSE)

uten_overf <- rbind(uten_overf, data_2019)


med_overf <- read.table('../tmongrdata/avd_justoverft19.csv', 
                        sep = ",", 
                        header=T, 
                        fileEncoding = "LATIN1", 
                        stringsAsFactors = FALSE)

data_2019_overf <- read.table('../tmongrdata/avd_justoverf_2019.csv', 
                        sep = ",", 
                        header=T, 
                        fileEncoding = "LATIN1", 
                        stringsAsFactors = FALSE)

med_overf <- rbind(med_overf, data_2019_overf)

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

datasett <- rbind(uten_overf, med_overf)

names(datasett) <- tolower(names(datasett))

run_app()


## SHO ##
rm(list=ls())

uten_overf <- read.table('../tmongrdata/sho_behandlert19.csv', 
                         sep = ",", 
                         header=T,
                         fileEncoding = "LATIN1", 
                         stringsAsFactors = FALSE)

data_2019 <- read.table('../tmongrdata/sho_behandler_2019.csv', 
                        sep = ",", 
                        header=T, 
                        fileEncoding = "LATIN1", 
                        stringsAsFactors = FALSE)

uten_overf <- rbind(uten_overf, data_2019)


med_overf <- read.table('../tmongrdata/sho_justoverft19.csv', 
                        sep = ",", 
                        header=T, 
                        fileEncoding = "LATIN1", 
                        stringsAsFactors = FALSE)

data_2019_overf <- read.table('../tmongrdata/sho_justoverf_2019.csv', 
                              sep = ",", 
                              header=T, 
                              fileEncoding = "LATIN1", 
                              stringsAsFactors = FALSE)

med_overf <- rbind(med_overf, data_2019_overf)

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

datasett2 <- rbind(uten_overf, med_overf)

names(datasett2) <- tolower(names(datasett2))

tmongr::run_app(data = datasett2)
  

## SHO fagomr ##
rm(list=ls())

uten_overf <- read.table('../tmongrdata/sho_fagt19.csv', 
                         sep = ",", 
                         header=T,
                         fileEncoding = "LATIN1", 
                         stringsAsFactors = FALSE)

data_2019 <- read.table('../tmongrdata/sho_fagomr_2019.csv', 
                        sep = ",", 
                        header=T, 
                        fileEncoding = "LATIN1", 
                        stringsAsFactors = FALSE)

uten_overf <- rbind(uten_overf, data_2019)


med_overf <- read.table('../tmongrdata/sho_fag_justoverft19.csv', 
                        sep = ",", 
                        header=T, 
                        fileEncoding = "LATIN1", 
                        stringsAsFactors = FALSE)

data_2019_overf <- read.table('../tmongrdata/sho_fagomr_justoverf_2019.csv', 
                              sep = ",", 
                              header=T, 
                              fileEncoding = "LATIN1", 
                              stringsAsFactors = FALSE)

med_overf <- rbind(med_overf, data_2019_overf)

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

datasett <- rbind(uten_overf, med_overf)

names(datasett) <- tolower(names(datasett))

tmongr::run_app()
