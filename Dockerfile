FROM hnskde/tmongr-base-r:1.0.1

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"
LABEL no.mongr.cd.enable="true"

WORKDIR /app/R

# Install the current local version of tmongr
# hadolint ignore=DL3010
COPY *.tar.gz .
RUN R CMD INSTALL --clean ./*.tar.gz
RUN rm ./*.tar.gz

# Copy the data files
COPY tabellverk/data/behandler.rds .
COPY tabellverk/data/justertoverf.rds .

EXPOSE 80

CMD ["R", "-e", "options(shiny.port=80,shiny.host='0.0.0.0'); tmongr::run_app()"]
