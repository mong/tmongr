test_that("create_config", {
  expect_equal(
    create_config(dir = "data"),
    paste0(
      "Cannot create data/_tmongr.yml config file: already exists.",
      "(run with force = TRUE if you want to overwrite file)"
    )
  )

  expect_equal(create_config(), "./_tmongr.yml file created: fill it in")
  file.remove("_tmongr.yml")
})

test_that("get_config", {
  expect_equal_to_reference(get_config(dir = "data"), "data/get_config.rds")

  # This will fail if default version of tmongr.yml has been changed.
  expect_equal_to_reference(get_config(), "data/get_config_default.rds")
})
