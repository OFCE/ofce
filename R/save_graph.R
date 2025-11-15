#' Enregistre un graphe
#'
#' @param graph le ggplot
#' @param label son label (mis à partir de knitr si possible)
#' @param chunk les infos de chunk (de knitr)
#' @param document le nom du document qmd (à partir de quarto)
#' @param id un id pour les tabset
#' @param dest le dossier de sauvegarde (ofce.savegraph)
#'
#' @returns le graphique, avec un effet de bord qui est le ggplot enregistré
#' @export
#'
save_graph <- function(graph, label=NULL,
                       chunk = knitr::opts_current$get(),
                       document=knitr::current_input(),
                       id = NULL,
                       dest = getOption("ofce.savegraph.dir")) {

  if(!getOption("ofce.savegraph"))
    return(graph)

  if(is.null(dest))
    return(graph)

  if(!knitr::is_html_output())
    return(graph)

  if(is.null(document)|document=="")
    return(graph)

  if(Sys.getenv("QUARTO_DOCUMENT_PATH")=="")
    return(graph)

  ratio <- chunk$fig.width/chunk$fig.height
  document <- document |> str_remove("\\..+")
  label <- chunk$label

  if(is.null(label)|label=="")
    return(graph)

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

  qs2::qs_save(object = graph, file = str_c(fn, ".ggplot"))

  return(graph)
}

#' Lit un graphique sauvegardé
#'
#' Lorsque `ofce.savegraph` est non NULL, chaque graphique qui passe dans `girafy` est enregistré dans le dossier `ofce.savegraph`.
#' Son nom est formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le label du fichier (séparé par des tirets)
#' par exmple : "index-fig-psal" ou "france-synthese-fig-indicateurs"
#'
#' @param graphe (string) nom du graphique composé du dossier d'un tiret du nom du document d'un tiret et du label du graphique
#'
#' @returns un ggplot
#' @export
#'
load_graphe <- function(graphe) {
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
  fn <- fs::path_join(c(root, dir, graphe)) |>
    fs::path_ext_set("ggplot")

  if(!file.exists(fn)) {
    cli::cli_alert_warning("Le graphique {graphe} n'existe pas")
    return(NULL)
  }

  qs2::qs_read(
    fs::path_join(c(root, dir, graphe)) |>
      fs::path_ext_set("ggplot"))
}
