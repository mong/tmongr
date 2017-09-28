# How to install the package

```
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
```

## If behind Helse-Nord proxy

```
library(httr)
set_config(use_proxy(url="http://www-proxy.helsenord.no", port=8080))
```
