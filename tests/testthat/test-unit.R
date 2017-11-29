context("unit")

test_that("filterBo is correct", {
  for (bo in c(1,2,3,4,5,6)){
    expect_equal_to_reference(filterBo(testdata, bo), paste("data/unit_bo_",bo,sep = ""))
  }
  for (i in 7:1000) expect_null(filterBo(testdata, i))
  expect_null(filterBo(testdata, "random_string"))
})

test_that("filterBeh is correct", {
  for (beh in c(1,2,3,4,5,6,7)){
    expect_equal_to_reference(filterBeh(testdata, beh), paste("data/unit_beh_",beh,sep = ""))
  }
  random_number <- floor(runif(1, min=8, max=1000))
  expect_null(filterBeh(testdata, random_number))
  expect_null(filterBeh(testdata, "random_string"))
})

test_that("filterAar is correct", {
  k = 0
  for (aar in c("2013",c("2011","2016"), c("2010", "2011", "2016"))){
    k = k + 1
    expect_equal_to_reference(filterAar(testdata,filter = aar), paste0("data/unit_aar_", k))
  }
  expect_equal(nrow(filterAar(testdata,"2010")), 0)
  expect_equal(filterAar(testdata,c("2011","2016")), filterAar(testdata,filter = c("2010", "2011", "2016")))
})


