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
girafy <- function(plot, r=2.5, o = 0.5, id = NULL, tooltip_css = .tooltip_css, ...) {
  assertthat::assert_that(ggplot2::is_ggplot(plot),
                          msg = "Ce n'est pas un ggplot, pas possible de girafier")
  save_graph(plot, id=id)
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

.tooltip_css  <-
  "font-family:Open Sans;
  background-color:snow;
  border-radius:5px;
  border-color:gray;
  border-style:solid;
  border-width:0.5px;
  font-size:9pt;
  padding:4px;
  box-shadow: 2px 2px 2px gray;
  r:20px;"

girafe_opts <- function(x, ...) ggiraph::girafe_options(
  x,
  ggiraph::opts_hover(css = "stroke-width:1px;", nearest_distance = 60),
  ggiraph::opts_tooltip(css = tooltip_css, delay_mouseover = 10, delay_mouseout = 3000)) |>
  ggiraph::girafe_options(...)
