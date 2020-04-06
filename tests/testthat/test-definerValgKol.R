context("definer_valg_kol")

test_that("definer_valg_kol returns correct values", {
    expect_equal_to_reference(definer_valg_kol(testdata, 1), "data/defvalg1.rds")
    expect_equal_to_reference(definer_valg_kol(testdata, 2), "data/defvalg2.rds")
    expect_equal_to_reference(definer_valg_kol(testdata, 3), "data/defvalg3.rds")
    expect_equal_to_reference(definer_valg_kol(testdata, 4), "data/defvalg4.rds")

    expect_equal_to_reference(definer_valg_kol(testdata2, 1), "data/defvalg1alt.rds")
    expect_equal_to_reference(definer_valg_kol(testdata2, 2), "data/defvalg2alt.rds")
    expect_equal_to_reference(definer_valg_kol(testdata2, 3), "data/defvalg3alt.rds")
    expect_equal_to_reference(definer_valg_kol(testdata2, 4), "data/defvalg4alt.rds")
    expect_null(definer_valg_kol(testdata, 5))
    expect_null(definer_valg_kol(testdata2, 5))

})
