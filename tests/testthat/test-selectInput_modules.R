context("selectInputModules")

test_that("rad1_ui", {
    id <- "rad1"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("rad2_ui", {
    id <- "rad2"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("kolonner_ui", {
    id <- "kolonner"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("verdi_ui", {
    id <- "verdi"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})
