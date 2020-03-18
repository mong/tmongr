test_that("get_data", {
  testthat::expect_equal(get_data(), testdata3)

  datasett <<- "qwerty"
  testthat::expect_equal(get_data(), "qwerty")
})
