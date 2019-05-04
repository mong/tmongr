# nolint start
app <- ShinyDriver$new("../", seed = 200)
app$snapshotInit("test_app")

app$setInputs(xcol1 = "boomr_sykehus")
Sys.sleep(1)
app$snapshot()
app$setInputs(valg_datasett = "data2")
Sys.sleep(1)
app$snapshot()
app$setInputs(xcol1 = "alder")
Sys.sleep(1)
app$snapshot()
app$setInputs(prosent = TRUE)
app$setInputs(keep_names = TRUE)
Sys.sleep(1)
app$snapshot()
# nolint end
