context("uiModules")

test_that("common_ui", {
    expect_error(common_ui())
    expect_equal_to_reference(common_ui("test"), "data/common_ui.rds")
    expect_equal(common_ui(TRUE)$attribs$id, "TRUE-TRUE")
    expect_equal(common_ui(FALSE)$attribs$id, "FALSE-FALSE")
    expect_equal(common_ui(42)$attribs$id, "42-42")
    expect_equal(common_ui("hello world")$attribs$id, "hello world-hello world")
    expect_equal(common_ui("")$attribs$id, "-")
    expect_equal(common_ui("")$attribs$class, "shiny-html-output")
    expect_equal(common_ui(id = "qwerty")$attribs$id, "qwerty-qwerty")
    expect_error(common_ui("test1", "test2"))
})
