


rm(list=ls())

getwd()

all_files = c(
  "../../data/testdata.rda",
  "../../data/testdata2.rda"
)

all_names = c(
  "TESTING 1",
  "TESTING 2"
)

all_data <- lapply(all_files, load)

names(all_data) <- all_names

dir.create("data")
save(all_data, file = "data/data.RData")

