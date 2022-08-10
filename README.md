# tmongr

<!-- badges: start -->
[![Version](https://img.shields.io/github/v/release/mong/tmongr?sort=semver)](https://github.com/mong/tmongr/releases)
[![R build status](https://github.com/mong/tmongr/workflows/R-CMD-check/badge.svg)](https://github.com/mong/tmongr/actions)
[![Codecov test coverage](https://codecov.io/gh/mong/tmongr/branch/main/graph/badge.svg)](https://codecov.io/gh/mong/tmongr?branch=main)
[![Coveralls test coverage](https://coveralls.io/repos/github/mong/tmongr/badge.svg?branch=main)](https://coveralls.io/github/mong/tmongr?branch=main)
[![GitHub open issues](https://img.shields.io/github/issues/mong/tmongr.svg)](https://github.com/mong/tmongr/issues)
[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![Doc](https://img.shields.io/badge/Doc--grey.svg)](https://mong.github.io/tmongr/)
<!-- badges: end -->

This is a R package to produce *dynamisk tabellverk* web pages. 
The web page can be found here: https://www.skde.no/pasientstrommer/ 
The data in itself is not included in this package.

## How to install the package

```R
remotes::install_github("mong/tmongr")
```

## Running SAS code

Running the following SAS code will produce the aggregated data used by the shiny app:

```sas
%let sasmappe = <folder>\tmongr\sas;
%let filbane = <another_folder>\felleskoder\master;

%let prosjekt_filbane = <folder>;

/* This will run the code */
%include "&sasmappe\avd_tabell.sas";
```

The following data files will be produced:

```sas
&prosjekt_filbane\tmongrdata\fag.csv
&prosjekt_filbane\tmongrdata\fag2.csv
```

## Running the app

Run the R-code in `data-raw/test-run.R` to run the app locally with newly created data.

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
