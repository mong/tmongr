context("checkboxModules")

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testServer(function_name, {
        expect_error(output$aar)
    })

})

test_that("behandlingsniva_server", {
    id <- "behandlingsniva"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$behandlingsniva,
                                  paste0("data/module_", "behandlingsniva", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), colnames = c("qwerty", "behandlingsniva"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$behandlingsniva,
                                  paste0("data/module_", "behandlingsniva", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), colnames = c("qwerty", "behandlingsniva"))

    shiny::testServer(function_name, {
        expect_null(output$behandlingsniva)
    }, pickable = NULL, colnames = c("qwerty", "behandlingsniva1"))

    shiny::testServer(function_name, {
        expect_error(output$behandlingsniva)
    }, pickable = c("abc", "ijk"))

    shiny::testServer(function_name, {
        expect_error(output$behandlingsniva)
    })

})

test_that("hastegrad1_server", {
    id <- "hastegrad1"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$hastegrad1,
                                  paste0("data/module_", "hastegrad1", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), colnames = c("qwerty", "hastegrad"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$hastegrad1,
                                  paste0("data/module_", "hastegrad1", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), colnames = c("qwerty", "hastegrad"))

    shiny::testServer(function_name, {
        expect_null(output$hastegrad1)
    }, pickable = NULL, colnames = c("qwerty", "hastegrad1"))

    shiny::testServer(function_name, {
        expect_error(output$hastegrad1)
    }, pickable = c("abc", "ijk"))

    shiny::testServer(function_name, {
        expect_error(output$hastegrad1)
    })

})

test_that("hastegrad2_server", {
    id <- "hastegrad2"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$hastegrad2,
                                  paste0("data/module_", "hastegrad2", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), colnames = c("qwerty", "drgtypehastegrad"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$hastegrad2,
                                  paste0("data/module_", "hastegrad2", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), colnames = c("qwerty", "drgtypehastegrad"))

    shiny::testServer(function_name, {
        expect_null(output$hastegrad2)
    }, pickable = NULL, colnames = c("qwerty", "drgtypehastegrad1"))

    shiny::testServer(function_name, {
        expect_error(output$hastegrad2)
    }, pickable = c("abc", "ijk"))

    shiny::testServer(function_name, {
        expect_error(output$hastegrad2)
    })

})

test_that("kjonn_server", {
    id <- "kjonn"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$kjonn,
                                  paste0("data/module_", "kjonn", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), colnames = c("qwerty", "kjonn"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$kjonn,
                                  paste0("data/module_", "kjonn", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), colnames = c("qwerty", "kjonn"))

    shiny::testServer(function_name, {
        expect_null(output$kjonn)
    }, pickable = NULL, colnames = c("qwerty", "kjonn1"))

    shiny::testServer(function_name, {
        expect_error(output$kjonn)
    }, pickable = c("abc", "ijk"))

    shiny::testServer(function_name, {
        expect_error(output$kjonn)
    })

})

test_that("alder_server", {
    id <- "alder"
    function_name <- get(paste0(id, "_server"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$alder,
                                  paste0("data/module_", "alder", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), colnames = c("qwerty", "alder"))

    shiny::testServer(function_name, {
        expect_equal_to_reference(output$alder,
                                  paste0("data/module_", "alder", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), colnames = c("qwerty", "alder"))

    shiny::testServer(function_name, {
        expect_null(output$alder)
    }, pickable = NULL, colnames = c("qwerty", "alder2"))

    shiny::testServer(function_name, {
        expect_error(output$alder)
    }, pickable = c("abc", "ijk"))

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
