# tmongr

<!-- badges: start -->
[![Version](https://img.shields.io/github/v/release/mong/tmongr?sort=semver)](https://github.com/mong/tmongr/releases)
[![R build status](https://github.com/mong/tmongr/workflows/R-CMD-check/badge.svg)](https://github.com/mong/tmongr/actions)
[![Codecov test coverage](https://codecov.io/gh/mong/tmongr/branch/master/graph/badge.svg)](https://codecov.io/gh/mong/tmongr?branch=master)
[![Coveralls test coverage](https://coveralls.io/repos/github/mong/tmongr/badge.svg?branch=master)](https://coveralls.io/github/mong/tmongr?branch=master)
[![GitHub open issues](https://img.shields.io/github/issues/mong/tmongr.svg)](https://github.com/mong/tmongr/issues)
[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![Doc](https://img.shields.io/badge/Doc--grey.svg)](https://mong.github.io/tmongr/)
<!-- badges: end -->

This is a R package to produce *dynamisk tabellverk* web pages. 
The web page is hosted on www.shinyapps.io and can be found here: https://skde.shinyapps.io/tabellverk/ 
The data in itself is not included in this package.

## How to install the package

```R
remotes::install_github("mong/tmongr")
```

### If behind proxy

Include the following in your `~/.Renviron` file before you install the package:

```R
http_proxy=<proxy-url>:<port>
https_proxy=<proxy-url>:<port>
```

## Development

Functions from the `shiny` package that is not on *cran* are used when running tests. Thus, the github version of `shiny` has to be installed to be able to run the tests locally:

```R
remotes::install_github("rstudio/shiny")
```

## Docker

This R package can be added to a docker image together with all _R_ and system dependencies needed to run the the _tmongr_ web application from any docker host.

### Build

Since the _tmongr_ _R_ package is to be installed into the image please make sure to build the source tarball first. From a system command terminal navigate into the _tmongr_-directory and run:
```sh
R CMD build .
```

Then, build the docker image:
```sh
docker build -t tmongr .
```

### Run

To run the docker container from a system command terminal do:
```sh
docker run -p 80:80 tmongr
```

Then, open a web browser window and navigate to [your localhost at port 80](http://127.0.0.1:80) to use the _tmongr_ web application.

To stop the docker container hit ```Ctrl + c``` in the system comman terminal.

## Running SAS code

Running the following SAS code will produce the aggregated data used by the shiny app:

```sas
%let sasfolder = <folder>\tmongr\sas;

%include "&sasfolder\formater.sas";
%include "&sasfolder\macroer.sas";
%include "&sasfolder\rater_og_aggr.sas";
%include "&sasfolder\tilrettelegging.sas";
%include "&sasfolder\tilretteleggInnbyggerfil.sas";

%include "&sasfolder\avd_tabell.sas";
```

The following data files will be produced:

```
<folder>\csv_filer\avd_behandlert19.csv
<folder>\csv_filer\avd_justoverft18.csv
<folder>\csv_filer\avd_fagt18.csv
<folder>\csv_filer\avd_icd10t18.csv
```

## Convert the data to R

The *csv* files produced by *SAS* have to be converted to `utf-8` and `unix` file ending format by *git bash*:

```bash
iconv.exe -f CP1252 -t UTF-8 <filename> | dos2unix.exe > unix_<filename>
```

Then saved as `RDS` files, as follows:

```r
data <- read.table('../csv_filer/unix_avd_behandlert18.csv', 
                  sep = ",", 
                  header=T, 
                  encoding = 'UTF-8', 
                  stringsAsFactors = FALSE)

names(data) <- tolower(names(data))
saveRDS(data, "data/behandler.rds")
```

## Running the app

```r
# read the data
uten_overf <- readRDS("../tabellverk/data/behandler.rds")
med_overf <- readRDS("../tabellverk/data/justertoverf.rds")

# define `niva`
uten_overf$niva <- "Uten overf"
med_overf$niva <- "Med overf"

# bind the data together
datasett <- rbind(uten_overf, med_overf)

# run the app
run_app()
```

