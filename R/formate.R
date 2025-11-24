#' Formate un nombre
#'
#' Semblable aux innombrables fonctions de formatage
#' formate en français ("," et " " comme séparateurs)
#'
#' @param x le nombre
#' @param digits (defaut 1) nombre de chiffres après la virgule
#' @param scale (defaut 1) échelle (mulitplie par ce nombre)
#' @param suffix (defaut "") ajoute un suffix
#'
#' @returns string
#' @export
#'
#' @examples
#' fmt_val(10.56, 1, 1, " euros")
fmt_val <- function(x, digits=1, scale = 1, suffix = "") {
  stringr::str_c(
    base::formatC(x=x*scale, digits = digits, big.mark = " ", decimal.mark = ",", format = "f"),
    suffix)
}

#' Formate un nombre en pourcent
#'
#' Semblable aux innombrables fonctions de formatage
#' formate en français ("," et " " comme séparateurs)
#'
#' @param x le nombre
#' @param digits (defaut 0) nombre de chiffres après la virgule
#'
#' @returns string
#' @export
#'
#' @examples
#' fmt_pct(0.12)
fmt_pct <- function(x, digits=0) {
  fmt_val(x, scale = 100, digits = digits, suffix = "%")
}

#' Formate en milliards d'euros
#'
#' Semblable aux innombrables fonctions de formatage
#' formate en français ("," et " " comme séparateurs)
#'
#' @param x le nombre
#' @param log (defaut 3) différence en log10 entre l'origine et la destination 3 passe de millions à milliards
#' @param suffix (defaut " Mds €") ajoute un suffix
#' @param digits (defaut 1) nombre de chiffres après la virgule
#'
#' @returns string
#' @export
#'
#' @examples
#' fmt_mds(0.12)
fmt_mds <- function(x, log=3, digits = 1, suffix = " Mds €") {
  fmt_val(x, scale = 10^log, digits = digits, suffix = suffix)
}
