context("makeDataTabell")


test_that("makeDataTable returns NULL and error", {
  expect_error(makeDataTabell())
  expect_error(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_null(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_null(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_error(makeDataTabell(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
  expect_null(makeDataTabell(forenkling = NULL))
})

test_that("makeDataTabell returns a pivot table", {

  tmp <- makeDataTabell(inpDatasett = testdata,
                        fane = "tmp", #?
                        rad="boomr_HF",
                        kol="behandlende_HF",
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
  expect_equal_to_reference(tmp, "data/ref_pivot1")

})
