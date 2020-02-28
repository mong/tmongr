
context("justOverf")

shiny::testModule(justOverf, {
  expect_equal_to_reference(output$just_overf, "data/just_overf.rds")
}, colnames = c("niva")
)

shiny::testModule(justOverf, {
  expect_null(output$just_overf)
}, colnames = c("nivaa")
)

test_that("justOverfUI", {
  expect_error(justOverfUI())
  expect_equal_to_reference(justOverfUI("test"), "data/just_overfUI1.rds")
  expect_equal_to_reference(justOverfUI(id = "test"), "data/just_overfUI1.rds")
  expect_equal_to_reference(justOverfUI("testingMore"), "data/just_overfUI2.rds")
  expect_error(justOverfUI("test1", "test2"))
})
