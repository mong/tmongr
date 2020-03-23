FROM rocker/r-base

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"
LABEL no.mongr.cd.enable="true"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev

RUN R -e "install.packages(c('remotes'), repos='https://cloud.r-project.org/')"

# Install master version of tmongr from github, including dependencies
RUN R -e "remotes::install_github('mong/tmongr')"

# Install the current local version of tmongr
COPY *.tar.gz .
RUN R CMD INSTALL --clean *.tar.gz
RUN rm *.tar.gz

# Copy the data files
COPY tabellverk/data/behandler.rds .
COPY tabellverk/data/justertoverf.rds .

EXPOSE 3838

CMD ["R", "-e", "options(shiny.port=3838,shiny.host='0.0.0.0'); tmongr::run_app()"]