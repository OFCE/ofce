#' Extensions OFCE pour quarto
#'
#' Installe gentiment les extensions quarto suivantles templates OFCE
#' Trois templates sont prévus et s'insèrent dans un yml (ou dans la section yml) comme suit
#' format:
#'   ofce-html: default # on peut ajouter tous les champs html
#'   ofce-pdf: default # pour les pdf, à affiner
#'   ofce-revealjs: default # pour les présentations
#'
#' Il est possible de spécifier toutes les éléments habituels des formats sous jacents par la syntaxe habituelle
#'
#' Si le document à rendre est dans un dossier, il faut utiliser l'argument dir et l'extension sera installé à cet endroit
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
    "extensions quarto OFCE dans {getwd()}
     Mettre dans le yml ce qui suit
      ---
      format:
        ofce-html: default # html
        ofce-revealjs: default # presentation
        ofce-pdf: # document de travail en pdf
          mainfont: Arial
      ---
    ou
       format: ofce-html")
  setwd(wd_dir)
}

