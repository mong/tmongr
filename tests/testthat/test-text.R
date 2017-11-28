context("text")


test_that("correct text is returned", {
  originalverdier <- list(inpDatasett = testdata,
                          fane = "alle", #?
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
    tab =             verdier$fane,
    rad =             verdier$rad,
    kol =             verdier$kol,
    verdi =           verdier$verdi,
    aar =             verdier$aar,
    bo =              verdier$bo,
    beh =             verdier$beh,
    prosent =         verdier$prosent,
    behandlingsniva = verdier$behandlingsniva,
    alder =           verdier$alder,
    kjonn =           verdier$kjonn,
    hastegrad2 =      verdier$hastegrad2,
    forenkling =      verdier$forenkling)
  expect_equal_to_reference(hjelpetekst, "data/ref_tekst1")

  verdier$aar <- c(2011,2013,2014,2015)
  verdier$fane <- "menisk"
  verdier$prosent <- T
  verdier$forenkling <- T
  verdier$keepNames <- T
  verdier$snitt <- F
  hjelpetekst <- lagHjelpetekst(
    tab =             verdier$fane,
    rad =             verdier$rad,
    kol =             verdier$kol,
    verdi =           verdier$verdi,
    aar =             verdier$aar,
    bo =              verdier$bo,
    beh =             verdier$beh,
    prosent =         verdier$prosent,
    behandlingsniva = verdier$behandlingsniva,
    alder =           verdier$alder,
    kjonn =           verdier$kjonn,
    hastegrad2 =      verdier$hastegrad2,
    forenkling =      verdier$forenkling)
  expect_equal_to_reference(hjelpetekst, "data/ref_tekst2")
  
  verdier <- originalverdier
  for (bohf in c(1,2,3,4,5,6)){
    hjelpetekst <- lagHjelpetekst(
      tab =             verdier$fane,
      rad =             verdier$rad,
      kol =             verdier$kol,
      verdi =           verdier$verdi,
      aar =             verdier$aar,
      bo =              bohf,
      beh =             verdier$beh,
      prosent =         verdier$prosent,
      behandlingsniva = verdier$behandlingsniva,
      alder =           verdier$alder,
      kjonn =           verdier$kjonn,
      hastegrad2 =      verdier$hastegrad2,
      forenkling =      verdier$forenkling)
    expect_equal_to_reference(hjelpetekst, paste("data/ref_tekst_bo",  bohf, sep = ""))
  }

  for (behhf in c(1,2,3,4,5,6,7)){
    hjelpetekst <- lagHjelpetekst(
      tab =             verdier$fane,
      rad =             verdier$rad,
      kol =             verdier$kol,
      verdi =           verdier$verdi,
      aar =             verdier$aar,
      bo =              verdier$bo,
      beh =             behhf,
      prosent =         verdier$prosent,
      behandlingsniva = verdier$behandlingsniva,
      alder =           verdier$alder,
      kjonn =           verdier$kjonn,
      hastegrad2 =      verdier$hastegrad2,
      forenkling =      verdier$forenkling)
    expect_equal_to_reference(hjelpetekst, paste("data/ref_tekst_beh",  behhf, sep = ""))
  }
  
})