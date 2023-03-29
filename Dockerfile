FROM rhub/r-minimal:4.2.3 as builder

LABEL maintainer "Arnfinn Hykkerud Steindal <arnfinn.steindal@gmail.com>"
LABEL no.mongr.cd.enable="true"

WORKDIR /app/R

# system libraries
RUN apk add --no-cache --update-cache \
        --repository http://nl.alpinelinux.org/alpine/v3.11/main \
        autoconf=2.69-r2 \
        automake=1.16.1-r0

FROM builder as packages

RUN installr -d \
        -t "libsodium-dev curl-dev linux-headers autoconf automake" \
        -a libsodium \
        shiny remotes shinythemes shinyWidgets dplyr tidyr stringi lazyeval magrittr rlang yaml knitr markdown

COPY *.tar.gz .
RUN R CMD INSTALL --clean ./*.tar.gz && rm ./*.tar.gz

FROM packages

# Copy the data files
COPY tmongrdata/fag*.csv .

EXPOSE 80

CMD ["R", "-e", "options(shiny.port=80,shiny.host='0.0.0.0'); tmongr::run_app()"]
