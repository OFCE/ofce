#' theme OFCE
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' d'autres éléments de la norme comme les couleurs, l'allure générale du graphique
#' sont à introduire par ailleurs
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Open Sans"))
#' @param marquee (boléen) utilise marquee pour la plupart des textes dans un plot
#' @inheritDotParams ggplot2::theme
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @export
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit
#' @import marquee

theme_ofce <- function(base_size = getOption("ofce.base_size"),
                       base_family = getOption("ofce.base_family"),
                       marquee = getOption("ofce.marquee"), ...) {

 ofce_style <- marquee::classic_style(
    base_size = base_size,
    body_font = base_family,
    header_font = base_family,
    code_font = "Fira Code")

  theme_text <- if(marquee)
    ggplot2::theme(
      plot.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "bold"),
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b = 6),
        lineheight = 1),
      axis.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "normal"),
        size = ggplot2::rel(0.7),
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, r=6),
        lineheight = 1),
      plot.subtitle = marquee::element_marquee(
        style = marquee::modify_style(
          ofce_style, tag = "p",
          weight = "normal",
          padding = marquee::trbl(0, 0, 0, 0),
          margin = marquee::trbl(0, 0, 0, 0),
          lineheight = 0.9),
        size = ggplot2::rel(0.85),
        vjust = 0,
        hjust = 0,
        margin = ggplot2::margin(t = 6, b = 0)),
      plot.caption = marquee::element_marquee(
        style = marquee::modify_style(
          ofce_style, tag = "p",
          weight = "normal",
          align = "left-aligned",
          padding = marquee::trbl(3, 3, 3, 3),
          hanging = marquee::em(0.),
          margin = marquee::trbl(0, 0, 3, 0),
          lineheight = 0.9),
        size = ggplot2::rel(0.7),
        hjust = 0,
        margin = ggplot2::margin(t=9,b=3),
        width = 0.99),
      strip.text = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "normal"),
        size = ggplot2::rel(0.85),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6,b=3)),
      legend.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "normal"),
        size = ggplot2::rel(0.7),
        color = "gray25",
        margin = ggplot2::margin(r=3, b=0, t=0, l=3)),
      legend.text = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "normal"),
        size = ggplot2::rel(0.7),
        hjust=0,
        lineheight = 0.9,
        color = "gray25",
        margin = ggplot2::margin(r=3, b=0, t=0, l=1))
    )
  else
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        face = "bold",
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      axis.title  = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "#222222",
        margin = margin(t = 0, b=0, l= 0, r=0),
        hjust = 1),
      plot.subtitle = ggplot2::element_text(
        size = ggplot2::rel(0.85),
        hjust = 0,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      plot.caption = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        hjust = 0,
        margin = ggplot2::margin(l = 0, t = 6),
        lineheight = 1.25),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(0.85),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, b=6)),
      legend.text = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "gray25"),
      legend.title = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "gray25")
    )

    theme_text +
    ggplot2::theme(
      text = ggplot2::element_text(
        family = base_family,
        size = base_size
      ),
      axis.text = ggplot2::element_text(
        size = ggplot2::rel(0.75),
        colour = "gray25"),
      axis.text.y = ggplot2::element_text(
        hjust = 1,
        vjust=0,
        margin = ggplot2::margin(r=2, b=0)),
      axis.text.x = ggplot2::element_text(
        margin = ggplot2::margin(t=0, b=0),
        hjust = 0.5),
      plot.background = ggplot2::element_rect(fill="transparent"),
      rect = ggplot2::element_rect(
        fill = NA,
        colour = NA,
        linetype = 0),
      plot.title.position = "panel",
      plot.margin = ggplot2::margin(b=3, t=3, l=6, r=6),
      plot.caption.position = "panel",
      # Legend format
      # legend.text.align = 0,
      legend.background = element_blank(),
      legend.position = c(0.05, 0.95),
      legend.justification = c(0, 1),
      legend.direction = "vertical",
      legend.key.height = unit(9, "pt"),
      legend.key.width = unit(9, "pt"),
      legend.key.size = unit(9, "pt"),
      legend.key.spacing.x = unit(3, "pt"),
      legend.key.spacing.y = unit(1, "pt"),
      legend.margin = ggplot2::margin(t=0, r=0, b=0, l=0),
      legend.box.spacing = unit(3, "pt"),
      #Axis format
      axis.ticks = element_line(
        color="gray25",
        linewidth = unit(0.1, "pt")),
      axis.ticks.length.x = unit(3,"pt"),
      axis.ticks.length.y = unit(-2,"pt"),
      axis.minor.ticks.length = rel(0.5),
      axis.line = element_line(
        colour = "gray25",
        linewidth = unit(0.1, "pt"),
        lineend="round"),
      # Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(
        linewidth = unit(0.1, "pt"),
        color = "gray85"),
      panel.grid.major.x = element_line(
        linewidth = unit(0.1, "pt"),
        color = "gray85"),
      # Blank background
      panel.background = element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color")),
      panel.spacing = unit(3, "pt"),

      strip.background = element_rect(fill="white"))+
    ggplot2::theme(...) # pour passer les arguments en plus
}

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
#' @import marquee
#' @export


theme_ofce_void <- function(base_size = getOption("ofce.base_size"),
                            base_family = getOption("ofce.base_family"),
                            marquee = getOption("ofce.marquee"), ...) {
  theme_ofce(base_size = base_size,
             base_family = base_family,
             marquee = marquee,
             ...) +
    theme(
      legend.background = element_blank(),
      axis.title  = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      #Blank background
      panel.background = ggplot2::element_blank())}
