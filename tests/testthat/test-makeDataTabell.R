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
  
  originalverdier <- list(inpDatasett = testdata,
                  fane = "tmp", #?
                  rad=c("boomr_HF","behandlende_HF"),
                  kol= "aar",
                  verdi="kontakter",
                  aar=2016,
                  bo=2,
                  beh=1,
                  behandlingsniva = c("Døgnopphold","Dagbehandling","Poliklinikk","Avtalespesialist"), #"Poliklinikk",
                  alder="tmp", #?
                  kjonn="tmp", #?
                  hastegrad2="tmp", #?
                  prosent=F,
                  forenkling=F,
                  keepNames=F,
                  snitt=T,
                  hdg="Alle",
                  icd10="Alle")
  
  verdier <- originalverdier
  
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot1")
  
  verdier$bo <- 1
  verdier$beh <- 2
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2a")
  
  verdier$bo <- 3
  verdier$beh <- 3
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2b")

  verdier$bo <- 4
  verdier$beh <- 4
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2c")

  verdier$bo <- 5
  verdier$beh <- 5
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2d")

  verdier$bo <- 6
  verdier$beh <- 6
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2e")

  verdier$bo <- 1
  verdier$beh <- 7
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot2f")

  verdier <- originalverdier
  verdier$prosent <- T
  verdier$keepNames <- T
  verdier$forenkling <- T
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot3")
  
  verdier <- originalverdier
  verdier$fane <- "dogn"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4a")

  verdier <- originalverdier
  verdier$behandlingsniva="Døgnopphold"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4b")

  verdier$verdi <- "rate"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5a")

  verdier$verdi <- "drgrate"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5b")
  
  verdier$verdi <- "liggedognrate"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5c")

  verdier$verdi <- "drg_poeng"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5d")

  verdier$verdi <- "drg_index"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5e")

  verdier$verdi <- "liggedognindex"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot5f")
  
  verdier <- originalverdier
  
})

test_that("text is returned", {
  originalverdier <- list(inpDatasett = testdata,
                          fane = "tmp", #?
                          rad=c("boomr_HF","behandlende_HF"),
                          kol= "aar",
                          verdi="kontakter",
                          aar=2016,
                          bo=2,
                          beh=1,
                          behandlingsniva = c("Døgnopphold","Dagbehandling","Poliklinikk","Avtalespesialist"), #"Poliklinikk",
                          alder="tmp", #?
                          kjonn="tmp", #?
                          hastegrad2="tmp", #?
                          prosent=F,
                          forenkling=F,
                          keepNames=F,
                          snitt=T,
                          hdg="Alle",
                          icd10="Alle")
  verdier <- originalverdier
  hjelpetekst <- lagHjelpetekst(
    verdier$fane, 
    verdier$rader, 
    verdier$kolonner, 
    verdier$verdi, 
    verdier$aar, 
    verdier$bo, 
    verdier$beh, 
    verdier$prosent, 
    verdier$behandlingsniva, 
    verdier$alder, 
    verdier$kjonn, 
    verdier$hastegrad2, 
    verdier$forenkling)
  
  expect_equal_to_reference(hjelpetekst, "data/ref_tekst1")
  
})
