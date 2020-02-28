context("checkboxModules")

test_that("aar_ui", {
    id <- "aar"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("behandlingsniva_ui", {
    id <- "behandlingsniva"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("hastegrad1_ui", {
    id <- "hastegrad1"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("hastegrad2_ui", {
    id <- "hastegrad2"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("kjonn_ui", {
    id <- "kjonn"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("alder_ui", {
    id <- "alder"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("prosent_ui", {
    id <- "prosent"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("forenkling_ui", {
    id <- "forenkling"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("snitt_ui", {
    id <- "snitt"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

test_that("keep_names_ui", {
    id <- "keep_names"
    function_name <- get(paste0(id, "_ui"))
    expect_error(function_name())
    expect_equal(function_name("test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("test")$attribs$class, "shiny-html-output")
    expect_equal(function_name(id = "test")$attribs$id, paste0("test-", id))
    expect_equal(function_name("testingMore")$attribs$id, paste0("testingMore-", id))
    expect_error(function_name("test1", "test2"))
})

