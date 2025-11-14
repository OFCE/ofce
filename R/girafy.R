#' Rend un graphique interactif (avec ggiraph)
#'
#' Cette fonction prend en charge le passage par ggirapoh, en spécifiant les options importantes (dont les tooltips)
#' Possiblement, elle enregistre le graphique pour usage ultérieur (dans une présentation) ainf de garantir l'unicité des sources
#' Elle prend en charge également la sortie pdf si nécessaire
#' L'interactivité repose sur l'utilisation des fonctions de `ggiraph` `geom_*_interactive()`
#'
#'
#' @param plot le graphique ggplot
#' @param r (1.5) le rayon du zoom sur le point en cas de hover
#' @param o (0.5) l'opacité des autres éléments en cas de hover
#' @param out (NULL) répertoire pour enregistrer
#' @param id utilisé pour tabsetize
#' @param ... autres options passées à `girafe_options()`
#'
#' @returns un ggplot ou un objet ggiraph
#' @export

girafy <- function(plot, r=2.5, o = 0.5, out=getOption("ofce.savegraph"), id = NULL,  ...) {
  if(!is.null(out))
    ofce::savegraph(plot, id=id)
  if(knitr::is_html_output()| interactive()) {
    return(
      ggiraph::girafe(ggobj = plot, bg = "transparent") |>
        ggiraph::girafe_options(
          ggiraph::opts_hover_inv(css = glue::glue("opacity:{o};")),
          ggiraph::opts_hover(css = glue::glue("r:{r}px;")),
          ggiraph::opts_tooltip(css = tooltip_css)) |>
        ggiraph::girafe_options(...)
    )
  }

  if(knitr::is_latex_output()) {
    return(plot)
  }
  # au cas où rien ne colle, on ne fait rien
  plot
}

girafe_opts <- function(x, ...) ggiraph::girafe_options(
  x,
  ggiraph::opts_hover(css = "stroke-width:1px;", nearest_distance = 60),
  ggiraph::opts_tooltip(css = tooltip_css, delay_mouseover = 10, delay_mouseout = 3000)) |>
  ggiraph::girafe_options(...)

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
savegraph <- function(graph, label=NULL,
                      chunk = knitr::opts_current$get(),
                      document=knitr::current_input(),
                      id = NULL, dest = getOption("ofce.savegraph")) {

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
  dir <- Sys.getenv("QUARTO_PROJECT_DIR")

  if(is.null(id))
    id <- ""
  else
    id <- str_c("-",id)

  partie <- path |>
    fs::path_rel(dir) |>
    as.character() |>
    stringr::str_replace("/", "-")

  partie <- partie |>
    stringr::str_c("-", document)

  rep <- fs::path_join(c(ofce.project.root, dest))

  dir.create(rep, recursive = TRUE)
  fn <- stringr::str_c(rep, "/", partie, "-", tolower(label), id)

  qs2::qs_save(object = graph, file = str_c(fn, ".ggplot"))

  return(graph)
}

#' Lit un graphique sauvegardé
#'
#' Lorsque `ofce.savegraph` ets non NULL, chaque graphique qui passe dans `girafy` est enregistré dans le dossier `ofce.savegraph`.
#' Son nom est formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le label du fichier (séparé par des tirets)
#' par exmple : "index-fig-psal" ou "france-synthese-fig-indicateurs"
#'
#' @param graphe (string) nom du graphique composé du dossier d'un tiret du nom du document d'un tiret et du label du graphique
#'
#' @returns un ggplot
#' @export
#'
load_graphe <- function(graphe) {
  dir <- optionGet("ofce.savegraph")
  if(is.null(dir))
    return(NULL)
  qs2::qs_read(
    fs::path_join(c(ofce.project.root, optionGet(ofce.savegraph), graphe)) |>
      fs::path_ext_set("ggplot"))
}
