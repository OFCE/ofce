#' Utilise le SI pour formatter les nombres en fonction des mulitples de 10^3
#'
#' @param number le nombre ou le vecteur à formatter (numérique)
#' @param rounding doit-on arrondir le chiffre ?
#' @param digits Combien de chiffres après la virgule
#' @param unit Arrondi soit à la "median" soit au "max"
#'
#' @return une chaine de caractère (character) formattée
#' @export
#' @seealso if2si2 (inverse la transformation)
#' @examples
#' f2si2(100000)
#'
f2si2 <- function(number, rounding = TRUE, digits = 1, unit = "median") {
  lut <- c(
    1e-24, 1e-21, 1e-18, 1e-15, 1e-12, 1e-09, 1e-06,
    0.001, 1, 1000, 1e+06, 1e+09, 1e+12, 1e+15, 1e+18, 1e+21,
    1e+24
  )
  pre <- c(
    "y", "z", "a", "f", "p", "n", "u", "m", "", "k",
    "M", "G", "T", "P", "E", "Z", "Y"
  )
  ix <- ifelse(number!=0, findInterval(number, lut) , 9L)
  ix <- switch(unit,
               median = stats::median(ix, na.rm = TRUE),
               max = max(ix, na.rm = TRUE),
               multi = ix
  )
  if (rounding == TRUE)
    scaled_number <- round(number/lut[ix], digits)
  else
    scaled_number <- number/lut[ix]

  sistring <- paste0(scaled_number, pre[ix])
  sistring[scaled_number==0] <- ifelse(number[scaled_number==0]==1, "1", "0")
  return(sistring)
}

f2si2df <- function(df, string = "", unit = "multi") {
  purrr::map(df, ~ stringr::str_c(f2si2(.x, unit = unit), string, sep = " "))
}

#' Transforme une chaîne formatté SI en nombre
#'
#' @param text le nombre ou le vecteur de nombres formattés à transformer
#'
#' @return un nombre
#' @export
#'
#' @examples
#' if2si2("100k")
#'
if2si2 <- function(text) {
  pre <- c(
    "y", "z", "a", "f", "p", "n", "u", "m", "1", "k",
    "M", "G", "T", "P", "E", "Z", "Y"
  )
  lut <- c(
    1e-24, 1e-21, 1e-18, 1e-15, 1e-12, 1e-09, 1e-06,
    0.001, 1, 1000, 1e+06, 1e+09, 1e+12, 1e+15, 1e+18, 1e+21,
    1e+24
  )
  names(lut) <- pre
  value <- stringr::str_extract(text, "[:digit:]+\\.?[:digit:]*") |>
    as.numeric()
  unit <- stringr::str_extract(text, "(?<=[:digit:])[:alpha:]")
  unit[is.na(unit)] <- "1"
  value * lut[unit]
}

#' Formatte un vecteur en produisant des éléments distincts
#'
#' Utilise f2si2 pour formatter un vecteur, et arrondi tant que les éléments formattés sont tous disctints.
#' Cela permet de les utiliser dans une échelle ou pour des noms.
#' Les nombres en entrée doivent être différents
#' @param number le nombre ou le vecteur de nombre
#' @param rounding doit-on arrondir ?
#' @param unit Arrondi soit à la "median" soit au "max"
#' @param digits_max le nombre maximal de chiffres après la virgule
#'
#' @return une chaine de charactères
#' @export
#'
#' @examples
#' uf2si2(c(1000,1100,2000,2100))
#'
uf2si2 <- function(number, rounding = TRUE, unit = "median", digits_max=4) {
  n_number <- length(number)
  digits <- 1
  f2 <- f2si2(number, digits = digits, unit = unit)
  while (length(unique(f2)) < n_number & digits <= digits_max) {
    digits <- digits + 1
    f2 <- f2si2(number, digits = digits, unit = unit)
  }
  f2
}
