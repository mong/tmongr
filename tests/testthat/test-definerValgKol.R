context("definer_valg_kol")

test_that("definer_valg_kol returns correct values", {
    col_names <- tolower(colnames(testdata))
    expect_equal_to_reference(definer_valg_kol(col_names, 1), "data/defvalg1.rds")
    expect_equal_to_reference(definer_valg_kol(col_names, 2), "data/defvalg2.rds")
    expect_equal_to_reference(definer_valg_kol(col_names, 3), "data/defvalg3.rds")
    expect_equal_to_reference(definer_valg_kol(col_names, 4), "data/defvalg4.rds")

    col_names2 <- tolower(colnames(testdata2))
    expect_equal_to_reference(definer_valg_kol(col_names2, 1), "data/defvalg1alt.rds")
    expect_equal_to_reference(definer_valg_kol(col_names2, 2), "data/defvalg2alt.rds")
    expect_equal_to_reference(definer_valg_kol(col_names2, 3), "data/defvalg3alt.rds")
    expect_equal_to_reference(definer_valg_kol(col_names2, 4), "data/defvalg4alt.rds")
    expect_null(definer_valg_kol(col_names, 5))
    expect_null(definer_valg_kol(col_names2, 5))
})
