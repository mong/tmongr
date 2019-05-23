[![Status](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk/builds)[![Coverage Status](https://img.shields.io/codecov/c/github/SKDE-Analyse/dynamiskTabellverk/master.svg)](https://codecov.io/github/SKDE-Analyse/dynamiskTabellverk?branch=master)

This is a R package to produce *dynamisk tabellverk* web pages. 
The web page is hosted on www.shinyapps.io and can be found here: https://skde.shinyapps.io/tabellverk/ 
The data in itself is not included in this package.


## How to install the package

```
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
```

### If behind Helse-Nord proxy

Include the following in your `~/.Renviron` file before you install the package:

```
http_proxy=http://www-proxy.helsenord.no:8080
https_proxy=http://www-proxy.helsenord.no:8080
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
dynamiskTabellverk::launch_application(datasett = all_data)

# Submit the app to shinyapp.io
dynamiskTabellverk::submit_application(datasett = all_data, HNproxy = TRUE, name = "tabellverk")
```

## Running SAS code

Running the following SAS code will produce the aggregated data used by the shiny app:

```sas
%let sasfolder = \\hn.helsenord.no\RHF\SKDE\Analyse\Prosjekter\ahs_dynamisk_tabellverk\r-pakke\dynamiskTabellverk\sas;

%include "&sasfolder\formater.sas";
%include "&sasfolder\macroer.sas";
%include "&sasfolder\rater_og_aggr.sas";
%include "&sasfolder\tilrettelegging.sas";
%include "&sasfolder\tilretteleggInnbyggerfil.sas";

%include "&sasfolder\avd_tabell.sas";
```
