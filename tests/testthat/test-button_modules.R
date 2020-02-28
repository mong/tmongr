
context("buttonModules")

test_that("just_overf_server", {
  shiny::testModule(just_overf_server, {
    expect_equal_to_reference(output$just_overf, "data/just_overf_server.rds")
  }, colnames = c("niva")
  )

  shiny::testModule(just_overf_server, {
    expect_null(output$just_overf)
  }, colnames = c("nivaa")
  )
})

test_that("just_overf_ui", {
  expect_error(just_overf_ui())
  expect_equal_to_reference(just_overf_ui("test"), "data/just_overf_ui1.rds")
  expect_equal_to_reference(just_overf_ui(id = "test"), "data/just_overf_ui1.rds")
  expect_equal_to_reference(just_overf_ui("testingMore"), "data/just_overf_ui2.rds")
  expect_error(just_overf_ui("test1", "test2"))
})
