context("unit")

test_that("filter_bo is correct", {
    for (bo in c(1, 2, 3, 4, 5, 6)) {
        expect_equal_to_reference(filter_bo(testdata, bo), paste0("data/unit_bo_", bo, ".rds"))
    }
    for (i in 7:24) expect_null(filter_bo(testdata, i))
    expect_null(filter_bo(testdata, "random_string"))
})

test_that("filter_beh is correct", {
    for (beh in c(1, 2, 3, 4, 5, 6, 7, 8, 9)) {
        expect_equal_to_reference(filter_beh(testdata, beh), paste0("data/unit_beh_", beh, ".rds"))
    }
    for (i in 10:24) expect_null(filter_beh(testdata, i))
    expect_null(filter_beh(testdata, "random_string"))
})

test_that("filter_aar is correct", {
    k <- 0
    for (aar in list("2013", list("2011", "2016"), list("2010", "2011", "2016"))) {
        k <- k + 1
        expect_equal_to_reference(filter_aar(testdata, filter = aar), paste0("data/unit_aar_", k, ".rds"))
    }
    expect_equal(nrow(filter_aar(testdata, "2010")), 0)
    expect_equal(filter_aar(testdata, list("2011", "2016")), filter_aar(testdata, filter = c("2010", "2011", "2016")))
})

test_that("filter_behandlingsniva is correct", {
    k <- 0
    for (behniva in list("Døgnopphold", "Dagbehandling", "Poliklinikk", "Avtalespesialist",
                    list("Døgnopphold", "Dagbehandling", "Poliklinikk", "Avtalespesialist"),
                    list("Dagbehandling", "Poliklinikk", "Avtalespesialist"),
                    list("Døgnopphold", "Dagbehandling", "Poliklinikk"))) {
        k <- k + 1
        expect_equal_to_reference(filter_behandlingsniva(testdata, behniva),
                                  paste0("data/unit_behniva_", k, ".rds"))
        expect_equal_to_reference(filter_behandlingsniva(testdata2, behniva),
                                  paste0("data/unit_behnivaalt_", k, ".rds"))
    }
    df <- data.frame(File = character(), User = character(), stringsAsFactors = FALSE)
    expect_equal(filter_behandlingsniva(df, "random"), df)
})

test_that("filter_hastegrad2 is correct", {
    k <- 0
    for (hastegrad in list("Planlagt medisin", "Akutt medisin", "Planlagt kirurgi", "Akutt kirurgi", "Ukjent",
                      list("Planlagt medisin", "Akutt medisin"),
                      list("Planlagt kirurgi", "Akutt kirurgi"))) {
        k <- k + 1
        expect_equal_to_reference(filter_hastegrad2(testdata2, hastegrad), paste0("data/unit_hastegrad2_", k, ".rds"))
        expect_equal(filter_hastegrad2(testdata, hastegrad), testdata)
    }
    expect_equal(nrow(filter_hastegrad2(testdata2, "random")), 0)
})

test_that("filter_alder is correct", {
    k <- 0
    for (alder in list("0 - 17 \u00E5r", "18 - 49 \u00E5r", "50 - 74 \u00E5r", "75 \u00E5r og over",
                  list("50 - 74 \u00E5r", "75 \u00E5r og over"),
                  list("0 - 17 \u00E5r", "18 - 49 \u00E5r"))) {
        k <- k + 1
        expect_equal_to_reference(filter_alder(testdata2, alder), paste0("data/unit_alder_", k, ".rds"))
    }
    expect_equal(filter_alder(testdata2, c("a", "b", "c", "d")), testdata2)
    expect_equal(filter_alder(testdata, c("a")), testdata)
})

test_that("filter_kjonn is correct", {
    for (kjonn in list("Kvinner", "Menn")) {
        expect_equal_to_reference(filter_kjonn(testdata2, kjonn), paste0("data/unit_kjonn_", kjonn, ".rds"))
        expect_equal(filter_kjonn(testdata, kjonn), testdata)
    }
    expect_equal(nrow(filter_kjonn(testdata2, "random")), 0)
})
