#' Extensions OFCE pour quarto
#'
#' Installe gentiment les extensions quarto suivantles templates OFCE
#' Trois templates sont prévus et s'insèrent dans un yml (ou dans la section yml) comme suit
#' format:
#'   ofce-html: default # on peut ajouter tous les champs html
#'   ofce-pdf: default # pour les pdf, à affiner
#'   ofce-revealjs: default # pour les présentations
#'
#'
#' @return
#' @export
#'
add_OFCE_qext <- function() {
  shell("quarto add ofce/ofce-quarto-extensions --no-prompt --quiet")
}
