context("test1")

test_that("definer valg er lik", {
  valg_boomr <- c(
    "Opptaksområde Sykehus" = "boomr_sykehus",
    "Opptaksområde HF" = "boomr_HF",
    "Opptaksområde RHF" = "boomr_RHF")
  valg_aar <- c("År" = "aar")
  valg_kontakter <- c("Kontakter"="kontakter")
  valg_rate <- c("Rater"="rate")
  valg_liggetid <- c("Liggedøgn" = "liggetid")
  valg_liggeindex <- c("Liggedøgn pr. pasient" = "liggedognindex")
  valg_drg <- c("DRG-poeng"="drg_poeng")
  valg_drgrate <- c("DRG-poengrater"="drgrate")
  valg_drgindex <- c("DRG-index"="drg_index")
  valg_alder <- c("Alder" = "alder")
  valg_kjonn <- c("Kjønn" = "kjonn")
  valg_behandlingsniva <- c("Behandlingsnivå" = "behandlingsniva")
  valg_DRGtypeHastegrad <- c("DRGtypeHastegrad")
  valg_Behandler <- c("Behandler")
  valg_behsh <- c("Behandlende sykehus" = "behandlende_sykehus")
  valg_behhf <- c("Behandlende HF" = "behandlende_HF")
  valg_behrhf <- c("Behandlende RHF" = "behandlende_RHF")
  valg_hdg <- c("Hoveddiagnosegruppe")
  valg_liggerate <- c("Liggedøgnsrate" = "liggedognrate")
  valg_icd10 <- c("ICD10-kapittel" = "ICD10Kap")

  valg_en <- c(
    valg_boomr,
    valg_aar,
    valg_behandlingsniva,
    valg_icd10,
    valg_Behandler,
    valg_behhf,
    valg_behrhf
  )

  valg_to <- c(
    valg_Behandler,
    valg_behhf,
    valg_behrhf,
    valg_aar,
    valg_behandlingsniva,
    valg_icd10,
    valg_boomr,
    "Tom" = "ingen"
  )

  valg_tre <- c(
    valg_aar,
    valg_behandlingsniva,
    valg_icd10
  )

  expect_equal(valg_en, definerValgKol(testdata,1))
  expect_equal(valg_to, definerValgKol(testdata,2))
  expect_equal(valg_tre, definerValgKol(testdata,3))
})

