context("selectInputModules")

test_that("rad1_server", {
    id <- "rad1"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$rad1,
                                  paste0("data/module_", "rad1", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$rad1,
                                  paste0("data/module_", "rad1", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$rad1,
                                  paste0("data/module_", "rad1", "3.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "lmn")

    shiny::testModule(function_name, {
        expect_error(output$rad1)
    })

})

test_that("rad2_server", {
    id <- "rad2"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$rad2,
                                  paste0("data/module_", "rad2", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$rad2,
                                  paste0("data/module_", "rad2", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$rad2,
                                  paste0("data/module_", "rad2", "3.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "lmn")

    shiny::testModule(function_name, {
        expect_error(output$rad2)
    })

})

test_that("kolonner_server", {
    id <- "kolonner"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$kolonner,
                                  paste0("data/module_", "kolonner", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$kolonner,
                                  paste0("data/module_", "kolonner", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$kolonner,
                                  paste0("data/module_", "kolonner", "3.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "lmn")

    shiny::testModule(function_name, {
        expect_error(output$kolonner)
    })

})

test_that("verdi_server", {
    id <- "verdi"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$verdi,
                                  paste0("data/module_", "verdi", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$verdi,
                                  paste0("data/module_", "verdi", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "abc")

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$verdi,
                                  paste0("data/module_", "verdi", "3.rds")
                                  )
    }, pickable = c("abc", "ijk"), default = "lmn")

    shiny::testModule(function_name, {
        expect_error(output$verdi)
    })

})

test_that("bo_server", {
    id <- "bo"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$bo,
                                  paste0("data/module_", "bo", "1.rds")
        )
    })
})

test_that("beh_server", {
    id <- "beh"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$beh,
                                  paste0("data/module_", "beh", "1.rds")
        )
    })
})
