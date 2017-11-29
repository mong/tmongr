context("definerValgKol")

test_that("definerValgKol returns correct values", {
  expect_equal_to_reference(definerValgKol(testdata,1), "data/defvalg1")
  expect_equal_to_reference(definerValgKol(testdata,2), "data/defvalg2")
  expect_equal_to_reference(definerValgKol(testdata,3), "data/defvalg3")
  expect_equal_to_reference(definerValgKol(testdata,4), "data/defvalg4")
  
  expect_equal_to_reference(definerValgKol(testdata2,1), "data/defvalg1alt")
  expect_equal_to_reference(definerValgKol(testdata2,2), "data/defvalg2alt")
  expect_equal_to_reference(definerValgKol(testdata2,3), "data/defvalg3alt")
  expect_equal_to_reference(definerValgKol(testdata2,4), "data/defvalg4alt")
  expect_null(definerValgKol(testdata,5))
  expect_null(definerValgKol(testdata2,5))
  
})

