context("makeDataTabell")

lag_pivot <- function(verdier) {
  pivot <- makeDataTabell(verdier$inpDatasett,
                          verdier$fane,
                          verdier,
                          verdier$keep_names,
                          verdier$snitt
  )
  return(pivot)
}

test_that("makeDataTable returns NULL and error", {
  expect_error(makeDataTabell())
  # Error if "verdier" is not defined
  expect_error(makeDataTabell(NULL, NULL))
  expect_null(makeDataTabell(NULL, NULL, NULL))
  expect_null(makeDataTabell(NULL, NULL, NULL, NULL))
  # Too many arguments
  expect_error(makeDataTabell(NULL, NULL, NULL, NULL, NULL, NULL))
  expect_null(makeDataTabell(verdier = NULL))
})

test_that("makeDataTabell returns a pivot table", {

  originalverdier <- list(inpDatasett = testdata,
                  fane = "tmp", #?
                  rader = c("boomr_hf", "behandlende_hf_hn"),
                  kolonner = "aar",
                  verdi = "kontakter",
                  aar = 2016,
                  bo = 2,
                  beh = 1,
                  behandlingsniva = c("Døgnopphold",
                                      "Dagbehandling",
                                      "Poliklinikk",
                                      "Avtalespesialist"),
                  alder = "tmp", #?
                  kjonn = "tmp", #?
                  hastegrad2 = "tmp", #?
                  prosent = F,
                  keep_names = F,
                  snitt = T)

  verdier <- originalverdier

  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot1.rds")

  verdier$bo <- 1
  verdier$beh <- 2
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2a.rds")

  verdier$bo <- 3
  verdier$beh <- 3
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2b.rds")

  verdier$bo <- 4
  verdier$beh <- 4
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2c.rds")

  verdier$bo <- 5
  verdier$beh <- 5
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2d.rds")

  verdier$bo <- 6
  verdier$beh <- 6
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2e.rds")

  verdier$bo <- 1
  verdier$beh <- 7
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2f.rds")

  verdier <- originalverdier
  verdier$prosent <- T
  verdier$keep_names <- T
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot3.rds")

  verdier <- originalverdier
  for (fane in c("dogn", "dag", "poli")) {
    verdier$fane <- fane
    tmp <- lag_pivot(verdier)
    expect_equal_to_reference(tmp, paste0("data/ref_pivot4_", fane, ".rds"))
  }

  # Check the same datasets, but with filter and not with fane
  verdier <- originalverdier
  verdier$behandlingsniva <- "Døgnopphold"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4_dogn.rds")

  verdier$behandlingsniva <- "Dagbehandling"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4_dag.rds")

  verdier$behandlingsniva <- "Poliklinikk"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4_poli.rds")

  verdier <- originalverdier
  for (verdi in c("rate", "drgrate", "liggedognrate", "drg_poeng", "drg_index", "liggedognindex")) {
    for (boomr in c("boomr_sykehus", "boomr_hf", "boomr_rhf", "behandler")) {
      verdier$verdi <- verdi
      verdier$rader <- boomr
      tmp <- lag_pivot(verdier)
      expect_equal_to_reference(tmp, paste0("data/ref_pivot5_", boomr, "_", verdi, ".rds"))
    }
  }

  # Check Behandler alone
  verdier <- originalverdier
  verdier$rader <- c("behandler")
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6a.rds")

  # One too many rad elements
  verdier$rader <- c("boomr_hf", "behandlende_hf_hn", "behandler")
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6b.rds")

  # One of the rad elements equal kol
  verdier$rader <- c("boomr_hf", "behandler")
  verdier$kolonner <- "boomr_hf"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6c.rds")

  # Check dataset with more variables
  verdier <- originalverdier
  verdier$inpDatasett <- testdata2
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot7.rds")

  # Check "aar" %in% kol
  verdier <- originalverdier
  verdier$rader <- c("aar", "behandlende_hf_hn")
  verdier$kolonner <- c("aar")
  verdier$aar <- c(2014, 2015, 2016)
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot8.rds")
  })
