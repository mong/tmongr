FROM hnskde/tmongr-base-r

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"
LABEL no.mongr.cd.enable="true"

# Install the current local version of tmongr
COPY *.tar.gz .
RUN R CMD INSTALL --clean *.tar.gz
RUN rm *.tar.gz

# Copy the data files
COPY tabellverk/data/behandler.rds .
COPY tabellverk/data/justertoverf.rds .

EXPOSE 80

CMD ["R", "-e", "options(shiny.port=3838,shiny.host='0.0.0.0'); tmongr::run_app()"]
