#' Enregistre un graphe
#'
#' @param object le ggplot
#' @param label son label (mis à partir de knitr si possible)
#' @param chunk les infos de chunk (de knitr)
#' @param document le nom du document qmd (à partir de quarto)
#' @param id un id pour les tabset
#' @param dest le dossier de sauvegarde (ofce.savegraph)
#'
#' @returns le graphique, avec un effet de bord qui est le ggplot enregistré
#' @export
#'
save_object <- function(object, label=NULL,
                       chunk = knitr::opts_current$get(),
                       document=knitr::current_input(),
                       id = NULL,
                       dest = getOption("ofce.savegraph.dir"),
                       ext = "ggplot") {

  if(!getOption("ofce.savegraph"))
    return(object)

  if(is.null(dest))
    return(object)

  if(!knitr::is_html_output())
    return(object)

  if(is.null(document)|document=="")
    return(object)

  if(Sys.getenv("QUARTO_DOCUMENT_PATH")=="")
    return(object)

  ratio <- chunk$fig.width/chunk$fig.height
  document <- document |> str_remove("\\..+")
  label <- chunk$label

  if(is.null(label)|label=="")
    return(object)

  path <- Sys.getenv("QUARTO_DOCUMENT_PATH")
  if(Sys.getenv("QUARTO_PROJECT_DIR") == "") {
    safe_find_root <- purrr::safely(rprojroot::find_root)
    root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
    if(is.null(root$error))
      root <- root$result
  } else {
    root <- Sys.getenv("QUARTO_PROJECT_DIR")
  }

  if(is.null(id))
    id <- ""
  else
    id <- str_c("-",id)

  partie <- path |>
    fs::path_rel(root) |>
    as.character() |>
    stringr::str_replace("/", "-")

  if(partie == ".")
    partie <- document else
      partie <- partie |>
    stringr::str_c("-", document)

  rep <- fs::path_join(c(root, dest))

  dir.create(rep, recursive = TRUE)

  fn <- stringr::str_c(rep, "/", partie, "-", tolower(label), id)

  qs2::qs_save(object = object, file = str_c(fn, ".", ext))

  return(object)
}

#' Lit un objet sauvegardé
#'
#' Lorsque `ofce.savegraph` est non NULL, chaque graphique qui passe dans `girafy` est enregistré dans le dossier `ofce.savegraph`.
#' Son nom est formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le label du fichier (séparé par des tirets)
#' par exmple : "index-fig-psal" ou "france-synthese-fig-indicateurs"
#'
#' @param object (string) nom du graphique composé du dossier d'un tiret du nom du document d'un tiret et du label du graphique
#' @param ext ("ggplot") extension à utiliser
#'
#' @returns un ggplot ou un gt
#' @export
#'
load_object <- function(object, ext = "ggplot") {
  dir <- getOption("ofce.savegraph.dir")
  if(is.null(dir)) {
    cli::cli_alert_warning("Pas de graphiques sauvegardés")
    return(NULL)
  }
  if(!dir.exists(dir)) {
    cli::cli_alert_warning("Le répertoire {dir} n'existe pas")
    return(NULL)
  }

  if(Sys.getenv("QUARTO_PROJECT_DIR") == "") {
    safe_find_root <- purrr::safely(rprojroot::find_root)
    root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
    if(is.null(root$error))
      root <- root$result
  } else {
    root <- Sys.getenv("QUARTO_PROJECT_DIR")
  }
  fn <- fs::path_join(c(root, dir, object)) |>
    fs::path_ext_set(ext)
  dic <- c("ggplot" = "graphique", "gt" = "tableau gt")
  if(!file.exists(fn)) {
    cli::cli_alert_warning("Le graphique {dic[ext]} n'existe pas")
    return(NULL)
  }

  qs2::qs_read(
    fs::path_join(c(root, dir, object)) |>
      fs::path_ext_set(ext))
}

#' Enregistre un graphe
#'
#' L'enregistrement est fait dans le dossier spécifié dans les options
#'
#' @param object le ggplot
#' @seealso [save_object()]
#' @returns le graphique, avec un effet de bord qui est le ggplot enregistré
#' @export
#'
save_graph <- function(object) save_object(object = object, ext = "ggplot")

#' Enregistre un graphe
#'
#' L'enregistrement est fait dans le dossier spécifié dans les options
#'
#' @param object le ggplot
#' @seealso [save_object()]
#' @returns le graphique, avec un effet de bord qui est le ggplot enregistré
#' @export
#'
save_ggplot <- function(object) save_object(object = object, ext = "ggplot")

#' Enregistre un tableau
#'
#' L'enregistrement est fait dans le dossier spécifié dans les options
#'
#' @param object le ggplot
#' @seealso [save_object()]
#' @returns le graphique, avec un effet de bord qui est le gt enregistré
#' @export
#'
save_gt <- function(object) save_object(object = object, ext = "gt")

#' Lit un tableau sauvegardé
#'
#' Lorsque `ofce.savegraph` est non NULL, chaque tableau qui passe dans `save_gt` est enregistré dans le dossier `ofce.savegraph`.
#' Son nom est formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le label du fichier (séparé par des tirets)
#' par exmple : "index-fig-psal" ou "france-synthese-fig-indicateurs"
#'
#' @param object (string) nom du graphique composé du dossier d'un tiret du nom du document d'un tiret et du label du graphique
#'
#' @returns un gt
#' @export
#'
load_gt <- function(object) load_object(object, ext="gt")

#' Lit un graphique sauvegardé
#'
#' Lorsque `ofce.savegraph` est non NULL, chaque tableau qui passe dans `save_gt` est enregistré dans le dossier `ofce.savegraph`.
#' Son nom est formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le label du fichier (séparé par des tirets)
#' par exmple : "index-fig-psal" ou "france-synthese-fig-indicateurs"
#'
#' @param object (string) nom du graphique composé du dossier d'un tiret du nom du document d'un tiret et du label du graphique
#'
#' @returns un ggplot
#' @seealso [load_object()]
#' @export
#'
load_graphe <- function(object) load_object(object, ext = "ggplot")

#' Lit un graphique sauvegardé
#'
#' Lorsque `ofce.savegraph` est non NULL, chaque tableau qui passe dans `save_gt` est enregistré dans le dossier `ofce.savegraph`.
#' Son nom est formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le label du fichier (séparé par des tirets)
#' par exmple : "index-fig-psal" ou "france-synthese-fig-indicateurs"
#'
#' @param object (string) nom du graphique composé du dossier d'un tiret du nom du document d'un tiret et du label du graphique
#'
#' @returns un ggplot
#' @seealso [load_object()]
#' @export
#'
load_ggplot <- function(object) load_object(object, ext = "ggplot")
