library(testthat)
library(dynamiskTabellverk)

load(file=system.file("data","testdata.rda", package = "dynamiskTabellverk"))


test_check("dynamiskTabellverk")
