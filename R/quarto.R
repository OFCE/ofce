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

setup_quarto <- function(dir=".", quiet = FALSE) {
  wd_dir <- getwd()
  if(!dir.exists(dir)) {
    ok <- dir.create(dir, recursive = TRUE)
    if(!ok) stop("Impossible de créer le dossier")
  }
  setwd(dir)
  # system("sh -c 'cd \"{dir}\"; quarto add ofce/ofce-quarto-extensions --no-prompt --quiet'" |> glue::glue())
  quarto::quarto_add_extension(
    "ofce/ofce-quarto-extensions",
    no_prompt = TRUE,
    quiet = quiet)

  ##enlever le dossier blog-site
  old_ext <- file.path("_extensions","ofce","blog_site")
  if(dir.exists(old_ext)){
    unlink(old_ext, recursive = TRUE)
  }



  if(!quiet) cli::cli_alert_success(
    "Mettre dans le yaml ce qui suit:
      ---
      format:
        ofce-html: default # une page en html
        wp-html: default # Document de travail en html
        wp-pdf: default # Document de travail en pdf
        wp-en-html: default # Document de travail html en anglais
        wp-en-html: default # Document de travail pdf en anglais
        pres-revealjs: default # presentation
        blog-html: default # Post de blog en html
        blog-pdf: default # Post de blog en pdf
      ---
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
setup_wp <- function(dir = NULL, nom = NULL) {
  if(quarto::quarto_version()<"1.5.57")
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
    cli::cli_alert_danger(
      "Il y déjà un '{nom}.qmd' dans le répertoire {.path {dir}}")
    return(invisible(FALSE))
  }
  if(file.exists(refs)) {
    cli::cli_alert_danger(
      "Il y déjà un 'references.bib' dans le répertoire {.path {dir}}")
    return(invisible(FALSE))
  }

  setup_quarto(dir, quiet = TRUE)
  cli::cli_alert_info("extensions installées")

  template <- system.file(
    "extdata/templates/workingpaper",
    "template.qmd",
    package="ofce")

  bib <- system.file(
    "extdata/templates/workingpaper",
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
  cli::cli_alert_info(
    "qmd initialisé, .gitignore modifié")
  quarto::quarto_preview(target, render="wp-html")
  return(invisible(TRUE))
}

last_dir <- function(string) {
  string <- stringr::str_replace_all(string, "\\\\", "/")
  if (stringr::str_detect(string, "/"))
    stringr::str_extract(string, "(?<=/)\\w+$")
  else
    string
}

#' Modifie la taille de police pour revealjs
#'
#' Attention cette fonction est un hack en attendant mieux
#' Elle est assez fragile et peut ne pas fonctionner
#'
#' @param path chemin vers la présentation à modifier (le dossier qui contient la présentation)
#' @param size taille en "px" de la police pour revealjs (20 par défaut)
#'
#' @return NULL
#' @export
#'
set_fontsize_reveal <- function(path=".", size=20) {
  scss <- stringr::str_c(path, "/_extensions/ofce/pres/ofce-pres.scss")
  if(!file.exists(scss)) {
    cli::cli_alert_warning(
      'pas de scss, exécutez ofce::setup_quarto("{path}")')
    stop()
  }
  readLines(scss) |>
    stringr::str_replace(
      pattern = "\\$presentation-font-size-root: [:digit:]+px;",
      replace = stringr::str_c("$presentation-font-size-root: ", size, "px;")) |>
    writeLines(con = scss)
}

#' Modifie l'icône de titre pour la présentation
#'
#' Attention cette fonction est un hack en attendant mieux
#' Elle est assez fragile et peut ne pas fonctionner
#'
#' @param path chemin vers la présentation à modifier (le dossier qui contient la présentation)
#' @param icon code unicode hexa de l'icone (f101 par défaut)
#'
#' @return NULL
#' @export
#'
set_faicon_reveal <- function(path=".", unicode="f101") {
  scss <- stringr::str_c(path, "/_extensions/ofce/pres/ofce-pres.scss")
  if(!file.exists(scss)) {
    cli::cli_alert_warning(
      'pas de scss, exécutez ofce::setup_quarto("{path}")')
    stop()
  }
  readLines(scss) |>
    stringr::str_replace(
      pattern = "content: \"\\\\[:alnum:]+\";",
      replace = stringr::str_c("content: \"\\\\", unicode, "\";")) |>
    writeLines(con = scss)
}

#' Modifie la justification des textes en HTML
#'
#' Attention cette fonction est un hack en attendant mieux
#' Elle est assez fragile et peut ne pas fonctionner
#'
#' @param path chemin vers le ou les documents HTML
#' @param justify (boolean) TRUE pour justifier, FALSE pour aligner à gauche
#' @param ext (string) extension des fichiers à modifier (ofce par défaut)
#' @return NULL
#' @export
#'
set_justify <- function(path=".", justify=TRUE, ext="ofce") {
  if(ext=="ofce")
    scss <- stringr::str_c(path, "/_extensions/ofce/ofce/ofce.scss")
  else
    scss <- stringr::str_c(path, "/_extensions/ofce/wp/html_template/ofcewp.scss")

  if(!file.exists(scss)) {
    cli::cli_alert_warning(
      'pas de scss, exécutez ofce::setup_quarto("{path}")')
    stop()
  }
  readLines(scss) |>
    stringr::str_replace(
      pattern = "\\$aligment: [:alpha:]*;",
      replace = stringr::str_c("$aligment: ",
                               ifelse(justify, "justify;", "left;"))) |>
    writeLines(con = scss)
}


#' installe un squelette de présentation
#'
#' prépare un dossier, avec un exemple et les extensions nécessaires pour le formattage OFCE
#'
#' @param nom Nom du projet, "pres" par défaut,
#' @param dir Répertoire à créer "pres" par défaut
#'
#' @return NULL
#' @export
#'
#'
setup_pres <- function(dir = NULL, nom = NULL) {
  if(quarto::quarto_version()<"1.5.57")
    cli::cli_alert_info(
      "Quarto 1.4 est recommandé pour les fonctions avancées
        (manuscript, lua, lightbox, corrections de bugs, ...)
      {.url https://github.com/quarto-dev/quarto-cli/releases}")

  if(is.null(dir)) {
    if(is.null(nom)) {
      dir <- "."
      nom <- "pres"
    }
    else
      dir <- nom
  }
  if(is.null(nom))
    nom <- last_dir(dir)
  target <- stringr::str_c(dir, "/", nom, ".qmd")
  refs <- stringr::str_c(dir, "/", nom, "_references.bib")
  if(file.exists(target)) {
    cli::cli_alert_danger(
      "Il y déjà un '{nom}.qmd' dans le répertoire {.path {dir}}")
    return(invisible(FALSE))
  }
  if(file.exists(refs)) {
    cli::cli_alert_danger(
      "Il y déjà un 'references.bib' dans le répertoire {.path {dir}}")
    return(invisible(FALSE))
  }

  setup_quarto(dir, quiet = TRUE)
  cli::cli_alert_info("extensions installées")

  template <- system.file(
    "extdata/templates/presentation",
    "template.qmd",
    package="ofce")

  bib <- system.file(
    "extdata/templates/presentation",
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
  # rstudioapi::executeCommand("foldAll")
  usethis::git_vaccinate()
  cli::cli_alert_info("qmd initialisé, .gitignore modifié")
  quarto::quarto_preview(target, render="pres-revealjs")
  return(invisible(TRUE))
}

#' installe un squelette de présentation
#'
#' prépare un dossier, avec un exemple et les extensions nécessaires pour le formattage OFCE
#'
#' @param nom Nom du projet, "pres" par défaut,
#' @param dir Répertoire à créer "pres" par défaut
#'
#' @return NULL
#' @export
#'
#'
setup_blog <- function(dir = NULL, nom = NULL) {
  if(quarto::quarto_version()<"1.5.57")
    cli::cli_alert_info(
      "Quarto 1.4 est recommandé pour les fonctions avancées
        (manuscript, lua, lightbox, corrections de bugs, ...)
      {.url https://github.com/quarto-dev/quarto-cli/releases}")

  if(is.null(dir)) {
    if(is.null(nom)) {
      dir <- "."
      nom <- "blog"
    }
    else
      dir <- nom
  }
  if(is.null(nom))
    nom <- last_dir(dir)
  target <- stringr::str_c(dir, "/", nom, ".qmd")
  refs <- stringr::str_c(dir, "/blogreferences.bib")
  if(file.exists(target)) {
    cli::cli_alert_danger(
      "Il y déjà un '{nom}.qmd' dans le répertoire {.path {dir}}")
    return(invisible(FALSE))
  }
  if(file.exists(refs)) {
    cli::cli_alert_danger(
      "Il y déjà un 'references.bib' dans le répertoire {.path {dir}}")
    return(invisible(FALSE))
  }

  setup_quarto(dir, quiet = TRUE)
  cli::cli_alert_info("extensions installées")

  template <- system.file("extdata/templates/blog",
                          "template.qmd",
                          package="ofce")
  dat <- system.file("extdata/templates/blog",
                     "data_source.R",
                     package="ofce")
  bib <- system.file("extdata/templates/blog",
                     "blogreferences.bib",
                     package="ofce")
  file.copy(template, to = target)
  readLines(target) |>
    stringr::str_replace(
      pattern = "bibliography: blogreferences.bib",
      replace = stringr::str_c("bibliography: blogreferences.bib")) |>
    writeLines(con = target)
  file.copy(bib, to = refs)
  file.copy(dat, to = dir)
  rstudioapi::navigateToFile(
    file = target,
    line = -1L,
    column = -1L,
    moveCursor = TRUE
  )
  # rstudioapi::executeCommand("foldAll")
  usethis::git_vaccinate()
  cli::cli_alert_info("qmd initialisé, .gitignore modifié")
  quarto::quarto_preview(target, render="blog-html")
  return(invisible(TRUE))
}
