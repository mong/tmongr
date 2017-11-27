context("makeDataTabell")

lag_pivot <- function(verdier){
  pivot <- makeDataTabell(inpDatasett = verdier$inpDatasett,
                          fane = verdier$fane,
                          rad = verdier$rad,
                          kol = verdier$kol,
                          verdi = verdier$verdi,
                          aar = verdier$aar,
                          bo = verdier$bo,
                          beh = verdier$beh,
                          behandlingsniva = verdier$behandlingsniva,
                          alder = verdier$alder,
                          kjonn = verdier$kjonn,
                          hastegrad2 = verdier$hastegrad2,
                          prosent = verdier$prosent,
                          forenkling = verdier$forenkling,
                          keepNames = verdier$keepNames,
                          snitt = verdier$snitt,
                          hdg = verdier$hdg,
                          icd10 = verdier$icd10
  )
  return(pivot)
}

test_that("makeDataTable returns NULL and error", {
  expect_error(makeDataTabell())
  expect_error(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_null(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_null(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_error(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_null(makeDataTabell(forenkling = NULL))
})

test_that("makeDataTabell returns a pivot table", {
  
  verdier <- list(inpDatasett = testdata,
                  fane = "tmp", #?
                  rad=c("boomr_HF","behandlende_HF"),
                  kol= "aar",
                  verdi="kontakter",
                  aar=2016,
                  bo=2,
                  beh=1,
                  behandlingsniva="Poliklinikk",
                  alder="tmp", #?
                  kjonn="tmp", #?
                  hastegrad2="tmp", #?
                  prosent=F,
                  forenkling=F,
                  keepNames=F,
                  snitt=T,
                  hdg="Alle",
                  icd10="Alle")
  
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot1")
  
  verdier$bo <- 1
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2")
  
  verdier$beh <- 2
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot3")
  
  verdier$fane <- "dogn"
  verdier$behandlingsniva="Døgnopphold"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4")

  verdier$prosent <- T
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5")
  
  verdier$verdi <- "rate"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6")

  verdier$verdi <- "drgrate"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot7")
  
  verdier$verdi <- "liggedognrate"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot8")

  verdier$verdi <- "drg_poeng"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot9")

  verdier$verdi <- "drg_index"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot10")

  verdier$verdi <- "liggedognindex"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot11")
})
