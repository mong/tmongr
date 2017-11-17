[![Status](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk/builds)

# How to install the package

```
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
```

## If behind Helse-Nord proxy

```
httr::set_config(httr::use_proxy(url="http://www-proxy.helsenord.no", port=8080))
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
```