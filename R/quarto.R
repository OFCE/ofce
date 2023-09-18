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
#' @param quiet Ne fait pas de bruit (défault FALSE)
#' @return NULL
#' @export
#'
ofce_quarto_extension <- function(dir=".", quiet = FALSE) {

  wd_dir <- getwd()
  if(dir.exists(dir))
    setwd(dir)
  else {
    dir.create(dir)
    setwd(dir)
  }

  system("quarto add ofce/ofce-quarto-extensions --no-prompt --quiet")
  if(!quiet) cli::cli_alert_success(
    "extensions quarto OFCE dans {getwd()}
     Mettre dans le yml ce qui suit
      ---
      format:
        ofcewp-html: default # Document de travail en html
        ofcewp-pdf: default # Document de travail en pdf
        ofce-revealjs: default # presentation
        ofceblog-html: default # Post de blog en html
        ofceblog-pdf: default # Post de blog en pdf
      ---
    ou (dans le yaml)
       format: ofce-html

    consulter Anissa, Paul, Xavier ou {.url https://quarto.org} pour d'autres options")
  setwd(wd_dir)
}

#' installe un squelette de document de travail
#'
#' prépare un dossier, avec un exemple et les extensions nécessaires pour le formattage OFCE
#'
#' @param nom Nom du projet, "wp" par défaut,
#' @param dir Répertoire à créer "wp" par défaut
#'
#' @return NULL
#' @export
#'
#'
ofce_quarto_wp <- function(dir = NULL, nom = NULL) {
  if(quarto::quarto_version()<"1.4.358")
    cli::cli_alert_info(
      "Quarto 1.4 est recommandé pour les fonctions avancées
        (manuscript, lua, corrections de bugs, ...)
      {.url https://github.com/quarto-dev/quarto-cli/releases}")

  if(is.null(dir)) {
    if(is.null(nom)) {
      dir <- "."
      nom <- "wp"
    }
    else
      dir <- nom
  }
  if(is.null(nom))
    nom <- last_dir(dir)
  target <- stringr::str_c(dir, "/", nom, ".qmd")
  refs <- stringr::str_c(dir, "/", nom, "_references.bib")
  if(file.exists(target)) {
    cli::cli_alert_danger("Il y déjà un '{nom}.qmd' dans le répertoire {.path {dir}}, abort")
    return(invisible(FALSE))
  }
  if(file.exists(refs)) {
    cli::cli_alert_danger("Il y déjà un 'references.bib' dans le répertoire {.path {dir}}, abort")
    return(invisible(FALSE))
  }

  ofce_quarto_extension(dir, quiet = TRUE)
  template <- system.file("extdata/templates/workingpaper",
                          "template.qmd",
                          package="ofce")

  bib <- system.file("extdata/templates/workingpaper",
                     "references.bib",
                     package="ofce")
  file.copy(template, to = target)
  readLines(target) |>
    stringr::str_replace(
      pattern = "bibliography: references.bib",
      replace = stringr::str_c("bibliography: ", nom, "_references.bib")) |>
    writeLines(con = target)
  file.copy(bib, to = refs)
  rstudioapi::navigateToFile(
    file = target,
    line = -1L,
    column = -1L,
    moveCursor = TRUE
  )
  rstudioapi::executeCommand("foldAll")
  usethis::git_vaccinate()
  cli::cli_alert_info("qmd initialisé, .gitignore modifié")
  quarto::quarto_preview(target, render="html")
  return(invisible(TRUE))
}

last_dir <- function(string) {
  string <- stringr::str_replace_all(string, "\\\\", "/")
  if (stringr::str_detect(string, "/"))
    stringr::str_extract(string, "(?<=/)\\w+$")
  else
    string
}
