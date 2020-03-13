FROM rocker/r-base

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev

RUN R -e "install.packages(c('remotes'), repos='https://cloud.r-project.org/')"

RUN R -e "remotes::install_github('rstudio/htmltools')"
RUN R -e "remotes::install_github('SKDE-Analyse/dynamiskTabellverk')"



CMD ["R"]
