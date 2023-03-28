FROM rocker/r-base:4.2.1

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"
LABEL no.mongr.cd.enable="true"

WORKDIR /app/R

# system libraries and R packages
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl3-gnutls \
    libcurl4-gnutls-dev \
    libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && R -e "install.packages(c('remotes', 'shiny', 'shinythemes', 'shinyWidgets', 'dplyr', 'tidyr', 'stringi', 'lazyeval', 'magrittr', 'rlang', 'yaml', 'knitr', 'markdown'))"

# Install the current local version of tmongr
# hadolint ignore=DL3010
COPY *.tar.gz .
RUN R CMD INSTALL --clean ./*.tar.gz && rm ./*.tar.gz

# Copy the data files
COPY tmongrdata/fag*.csv .

EXPOSE 80

CMD ["R", "-e", "options(shiny.port=80,shiny.host='0.0.0.0'); tmongr::run_app()"]
