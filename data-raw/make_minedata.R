


rm(list = ls())

getwd()

all_files <- c(
  "../../data/testdata.rda",
  "../../data/testdata2.rda"
)

all_names <- c(
  "TESTING 1",
  "TESTING 2"
)

all_data <- lapply(all_files, load)

names(all_data) <- all_names

dir.create("data")
save(all_data, file = "data/data.RData")

# testdata3 19. mars 2020

uten_overf <- readRDS("../tabellverk/data/behandler.rds")
uten_overf <- uten_overf[(uten_overf$kontakter > 5), ]
uten_overf$niva <- "Uten overf"

med_overf <- readRDS("../tabellverk/data/justertoverf.rds")
med_overf <- med_overf[(med_overf$kontakter > 5), ]
med_overf$niva <- "Med overf"

uten_overf <- uten_overf[sample(nrow(uten_overf), 1000), ]
med_overf <- med_overf[sample(nrow(med_overf), 1000), ]

testdata3 <- rbind(uten_overf, med_overf)

usethis::use_data(testdata3, overwrite = TRUE)
