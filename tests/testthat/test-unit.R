context("unit")

test_that("filterBo is correct", {
  for (bo in c(1,2,3,4,5,6)){
    expect_equal_to_reference(filterBo(testdata, bo), paste("unit_bo_",bo,sep = ""))
  }
  for (i in 7:1000) expect_null(filterBo(testdata, i))
  expect_null(filterBo(testdata, "random_string"))
})

test_that("filterBeh is correct", {
  for (beh in c(1,2,3,4,5,6,7)){
    expect_equal_to_reference(filterBeh(testdata, beh), paste("unit_beh_",beh,sep = ""))
  }
  random_number <- floor(runif(1, min=8, max=1000))
  expect_null(filterBeh(testdata, random_number))
  expect_null(filterBeh(testdata, "random_string"))
})


