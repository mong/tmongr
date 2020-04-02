sort <- read.csv2("data-raw/sorting.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

usethis::use_data(sort, overwrite = TRUE)
