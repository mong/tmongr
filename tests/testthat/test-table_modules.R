context("tableModules")

test_that("tab_panel_server", {
    shiny::testModule(tab_panel_server, {
        expect_equal_to_reference(output$tabeller[["deps"]], "data/module_tab_panel1.rds")
    })
})
