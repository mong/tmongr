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

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("aar_server", {
    id <- "aar"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$aar,
                                  paste0("data/module_", "aar", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$aar)
    })

})

test_that("alder_server", {
    id <- "alder"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$alder,
                                  paste0("data/module_", "alder", "1.rds")
                                  )
    }, pickable = c("abc", "def", "ijk", "lmn"), colnames = c("qwerty", "alder"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$alder,
                                  paste0("data/module_", "alder", "2.rds")
                                  )
    }, pickable = c("abc", "ijk"), colnames = c("qwerty", "alder"))

    shiny::testModule(function_name, {
        expect_null(output$alder)
    }, pickable = NULL, colnames = c("qwerty", "alder2"))

    shiny::testModule(function_name, {
        expect_error(output$alder)
    }, pickable = c("abc", "ijk"))

    shiny::testModule(function_name, {
        expect_error(output$alder)
    })

})

test_that("prosent_server", {
    id <- "prosent"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$prosent,
                                  paste0("data/module_", "prosent", "1.rds")
                                  )
    })

})

test_that("forenkling_server", {
    id <- "forenkling"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$forenkling,
                                  paste0("data/module_", "forenkling", "1.rds")
                                  )
    }, colnames = c("behandlende_HF", "behandler"))

    shiny::testModule(function_name, {
        expect_null(output$forenkling)
    }, colnames = c("tmp", "behandler"))

    shiny::testModule(function_name, {
        expect_error(output$forenkling)
    })

})

test_that("snitt_server", {
    id <- "snitt"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$snitt,
                                  paste0("data/module_", "snitt", "1.rds")
                                  )
    })

})

test_that("keep_names_server", {
    id <- "keep_names"
    function_name <- get(paste0(id, "_server"))

    shiny::testModule(function_name, {
        expect_equal_to_reference(output$keep_names,
                                  paste0("data/module_", "keep_names", "1.rds")
                                  )
    })

})


