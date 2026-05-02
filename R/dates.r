## Quelques fonctions de préparation des dates

#' Date en trimestriel
#'
#' Transforme une date dans le format trimestriel standard (revue de l'OFCE)
#' 2025-01-01 -> T1 2025
#' 2025-04 -> T2 2025
#'
#' @param date la date
#'
#' @returns une chaine de caractères
#'
#' @export
#' @examples
#' date_trim("2025-10-01")
date_trim <- function(date) {
  stringr::str_c("T", lubridate::quarter(date), " ", lubridate::year(date))
}

#' Date en mois
#'
#' Transforme une date dans le format mensuel standard (revue de l'OFCE)
#' 2025-01-01 -> janvier 2025
#' 2025-04 -> avril 2025
#'
#' @param date la date
#'
#' @returns une chaine de caractères
#'
#' @export
#' @examples
#' date_mois("2025-10-01")
date_mois <- function(date) {
  stringr::str_c(
    lubridate::month(date, label = TRUE, abbr = FALSE),
    " ",
    lubridate::year(date)
  )
}

#' Date en jour
#'
#' Transforme une date dans le format
#' 2025-01-01 -> 1er janvier 2025
#'
#' @param date la date
#' @param locale "fr_FR"
#' @param tz Time zone
#' @param short format court
#' @param abbr abrège les noms de mois
#' @returns une chaine de caractères
#'
#' @export
#' @examples
#' date_jour("2025-10-01")

date_jour <- function(
    date,
    locale = "fr_FR.UTF-8",
    tz = "Europe/Paris",
    short = FALSE,
    compact = FALSE,
    abbr = FALSE) {
  date <- lubridate::as_datetime(date, tz = tz)
  d <- lubridate::day(date)
  y <- lubridate::year(date)
  if(short) {
    dsep <- "-"
    sep <- "-"
    label <- FALSE
    y <- y |> stringr::str_sub(3,4)
  }
  if(compact&!short) {
    dsep <- "/"
    sep <- " "
    label <- FALSE
    y <- y |> stringr::str_sub(3,4)
  }
  if(!compact&!short) {
    d <- ifelse(d==1, stringr::str_c(d, "er"), d)
    dsep <- " "
    sep <- ", "
    label <- TRUE
  }
  stringr::str_c(
    d,
    dsep,
    lubridate::month(date, label = label, abbr = abbr, locale = locale),
    dsep,
    y
  )
}

#' Date en jour / avec l'heure
#'
#' Transforme une date dans le format trimestriel standard (revue de l'OFCE)
#' 2025-01-01 -> 1 janvier 2025 12h02
#'
#' @param date la date
#' @param locale "fr_FR"
#' @param tz Time zone
#' @param short format court
#' @param abbr abrège les noms de mois
#'
#' @returns une chaine de caractères
#'
#' @export
#' @examples
#' date_jour("2025-10-01")
date_jour_heure <- function(
    date,
    locale = "fr_FR.UTF-8",
    tz = "Europe/Paris",
    short = FALSE,
    compact = FALSE,
    abbr = FALSE) {
  s1 <- date_jour(date, locale, tz, short, compact, abbr)
  date <- lubridate::as_datetime(date, tz = tz)
  if(short) {
    sep <- "-"
  }
  if(compact&!short) {    dsep <- "/"
    sep <- " "
    }
  if(!compact&!short) {
    sep <- ", "
  }

  stringr::str_c(
    s1,
    sep,
    lubridate::hour(date),
    "h",
    lubridate::minute(date) |> stringr::str_pad(width = 2, pad = "0")
  )
}

#' Magnifiques labels des dates
#'
#' @param x les breaks
#'
#' @returns les labels
#' @export
#'

date1 <- function(x) {
  if(lubridate::is.Date(x))
    x <- year(x)
  fnan <- which(!is.na(x)) |> min()
  r0 <- stringr::str_sub(x, 1, 2)
  cgt <- r0 != lag(r0)
  cgt[fnan] <- TRUE
  cgt[is.na(cgt)] <- FALSE
  r <- stringr::str_sub(x, 3)
  r[cgt] <- stringr::str_c(x[cgt])
  return(r)
}
