% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/text.R
\name{lag_hjelpetekst}
\alias{lag_hjelpetekst}
\title{Make caption above the table}
\usage{
lag_hjelpetekst(
  tab,
  rad,
  kol,
  verdi,
  aar,
  bo,
  beh,
  prosent,
  behandlingsniva,
  alder,
  kjonn,
  hastegrad2,
  overskrift = TRUE
)
}
\arguments{
\item{tab}{The active tab}

\item{rad}{What to tabulate on the row}

\item{kol}{What to tabulate on the column}

\item{verdi}{The value that is going to be tabulated}

\item{aar}{The years to be tabulated}

\item{bo}{Living area. Possible values 1:6}

\item{beh}{Hospital Health Trust. Possible values 1:7}

\item{prosent}{Show percentage}

\item{behandlingsniva}{Type of contact (admissions, outpatient consultations or day patient treatments)}

\item{alder}{Age group}

\item{kjonn}{Gender}

\item{hastegrad2}{Degree of urgency}
}
\value{
Tekst Some text that describe the selection made by the user.
}
\description{
Make caption above the table
}
