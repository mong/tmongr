



data("testdata")
data("testdata2")


dynamiskTabellverk::launch_application(datasett = testdata2)

launch_application()


devtools::install_github("SKDE-Analyse/dynamiskTabellverk", ref = "shiny_included")
