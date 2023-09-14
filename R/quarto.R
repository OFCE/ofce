#' Extensions OFCE pour quarto
#'
#' Installe gentiment les extensions quarto suivantles templates OFCE
#' Trois templates sont prévus et s'insèrent dans un yml (ou dans la section yml) comme suit
#' format:
#'   ofce-html: default # on peut ajouter tous les champs html
#'   ofce-pdf: default # pour les pdf, à affiner
#'   ofce-revealjs: default # pour les présentations
#'
#'  Si le document à rendre est dans un dossier, il faut utiliser l'argument dir
#'
#' @param dir Répertoire dans lequel l'extension est installée
#' @return NULL
#' @export
#'
add_OFCE_quarto_extension <- function(dir=".") {

  wd_dir <- getwd()
  setwd(dir)
  system("quarto add ofce/ofce-quarto-extensions --no-prompt --quiet")
  cli::cli_alert_success(
    "extensions quarto OFCE installées dans {dir}
      ofce-html, ofce-pdf ou ofce-revealjs pour un document .qmd
      ---
      format:
        ofce-html: default
        ofce-pdf:
          mainfont: Arial
      ---
    ou
       format: ofce-html")
  setwd(wd_dir)
}

