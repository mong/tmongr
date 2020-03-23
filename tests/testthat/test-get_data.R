test_that("get_data with files on disk", {

  saveRDS(testdata, file = "behandler.rds")
  expect_equal(get_data(), testdata3)

  saveRDS(testdata2, file = "justertoverf.rds")
  expect_error(get_data())
  file.remove("justertoverf.rds")

  saveRDS(testdata, file = "justertoverf.rds")
  expect_equal_to_reference(get_data(), "data/get_data.rds")

  file.remove("behandler.rds")
  file.remove("justertoverf.rds")
})

test_that("get_data without files on disk", {
  expect_equal(get_data(), testdata3)

  datasett <<- "qwerty"
  expect_equal(get_data(), "qwerty")
})
