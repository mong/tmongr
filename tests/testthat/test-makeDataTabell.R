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
  expect_null(makeDataTabell(forenkling = T, aar = NULL))
  expect_null(makeDataTabell(forenkling = T, aar = T, rad = "equal", kol = "equal"))
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
  for (fane in c("dogn", "dag", "poli")){
    verdier$fane <- fane
    tmp <- lag_pivot(verdier)
    expect_equal_to_reference(tmp, paste("data/ref_pivot4_", fane, sep = ""))
  }

  # Check the same datasets, but with filter and not with fane
  verdier <- originalverdier
  verdier$behandlingsniva="Døgnopphold"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4_dogn")

  verdier$behandlingsniva="Dagbehandling"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4_dag")
  
  verdier$behandlingsniva="Poliklinikk"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot4_poli")
  
  verdier <- originalverdier
  for (verdi in c("rate", "drgrate", "liggedognrate", "drg_poeng", "drg_index", "liggedognindex")){
    for (boomr in c("boomr_sykehus", "boomr_HF", "boomr_RHF", "Behandler")){
      verdier$verdi <- verdi
      verdier$rad <- boomr
      tmp <- lag_pivot(verdier)
      expect_equal_to_reference(tmp, paste("data/ref_pivot5_", boomr, "_", verdi, sep = ""))
    }
  }

  # Check Behandler alone
  verdier <- originalverdier
  verdier$rad=c("Behandler")
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6a")

  # One too many rad elements
  verdier$rad=c("boomr_HF","behandlende_HF","Behandler")
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6b")

  # One of the rad elements equal kol
  verdier$rad=c("boomr_HF","Behandler")
  verdier$kol = "boomr_HF"
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6c")

  # Calculate percentage horizontal
  verdier$rad=c("boomr_HF", "aar")
  verdier$kol = "ICD10Kap"
  verdier$prosent = T
  tmp <- lag_pivot(verdier)
  expect_equal_to_reference(tmp, "data/ref_pivot6d")
})



