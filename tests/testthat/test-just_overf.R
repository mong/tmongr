
context("just_overf")

shiny::testModule(just_overf, {
  expect_equal_to_reference(output$just_overf, "data/just_overf.rds")
}, colnames = c("niva")
)

shiny::testModule(just_overf, {
  expect_null(output$just_overf)
}, colnames = c("nivaa")
)

