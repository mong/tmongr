context("definerValgKol")

test_that("definerValgKol returns correct values", {
  expect_equal_to_reference(definerValgKol(testdata, 1), "data/defvalg1.rds")
  expect_equal_to_reference(definerValgKol(testdata, 2), "data/defvalg2.rds")
  expect_equal_to_reference(definerValgKol(testdata, 3), "data/defvalg3.rds")
  expect_equal_to_reference(definerValgKol(testdata, 4), "data/defvalg4.rds")

  expect_equal_to_reference(definerValgKol(testdata2, 1), "data/defvalg1alt.rds")
  expect_equal_to_reference(definerValgKol(testdata2, 2), "data/defvalg2alt.rds")
  expect_equal_to_reference(definerValgKol(testdata2, 3), "data/defvalg3alt.rds")
  expect_equal_to_reference(definerValgKol(testdata2, 4), "data/defvalg4alt.rds")
  expect_null(definerValgKol(testdata, 5))
  expect_null(definerValgKol(testdata2, 5))
})
