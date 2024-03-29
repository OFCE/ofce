#' theme OFCE
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' d'autres éléments de la norme comme les couleurs, l'allure générale du graphique
#' sont à introduire par ailleurs
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Nunito"))
#' @param ... paramètres passés à \code{\link[ggplot2]{theme}()}
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @export
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit


theme_ofce <- function(base_size = getOption("ofce.base_size"), base_family = getOption("ofce.base_family"), ...) {
 # if(requireNamespace("ggh4x", quietly = TRUE))
 #   ggh4xdef <-  ggplot2::theme(ggh4x.axis.ticks.length.minor = ggplot2::rel(0.66))
 # else
 #   ggh4xdef <- NULL
   theme_foundation() +
    ggplot2::theme(
      # general
      plot.background = element_rect(fill="white"),
      text = element_text(
        family = base_family,
        size = base_size),
      rect = element_rect(
        fill = NA,
        colour = NA,
        linetype = 0),
      #Text format:
      plot.title = ggtext::element_markdown(
        face = "plain",
        hjust = 0,
        margin = margin(b=2.5, t=2.5),
        lineheight = 1.5),
      plot.subtitle =  ggtext::element_markdown(
        size = ggplot2::rel(0.85),
        face = "plain",
        hjust = 0,
        margin = margin(b=2.5, t=2.5),
        lineheight = 1.2),
      plot.caption = ggtext::element_markdown(
        size = ggplot2::rel(0.8),
        color = "gray25",
        face="plain",
        hjust = 0,
        vjust = 0.5,
        margin = unit(c(12, 0, 0, 0), 'pt'),
        lineheight=1.1),
      plot.margin = margin(b=8, t=8, l=2, r=2),
      plot.caption.position = "plot",
      #Legend format
      legend.position = "right",
      legend.justification= "center",
      legend.text.align = 0,
      legend.title = element_text(
        face = "plain",
        size = ggplot2::rel(0.85),
        color = "gray25"),
      legend.background = element_blank(),
      legend.text = element_text(
        face = "plain",
        size = ggplot2::rel(0.75),
        color = "gray25"),
      legend.margin = margin(t=0, r=0, b=0, l=0),
      # #Axis format
      axis.title  = element_text(
        size = ggplot2::rel(0.75),
        color = "#222222"),
      axis.text = element_text(
        size = ggplot2::rel(0.75),
        color = "#222222"),
      axis.text.y = element_text(
        color = "gray25",
        margin=margin(r=5, b=0, t=0, l=1.5),
        hjust = 1,
        vjust=0.5),
      axis.text.x = element_text(
        color = "gray25",
        margin=margin(t=6, b=0),
        hjust = 0.5),
      axis.ticks = element_line(
        color="gray50",
        size = unit(0.2, "pt")),
      axis.ticks.length.x = unit(-2.5,"pt"),
      axis.ticks.length.y = unit(-2.5,"pt"),
      axis.line = element_line(
        colour = "gray40",
        size = unit(0.2, "pt"),
        lineend="round"),
      #Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(
        size = unit(0.1, "pt"),
        color = "gray80"),
      panel.grid.major.x = element_blank(),
      #Blank background
      panel.background = element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color")),
      panel.spacing = unit(3, "pt"),
      strip.background = element_rect(fill="white"),
      strip.text = element_text(
        size = ggplot2::rel(0.85), face = "bold",
        hjust = 0.5,
        vjust = 0.5,
        margin = margin(t=8, b=6)))+
    # ggh4xdef +
    ggplot2::theme(...) # pour passer les arguments en plus
}



#' Thème OFCE void
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' Convient pour des cartes par exemple
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Nunito"))
#' @param ... paramètres passés à \code{\link[ggplot2]{theme}()}
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @export


theme_ofce_void <- function(base_size = getOption("ofce.base_size"), base_family = getOption("ofce.base_family"), ...) {
  theme_foundation() +
    ggplot2::theme(
      # general
      plot.background = element_rect(fill="white"),
      text = element_text(
        family=base_family,
        size = base_size),
      rect = element_rect(
        fill = NA,
        size = base_size,
        colour = NA,
        linetype = 0),
      title = element_text(
        family=base_family,
        size = base_size),
      #Text format:
      plot.title = ggtext::element_markdown(
        size = base_size,
        family = base_family,
        face = "bold",
        hjust = 0,
        margin = margin(b=2.5, t=2.5),
        lineheight = 1.5),
      plot.subtitle =  ggtext::element_markdown(
        size = rel(0.85),
        face = "plain",
        hjust = 0,
        margin = margin(b=2.5, t=2.5),
        lineheight = 1.2),
      plot.caption = ggtext::element_markdown(
        size = rel(0.8),
        color = "gray25",
        face="plain",
        hjust = 0,
        vjust = 0.5,
        margin = margin(b=0, t=12),
        lineheight=1.1),
      plot.margin = margin(b=8, t=8, l=2, r=2),
      plot.caption.position = "plot",
      #Legend format
      legend.position = "right",
      legend.justification= c(1,1),
      legend.text.align = 0,
      legend.title = element_text(
        face = "bold",
        size = rel(0.85),
        color = "gray25"),
      legend.background = element_blank(),
      legend.text = element_text(
        face = "plain",
        size = rel(0.75),
        color = "gray25"),
      legend.margin = margin(t=0, r=0, b=0, l=0),
      # #Axis format
      axis.title  = element_blank(),
      axis.ticks = element_blank(),
      axis.line = element_blank(),
      axis.text = element_blank(),
      #Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_blank(),
      #Blank background
      panel.background = element_blank(),
      panel.spacing = unit(3, "pt"),
      strip.background = element_rect(fill="white"),
      strip.text = element_text(
        family = base_family,
        size = rel(0.85),
        face = "bold",
        hjust = 0.5,
        vjust = 0.5,
        margin = margin(t=8, b=6)))+
    ggplot2::theme(...) # pour passer les arguments en plus
}

