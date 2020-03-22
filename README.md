[![Status](https://travis-ci.org/mong/tmongr.svg?branch=master)](https://travis-ci.org/mong/tmongr/builds)
[![Coverage Status](https://img.shields.io/codecov/c/github/mong/tmongr/master.svg)](https://codecov.io/github/mong/tmongr?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/mong/tmongr/badge.svg?branch=master)](https://coveralls.io/github/mong/tmongr?branch=master)

This is a R package to produce *dynamisk tabellverk* web pages. 
The web page is hosted on www.shinyapps.io and can be found here: https://skde.shinyapps.io/tabellverk/ 
The data in itself is not included in this package.


## How to install the package

```
devtools::install_github("mong/tmongr")
```

### If behind proxy

Include the following in your `~/.Renviron` file before you install the package:

```
http_proxy=<proxy-url>:<port>
https_proxy=<proxy-url>:<port>
```

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

The following R code has been run to publish a new version of the shiny app web page:
```r
all_data = list()

all_files = c(
  "data/behandler.rds", 
  "data/justertoverf.rds", 
  "data/fag.rds"
)

all_names = c(
  "Sykehusopphold",
  "Justert for overføringer",
  "Fagområde (sykehusopphold)"
)

all_data <- lapply(all_files, readRDS)

names(all_data) <- all_names

# Run the following line to test the app locally first
tmongr::launch_application(datasett = all_data)

# Submit the app to shinyapp.io
tmongr::submit_application(datasett = all_data, proxy_url = FALSE, name = "tabellverk")
```

