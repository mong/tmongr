[![Status](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk/builds)[![Coverage Status](https://img.shields.io/codecov/c/github/SKDE-Analyse/dynamiskTabellverk/master.svg)](https://codecov.io/github/SKDE-Analyse/dynamiskTabellverk?branch=master)

This is a R package to produce *dynamisk tabellverk* web pages. 
The web page is hosted on www.shinyapps.io and can be found here: https://skde.shinyapps.io/tabellverk/ 
The data in itself is not included in this package.


## How to install the package

```
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
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
%let sasfolder = <folder>\dynamiskTabellverk\sas;

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

## Running the app

The R code in `data-raw/regular_app.R` has to be run to publish a new version of the shiny app web page.
