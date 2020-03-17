


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


tmp1 <- dynamiskTabellverk::testdata2
tmp1$niva <- "Niva1"

tmp2 <- dynamiskTabellverk::testdata2
tmp2$niva <- "Niva2"

testdata3 <- rbind(tmp1, tmp2)

usethis::use_data(testdata3, overwrite = TRUE)
