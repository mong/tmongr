library(testthat)
library(dynamiskTabellverk)

#load(file=system.file("data","testdata.rda", package = "dynamiskTabellverk"))
data("testdata")

test_check("dynamiskTabellverk")
