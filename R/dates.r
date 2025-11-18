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
  str_c("T", lubridate::quarter(date), " ", lubridate::year(date))
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
  str_c(
    lubridate::month(date, label = TRUE, abbr = FALSE),
    " ",
    lubridate::year(date)
  )
}

#' Date en jour
#'
#' Transforme une date dans le format trimestriel standard (revue de l'OFCE)
#' 2025-01-01 -> 1 janvier 2025
#'
#' @param date la date
#'
#' @returns une chaine de caractères
#'
#' @export
#' @examples
#' date_jour("2025-10-01")
date_jour <- function(date) {
  str_c(
    lubridate::day(date),
    " ",
    lubridate::month(date, label = TRUE, abbr = FALSE),
    " ",
    lubridate::year(date)
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
