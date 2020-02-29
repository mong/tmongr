context("unit")

test_that("filterBo is correct", {
    for (bo in c(1, 2, 3, 4, 5, 6)) {
        expect_equal_to_reference(filterBo(testdata, bo), paste0("data/unit_bo_", bo, ".rds"))
    }
    for (i in 7:24) expect_null(filterBo(testdata, i))
    expect_null(filterBo(testdata, "random_string"))
})

test_that("filterBeh is correct", {
    for (beh in c(1, 2, 3, 4, 5, 6, 7, 8, 9)) {
        expect_equal_to_reference(filterBeh(testdata, beh), paste0("data/unit_beh_", beh, ".rds"))
    }
    for (i in 10:24) expect_null(filterBeh(testdata, i))
    expect_null(filterBeh(testdata, "random_string"))
})

test_that("filterAar is correct", {
    k <- 0
    for (aar in list("2013", list("2011", "2016"), list("2010", "2011", "2016"))) {
        k <- k + 1
        expect_equal_to_reference(filterAar(testdata, filter = aar), paste0("data/unit_aar_", k, ".rds"))
    }
    expect_equal(nrow(filterAar(testdata, "2010")), 0)
    expect_equal(filterAar(testdata, list("2011", "2016")), filterAar(testdata, filter = c("2010", "2011", "2016")))
})

test_that("filterBehandlingsniva is correct", {
    k <- 0
    for (behniva in list("Døgnopphold", "Dagbehandling", "Poliklinikk", "Avtalespesialist",
                    list("Døgnopphold", "Dagbehandling", "Poliklinikk", "Avtalespesialist"),
                    list("Dagbehandling", "Poliklinikk", "Avtalespesialist"),
                    list("Døgnopphold", "Dagbehandling", "Poliklinikk"))) {
        k <- k + 1
        expect_equal_to_reference(filterBehandlingsniva(testdata, behniva), paste0("data/unit_behniva_", k, ".rds"))
        expect_equal_to_reference(filterBehandlingsniva(testdata2, behniva), paste0("data/unit_behnivaalt_", k, ".rds"))
    }
    df <- data.frame(File = character(), User = character(), stringsAsFactors = FALSE)
    expect_equal(filterBehandlingsniva(df, "random"), df)
})

test_that("filterHastegrad2 is correct", {
    k <- 0
    for (hastegrad in list("Planlagt medisin", "Akutt medisin", "Planlagt kirurgi", "Akutt kirurgi", "Ukjent",
                      list("Planlagt medisin", "Akutt medisin"),
                      list("Planlagt kirurgi", "Akutt kirurgi"))) {
        k <- k + 1
        expect_equal_to_reference(filterHastegrad2(testdata2, hastegrad), paste0("data/unit_hastegrad2_", k, ".rds"))
        expect_equal(filterHastegrad2(testdata, hastegrad), testdata)
    }
    expect_equal(nrow(filterHastegrad2(testdata2, "random")), 0)
})

test_that("filterAlder is correct", {
    k <- 0
    for (alder in list("0 - 17 \u00E5r", "18 - 49 \u00E5r", "50 - 74 \u00E5r", "75 \u00E5r og over",
                  list("50 - 74 \u00E5r", "75 \u00E5r og over"),
                  list("0 - 17 \u00E5r", "18 - 49 \u00E5r"))) {
        k <- k + 1
        expect_equal_to_reference(filterAlder(testdata2, alder), paste0("data/unit_alder_", k, ".rds"))
    }
    expect_equal(filterAlder(testdata2, c("a", "b", "c", "d")), testdata2)
    expect_equal(filterAlder(testdata, c("a")), testdata)
})

test_that("filterKjonn is correct", {
    for (kjonn in list("Kvinner", "Menn")) {
        expect_equal_to_reference(filterKjonn(testdata2, kjonn), paste0("data/unit_kjonn_", kjonn, ".rds"))
        expect_equal(filterKjonn(testdata, kjonn), testdata)
    }
    expect_equal(nrow(filterKjonn(testdata2, "random")), 0)
})
