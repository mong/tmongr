# tmongr 3.12.0

- Bruk 2023-data

# tmongr 3.11.1

## Oppdatert iframe-resizer

* Oppdater iframe-resizer til 5.1.0 by @arnfinn in https://github.com/mong/tmongr/pull/251
* Oppdater iframe-resizer til 5.1.4 by @arnfinn in https://github.com/mong/tmongr/pull/252

## Oppdatert docker image versjon

* Update rhub/r-minimal Docker tag to v4.5.0 by @renovate in https://github.com/mong/tmongr/pull/248

## Andre oppdateringer

* Update all non-major dependencies by @renovate in https://github.com/mong/tmongr/pull/245
* Update all non-major dependencies by @renovate in https://github.com/mong/tmongr/pull/247
* Update docker/build-push-action action to v6 by @renovate in https://github.com/mong/tmongr/pull/249


# tmongr 3.11.0

- Renamed function `sort` to `sortdataset`, to avoid clash with function from `base R`
- Added `docker-compose` file for development
- Simplify docker image file
- Some general cleaning and updates

# tmongr 3.10.0

* Use one rds-data file instead of two csv files, going from 22 MB to 4 MB. The rds-file is created in the data repository.

# tmongr 3.9.0

* 2022 data
* Running on SAS grid
* Clone specific tag without history in github actions

# tmongr 3.8.0

* Build the docker image on [rhub/r-minimal](https://hub.docker.com/r/rhub/r-minimal), which made the image much smaller. The image is now around 350 MB (100 MB compressed), while the size of the previous one was over 1 GB (over 400 MB compressed) using `rocker/r-base`.
* Skip using [tmongr-base-r](https://github.com/mong/tmongr-base-r) as base image.
* Cache docker image build on github actions.
* Simplify github actions (base them on examples from [r-lib/actions](https://github.com/r-lib/actions/)).
* Use Renovate instead of Dependabot.
* Update action versions.
* Change default branch from `master` to `main`.

# tmongr 3.7.0

* 2021-data

# tmongr 3.6.0

* Reintroduce fagområde with "justert for overføringer", including disclaimer.
* Use RHF-data up to 2020
* Other small fixes

# tmongr 3.5.0

Remove heading. Making it ready for iframe with heading from mongts

# tmongr 3.4.0

Include iframeResizer. Enables automatic resizing of the height and width if the app is inside an iframe.

# tmongr 3.3.3

Simplify app (#106)

# tmongr 3.3.2

Keep the app alive with heartbeats/clock. The websocket connection was lost after 60 sec. before, if the user did not interact with the app.

# tmongr 3.3.1

Docker: define `WORKDIR` to fix `hadolint` error.

# tmongr 3.3.0

Make the app ready for Elastic Beanstalk

# tmongr 3.2.0

- Activated github action and deactivated Travis CI
- Polish of code etc.

# tmongr 3.1.0

### More robust sorting ([#83](https://github.com/mong/tmongr/pull/83))

* mv sorting code from `pivot.R` to separate `R` file
* Use `sort.rds` data to sort table, based on order in `sas` formats, instead of hard coded `gsub`.

### Removed one test of `get_data()`

It defined a global variable `datasett`, which stayed in `R` session after tests. Broke the app and tests afterwards.

# tmongr 3.0.3

Use external docker deploy script

# tmongr 3.0.2

- Deploy master commits to `hnskde/tmongr:test`
- Deploy tags/releases to `hnskde/tmongr:latest`

# tmongr 3.0.1

* Only deploy tags

# tmongr 3.0.0

## Major changes

* Changed name from `dynamiskTabellverk` to `tmongr`, to be part of the `mongr` family.
* Moved all `R` code from `inst/app` to `R` directory.
* Run app with `run_app()` function

## Minor features

* Modularize shiny functions
* Docker
* Removed unused code
* Lint code
* Travis CI setup updates
  * regular `R` setup
  * build and deploy docker image

# dynamiskTabellverk 2.8.1

* Added hover text on ui elements ([#53](https://github.com/mong/tmongr/pull/53))

# dynamiskTabellverk 2.8.0

* Use one dataset ([#51](https://github.com/mong/tmongr/pull/51))
  - The app will no longer accept a list with several data sets.
  - One dataset will contain "niva" value, which is either "justert for overføringer" or not.
  - Switch button to change between overføringer or not.
  - All choices will be kept even if changing source.

# dynamiskTabellverk 2.7.1

* Revert commit that rewrote `definerValgKol` in `2.7.0`. The drop down menus were broken.

# dynamiskTabellverk 2.7.0

* Do not longer include fagomr. data in app.
* Rewrite of `definerValgKol`, depending more on the data.

# dynamiskTabellverk 2.6.3

* Skip proxy in `submit_application` all together

# dynamiskTabellverk 2.6.2

* First `tilrettelegging 19` version submitted to `shinyapps.io`.

# dynamiskTabellverk 2.6.1

* Default `proxy_url` argument in `submit_application` set to `FALSE` instead of `NULL`
* `Travis` updates

# dynamiskTabellverk 2.6.0

* *Tilrettelegging 2019* (new delivery from NPR)

# dynamiskTabellverk 2.5.2

* Update `README`

# dynamiskTabellverk 2.5.1

* `lintr` and `travis` updates

# dynamiskTabellverk 2.5.0

* Mainly `Travis CI` and `SAS` changes

# dynamiskTabellverk 2.4.0

## Minor Features

- Included the SAS code. Copied directly from [06c88d](https://gitlab.com/skde/tabellverk/commit/06c88d91f3a41afda998fd29746208d0d752e39d) of [gitlab.com/skde/tabellverk](https://gitlab.com/skde/tabellverk) (private repository).

# dynamiskTabellverk 2.3.0

## Minor Features

- Reintroduced "Hastegrad"
- More tests
- Added ".rds" ending to all test data sets

# dynamiskTabellverk 2.2.0

## Minor Features

- Send less values to makeDataTabell by sending `verdier` directly (packed with 16 values)
- Use `unique()` instead of hard coded choices. For instance, if the dataset consist of data from 2014-2016,  then these years will be pickable, but not other years. 
roxygen2::roxygenise()
# dynamiskTabellverk 2.1.3

## Bug fixes

- Use lower case column names in data, to make it easier to merge new and old data sets.

# dynamiskTabellverk 2.1.2

## Minor Features

- Included year 2017.

# dynamiskTabellverk 2.1.1

## Bug fixes

- Started with a changelog (`NEWS.md`)
- Better autogenerated text (see [PR #19](https://github.com/mong/tmongr/pull/19))
- *Travis CI* will roxygenise the package before making the documentation
- Better documentation

# dynamiskTabellverk 2.1.0

## Major Features

- Possible to tabulate data on fagområde episode and fag avtalespesialist
- Use avdelingsopphold instead of sykehusopphold

## Minor Features

- Avtalespesialist contacts are treated as outpatients
- Possible to define shiny account when submitting application (default = "skde")
- Extended and polished the information tab
- Better automatic text section
- Possible to pick only avtalespesialist or only private sykehus as treater.

# dynamiskTabellverk 2.0.4

- Fixed the create_appDir function (see [PR #12](https://github.com/mong/tmongr/pull/12))
- Helse Nord proxy in submit_application: HNproxy (see [PR #13](https://github.com/mong/tmongr/pull/13))

# dynamiskTabellverk 2.0.3

- Fixed the deploy function (see [PR #11](https://github.com/mong/tmongr/pull/11))

# dynamiskTabellverk 2.0.2

- Possible to specify `appName` in `submit_application`

# dynamiskTabellverk 2.0.1

- *Travis CI* will make the documentation

# dynamiskTabellverk 2.0.0

- Included the `shiny` code from the (private) [gitlab](https://gitlab.com/skde/tabellverk) repository.

