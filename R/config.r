#' Configuration
#'
#' Creates a configuration file based on the default
#' shipped with tmongr package.
#'
#' @param dir Folder to put config file
#' @param force Overwrite current config file
#'
#' @export
create_config <- function(dir = ".", force = FALSE) {
  ref_file <- system.file("tmongr.yml", package = "tmongr")
  new_file <- paste(dir, "_tmongr.yml", sep = "/")
  if (!file.exists(new_file) | force) {
    file.copy(ref_file, to = new_file)
    return(paste0(new_file, " file created: fill it in"))
  } else {
    return(paste0(
      "Cannot create ", new_file, " config file: already exists.",
      "(run with force = TRUE if you want to overwrite file)"
    ))
  }
}

#' Retrieve Config
#'
#' Retrieves config file.
#'
#' @param dir Folder location of _tmongr.yml file
#'
#' @export
get_config <- function(dir = ".") {
  config_file <- paste(dir, "_tmongr.yml", sep = "/")
  if (!file.exists(config_file)) {
    # Use the default if _tmongr.yml does not exist
    config_file <- system.file("tmongr.yml", package = "tmongr")
  }
  config <- yaml::read_yaml(config_file)
  return(config)
}
