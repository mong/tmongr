get_data <- function() {
    if (!exists("datasett")) {
        return(tmongr::testdata3)
    } else {
        return(datasett)
    }
}
