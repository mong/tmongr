test_that("app_ui", {
  ref_chr <- as.character(purrr::flatten(app_ui()))[4]
  expect_true(grepl("www/hn.png", ref_chr, fixed = TRUE))
  expect_true(grepl("color: #003A8C", ref_chr, fixed = TRUE))
  expect_true(grepl("color: #808080", ref_chr, fixed = TRUE))
  expect_true(grepl("max-width: 1200px", ref_chr, fixed = TRUE))
  expect_true(grepl("Pasientstrømmer, Helse Nord RHF", ref_chr, fixed = TRUE))
  expect_true(grepl("just_overf", ref_chr, fixed = TRUE))
  expect_true(grepl("behandlingsniva", ref_chr, fixed = TRUE))
  expect_true(grepl("hastegrad1", ref_chr, fixed = TRUE))
  expect_true(grepl("keep_names", ref_chr, fixed = TRUE))
  expect_true(grepl("Alle kontakter", ref_chr, fixed = TRUE))
  expect_true(grepl("Poliklinikk", ref_chr, fixed = TRUE))
  expect_true(grepl("alder", ref_chr, fixed = TRUE))
  expect_true(grepl("hastegrad2", ref_chr, fixed = TRUE))
  expect_true(grepl("aar", ref_chr, fixed = TRUE))
  expect_true(grepl("shiny-html-output", ref_chr, fixed = TRUE))
  expect_true(grepl("Informasjon", ref_chr, fixed = TRUE))
  expect_true(grepl("Dataene som presenteres er fra Norsk pasientregister", ref_chr, fixed = TRUE))
  expect_true(grepl("Ratene er beregnet ut i fra befolkningstall fra SSB", ref_chr, fixed = TRUE))
})

test_that("run_app", {
  expect_equal(class(run_app()), "shiny.appobj")
  expect_equal(class(run_app()$httpHandler), "function")
  expect_equal(class(run_app()$options), "list")
  expect_equal(class(run_app()$serverFuncSource), "function")
})
