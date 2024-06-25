FROM rhub/r-minimal:4.5.0

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"
LABEL no.mongr.cd.enable="true"

WORKDIR /app/R

RUN installr -d \
        -t zlib-dev \
        shiny remotes shinythemes shinyWidgets dplyr tidyr stringi lazyeval magrittr rlang yaml knitr markdown

COPY *.tar.gz .
RUN R CMD INSTALL --clean ./*.tar.gz && rm ./*.tar.gz

# Copy the data files
COPY tmongrdata/fag.rds .

EXPOSE 80

CMD ["R", "-e", "options(shiny.port=80,shiny.host='0.0.0.0'); tmongr::run_app()"]
