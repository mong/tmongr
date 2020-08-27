## SHO ##
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


names(uten_overf) <- tolower(names(uten_overf))


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


names(med_overf) <- tolower(names(med_overf))

uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"
all_data <- rbind(uten_overf, med_overf)


# Run the following line to test the app locally first
dynamiskTabellverk::launch_application(datasett = all_data)

remotes::install_github("mong/tmongr", ref = "v2.8")

# Submit the app to shinyapp.io
dynamiskTabellverk::submit_application(datasett = all_data,
                                       name = "tabellverk_fag_2020_08_27")


