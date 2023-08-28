
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
      plot.title = element_text(
        size = base_size,
        family = base_family,
        face = "bold",
        hjust = 0,
        margin = margin(b=2.5, t=2.5),
        lineheight = 1.5),
      plot.subtitle =  element_text(
        size = rel(0.85),
        face = "plain",
        hjust = 0,
        margin = margin(b=2.5, t=2.5),
        lineheight = 1.2),
      plot.caption = element_text(
        size = rel(0.75),
        color = "gray25",
        face="italic",
        hjust = 0,
        vjust = 0.5,
        margin = margin(b=0, t=12),
        lineheight=1),
      plot.margin = margin(b=8, t=8, l=2, r=2),
      plot.caption.position = "panel",
      #Legend format
      legend.position = "right",
      legend.justification= "center",
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
