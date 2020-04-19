
context("buttonModules")

test_that("just_overf_server", {
  shiny::testServer(just_overf_server, {
    expect_equal_to_reference(output$just_overf, "data/just_overf_server.rds")
  }, colnames = c("niva")
  )

  shiny::testServer(just_overf_server, {
    expect_null(output$just_overf)
  }, colnames = c("nivaa")
  )
})
