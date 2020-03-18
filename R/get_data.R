get_data <- function() {
    if (!exists("datasett")) {
        return(dynamiskTabellverk::testdata3)
    } else {
        return(datasett)
    }
}
