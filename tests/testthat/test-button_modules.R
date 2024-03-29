
context("buttonModules")

test_that("just_overf_server", {
  shiny::testServer(just_overf_server, args = list(colnames = c("niva")), {
    expect_equal_to_reference(strsplit(output$just_overf[["html"]], "\n")[[1]][1], "data/just_overf_server.rds")
  })

  shiny::testServer(just_overf_server, args = list(colnames = c("nivaa")), {
    expect_null(output$just_overf)
  })
})
