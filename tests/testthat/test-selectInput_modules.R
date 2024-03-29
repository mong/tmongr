context("selectInputModules")

test_that("rad1_server", {
  id <- "rad1"
  function_name <- get(paste0(id, "_server"))

  shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$rad1[["html"]], "\n")[[1]][1],
      paste0("data/module_", "rad1", "1.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$rad1[["html"]], "\n")[[1]][1],
      paste0("data/module_", "rad1", "2.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "lmn"), {
    expect_equal_to_reference(
      strsplit(output$rad1[["html"]], "\n")[[1]][1],
      paste0("data/module_", "rad1", "3.rds")
    )
  })

  shiny::testServer(function_name, {
    expect_error(output$rad1)
  })
})

test_that("rad2_server", {
  id <- "rad2"
  function_name <- get(paste0(id, "_server"))

  shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$rad2[["html"]], "\n")[[1]][1],
      paste0("data/module_", "rad2", "1.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$rad2[["html"]], "\n")[[1]][1],
      paste0("data/module_", "rad2", "2.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "lmn"), {
    expect_equal_to_reference(
      strsplit(output$rad2[["html"]], "\n")[[1]][1],
      paste0("data/module_", "rad2", "3.rds")
    )
  })

  shiny::testServer(function_name, {
    expect_error(output$rad2)
  })
})

test_that("kolonner_server", {
  id <- "kolonner"
  function_name <- get(paste0(id, "_server"))

  shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$kolonner[["html"]], "\n")[[1]][1],
      paste0("data/module_", "kolonner", "1.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$kolonner[["html"]], "\n")[[1]][1],
      paste0("data/module_", "kolonner", "2.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "lmn"), {
    expect_equal_to_reference(
      strsplit(output$kolonner[["html"]], "\n")[[1]][1],
      paste0("data/module_", "kolonner", "3.rds")
    )
  })

  shiny::testServer(function_name, {
    expect_error(output$kolonner)
  })
})

test_that("verdi_server", {
  id <- "verdi"
  function_name <- get(paste0(id, "_server"))

  shiny::testServer(function_name, args = list(pickable = c("abc", "def", "ijk", "lmn"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$verdi[["html"]], "\n")[[1]][1],
      paste0("data/module_", "verdi", "1.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "abc"), {
    expect_equal_to_reference(
      strsplit(output$verdi[["html"]], "\n")[[1]][1],
      paste0("data/module_", "verdi", "2.rds")
    )
  })

  shiny::testServer(function_name, args = list(pickable = c("abc", "ijk"), default = "lmn"), {
    expect_equal_to_reference(
      strsplit(output$verdi[["html"]], "\n")[[1]][1],
      paste0("data/module_", "verdi", "3.rds")
    )
  })

  shiny::testServer(function_name, {
    expect_error(output$verdi)
  })
})

test_that("bo_server", {
  id <- "bo"
  function_name <- get(paste0(id, "_server"))

  shiny::testServer(function_name, {
    expect_equal_to_reference(
      strsplit(output$bo[["html"]], "\n")[[1]][1],
      paste0("data/module_", "bo", "1.rds")
    )
  })
})

test_that("beh_server", {
  shiny::testServer(beh_server, args = list(pickable = c(
    "Alle" = 1,
    "Helse Nord RHF" = 2,
    "Finnmarkssykehuset HF" = 3,
    "UNN HF" = 4,
    "Nordlandssykehuset HF" = 5,
    "Helgelandssykehuset HF" = 6,
    "Avtalespesialister" = 8,
    "Private sykehus" = 9,
    "Utenfor Helse Nord RHF" = 7
  ), default = 1), {
    expect_equal_to_reference(
      strsplit(output$beh[["html"]], "\n")[[1]][1],
      "data/module_beh1.rds"
    )
  })
})
