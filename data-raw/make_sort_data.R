sort <- read.csv2("data-raw/sorting.csv", stringsAsFactors = FALSE)

usethis::use_data(sort, overwrite = TRUE)
