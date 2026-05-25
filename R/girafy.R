#' Rend un graphique interactif (avec ggiraph)
#'
#' Cette fonction prend en charge le passage par ggiraph, en spécifiant les options
#' importantes (dont les tooltips). Elle enregistre le graphique pour usage ultérieur
#' (dans une présentation) afin de garantir l'unicité des sources. L'interactivité
#' repose sur l'utilisation des fonctions de `ggiraph` `geom_*_interactive()`.
#'
#' @param plot le graphique ggplot à rendre interactif
#' @param r (1.5) le rayon du zoom sur le point en cas de survol (en pixels)
#' @param o (0.5) l'opacité des autres éléments en cas de survol (entre 0 et 1)
#' @param id identifiant unique pour le graphique, utilisé pour l'enregistrement
#' @param pointsize (12) taille de la police pour le rendu SVG (en points)
#' @param width_svg largeur du graphique SVG en inches. Si NULL, déterminée automatiquement
#' @param height_svg hauteur du graphique SVG en inches. Si NULL, déterminée automatiquement
#' @param tooltip_css chaîne de style CSS personnalisé pour les tooltips.
#'   Utilise `.tooltip_css` par défaut (style intégré)
#' @param biratio vecteur numérique de longueur 2 pour le responsive design :
#'   `c(ratio_desktop, ratio_mobile)`. Par défaut NULL. Si fourni, génère deux versions
#'   du graphique adaptées à la largeur d'écran (desktop et mobile).
#'   Exemple : `c(0.6, 1.333)` produit un graphique plus carré pour desktop
#'   et plus haut pour mobile.
#' @param ... autres options passées à `ggiraph::girafe_options()`
#'
#' @returns un objet ggiraph (en sortie HTML/interactive) ou un ggplot (en sortie statique)
#' @export
girafy <- function(plot,
                   ...,
                   r = 1.5, o = 0.5,
                   id = NULL,
                   pointsize = 12,
                   width_svg = NULL,
                   height_svg = NULL,
                   tooltip_css = .tooltip_css,
                   biratio = NULL) {
  assertthat::assert_that(ggplot2::is_ggplot(plot),
                          msg = "Ce n'est pas un ggplot, pas possible de girafier")
  options <- list(...)
  save_graph(plot, id=id)
  if(knitr::is_html_output()| interactive()) {
    local_options <- function(g)
      ggiraph::girafe_options(
        g,
        ggiraph::opts_hover_inv(css = glue::glue("opacity:{o};")),
        ggiraph::opts_hover(css = glue::glue("r:{r}px;")),
        ggiraph::opts_tooltip(css = tooltip_css)) |>
      ggiraph::girafe_options(!!!options)

    if(is.null(biratio))
      return(
        ggiraph::girafe(
          plot,
          width_svg = width_svg,
          height_svg = height_svg,
          pointsize = pointsize,
          bg = "transparent") |>
          local_options()
      )
    if(!(is.numeric(biratio) & length(biratio) == 2)) {
      chunk <-  knitr::opts_current$get()
      if(!is.null(chunk)) {
        biratio <- c(chunk$fig.width/chunk$fig.height, 1.333)
      } else {
        biratio <- c(0.6, 1.333) }
    }
    giraph_desk  <- ggiraph::girafe(
      plot,
      width_svg = 8,
      height_svg = 8 * biratio[[1]],
      pointsize = pointsize,
      bg = "transparent") |>
      local_options()
    # mobile : portrait
    giraph_mob   <- ggiraph::girafe(
      plot,
      width_svg = 8,
      height_svg = 8 * biratio[[2]],
      pointsize = pointsize,
      bg = "transparent") |>
      local_options()
    if(interactive())
      return(giraph_desk)
    return(
      htmltools::div(
        htmltools::div(class = "d-none d-md-block", giraph_desk),
        htmltools::div(class = "d-md-none",         giraph_mob)) )
  }

  if(!knitr::is_html_output()) {
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
