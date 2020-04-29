context("checkboxModules")

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn")), {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk")), {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    })

    shiny::testServer(function_name, {
        expect_error(output$aar)
    })

})

test_that("behandlingsniva_server", {
    id <- "behandlingsniva"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"),
                                                 colnames = c("qwerty", "behandlingsniva")), {
        expect_equal_to_reference(output$behandlingsniva,
                                  paste0("data/module_", "behandlingsniva", "1.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"),
                                                 colnames = c("qwerty", "behandlingsniva")), {
        expect_equal_to_reference(output$behandlingsniva,
                                  paste0("data/module_", "behandlingsniva", "2.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = NULL,
                                                 colnames = c("qwerty", "behandlingsniva1")), {
        expect_null(output$behandlingsniva)
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk")), {
        expect_error(output$behandlingsniva)
    })

    shiny::testServer(function_name, {
        expect_error(output$behandlingsniva)
    })

})

test_that("hastegrad1_server", {
    id <- "hastegrad1"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"),
                                                 colnames = c("qwerty", "hastegrad")), {
        expect_equal_to_reference(output$hastegrad1,
                                  paste0("data/module_", "hastegrad1", "1.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"),
                                                 colnames = c("qwerty", "hastegrad")), {
        expect_equal_to_reference(output$hastegrad1,
                                  paste0("data/module_", "hastegrad1", "2.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = NULL,
                                                 colnames = c("qwerty", "hastegrad1")), {
        expect_null(output$hastegrad1)
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk")), {
        expect_error(output$hastegrad1)
    })

    shiny::testServer(function_name, {
        expect_error(output$hastegrad1)
    })

})

test_that("hastegrad2_server", {
    id <- "hastegrad2"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"),
                                                 colnames = c("qwerty", "drgtypehastegrad")), {
        expect_equal_to_reference(output$hastegrad2,
                                  paste0("data/module_", "hastegrad2", "1.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"),
                                                 colnames = c("qwerty", "drgtypehastegrad")), {
        expect_equal_to_reference(output$hastegrad2,
                                  paste0("data/module_", "hastegrad2", "2.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = NULL,
                                                 colnames = c("qwerty", "drgtypehastegrad1")), {
        expect_null(output$hastegrad2)
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk")), {
        expect_error(output$hastegrad2)
    })

    shiny::testServer(function_name, {
        expect_error(output$hastegrad2)
    })

})

test_that("kjonn_server", {
    id <- "kjonn"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"),
                                                 colnames = c("qwerty", "kjonn")), {
        expect_equal_to_reference(output$kjonn,
                                  paste0("data/module_", "kjonn", "1.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"),
                                                 colnames = c("qwerty", "kjonn")), {
        expect_equal_to_reference(output$kjonn,
                                  paste0("data/module_", "kjonn", "2.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = NULL,
                                                 colnames = c("qwerty", "kjonn1")), {
        expect_null(output$kjonn)
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk")), {
        expect_error(output$kjonn)
    })

    shiny::testServer(function_name, {
        expect_error(output$kjonn)
    })

})

test_that("alder_server", {
    id <- "alder"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"),
                                                 colnames = c("qwerty", "alder")), {
        expect_equal_to_reference(output$alder,
                                  paste0("data/module_", "alder", "1.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"),
                                                 colnames = c("qwerty", "alder")), {
        expect_equal_to_reference(output$alder,
                                  paste0("data/module_", "alder", "2.rds")
                                  )
    })

    shiny::testServer(function_name, args = list(pickable = NULL, colnames = c("qwerty", "alder2")), {
        expect_null(output$alder)
    })

    shiny::testServer(function_name, args = list(pickable = c("abc", "ijk")), {
        expect_error(output$alder)
    })

    shiny::testServer(function_name, {
        expect_error(output$alder)
    })

})

test_that("prosent_server", {
    id <- "prosent"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$prosent,
                                  paste0("data/module_", "prosent", "1.rds")
                                  )
    })
})

test_that("snitt_server", {
    id <- "snitt"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$snitt,
                                  paste0("data/module_", "snitt", "1.rds")
                                  )
    })

})

test_that("keep_names_server", {
    id <- "keep_names"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$keep_names,
                                  paste0("data/module_", "keep_names", "1.rds")
                                  )
    })

})
