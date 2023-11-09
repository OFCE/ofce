#' Thème OFCE 2
#'
#' Applique le theme ofce compatible avec la norme des working papers
#' d'autres éléments de la norme comme les couleurs, l'allure générale du graphique
#' sont à introduire par ailleurs
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Nunito"))
#' @param ... paramètres passés à \code{\link[ggplot2]{theme}()}
#'
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit rel
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @export

#'
#'
theme_ofce.2 <- function(base_size = getOption("ofce.base_size"),
                       base_family = getOption("ofce.base_family"),
                       ...) {

if(requireNamespace("ggh4x", quietly = TRUE))
  ggh4xdef <-  ggplot2::theme(ggh4x.axis.ticks.length.minor = rel(0.66))
else
  ggh4xdef <- NULL
  theme_foundation() +
    ggplot2::theme(
      # general
      plot.background = element_rect(fill="#ffffff"),
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
        face = "plain",
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
        color = "#f5ede1",
        face="italic",
        hjust = 0,
        vjust = 0.5,
        margin = margin(b=0, t=12),
        lineheight=1),
      plot.margin = margin(b=8, t=8, l=2, r=10),
      plot.caption.position = "panel",
      #Legend format
      legend.position = "right",
      legend.justification= "center",
      legend.text.align = 0,
      legend.title = element_text(
        face = "plain",
        size = rel(0.85),
        color = "#C51315"),
      legend.background = element_blank(),
      legend.text = element_text(
        face = "plain",
        size = rel(0.75),
        color = "#C51315"),
      legend.margin = margin(t=0, r=0, b=0, l=0),
      # #Axis format
      axis.title  = element_text(
        size = rel(1.25),
        #face = "bold",
        color = "#C51315"),
      axis.text = element_text(
        size = rel(1.25),
        color = "#C51315"),
      axis.text.y = element_text(
        color = "#C51315",
        face = "bold",
        margin=margin(r=5, b=0, t=0, l=1.5),
        hjust = 1,
        vjust=0.5),
      axis.text.x = element_text(
        color = "#C51315",
        face = "bold",
        margin=margin(t=4, b=0),
        hjust = 0.5),
      axis.ticks = element_line(
        color="#C51315",
        size = unit(0.5, "pt")),
      axis.ticks.length.x = unit(-4,"pt"),
      axis.ticks.length.y = unit(-4,"pt"),
      axis.line = element_line(
        colour = "#C51315",
        size = unit(0.3, "pt"),
        lineend="round"),
      #Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(
        size = unit(0.1, "pt"),
        color = "#d04243"),
      panel.grid.major.x = element_blank(),
      #Blank background
      panel.background = element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color")),
      panel.spacing = unit(3, "pt"),
      strip.background = element_rect(fill="darkgray"),
      strip.text = element_text(
        size = rel(0.85),
        #face = "bold",
        hjust = 0.5,
        vjust = 0.5,
        margin = margin(t=8, b=6)))
}
