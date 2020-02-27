
context("just_overf")

shiny::testModule(just_overf, {
  expect_equal_to_reference(output$just_overf, "data/just_overf.rds")
}, colnames = c("niva")
)

shiny::testModule(just_overf, {
  expect_null(output$just_overf)
}, colnames = c("nivaa")
)

test_that("just_overfUI", {
  expect_error(just_overfUI())
  expect_equal_to_reference(just_overfUI("test"), "data/just_overfUI1.rds")
  expect_equal_to_reference(just_overfUI(id = "test"), "data/just_overfUI1.rds")
  expect_equal_to_reference(just_overfUI("testingMore"), "data/just_overfUI2.rds")
  expect_error(just_overfUI("test1", "test2"))
})
