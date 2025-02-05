#' theme OFCE
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' d'autres éléments de la norme comme les couleurs, l'allure générale du graphique
#' sont à introduire par ailleurs
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Open Sans"))
#' @param ... paramètres passés à \code{\link[ggplot2]{theme}()}
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @export
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit

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
        margin = ggplot2::margin(),
        lineheight = 1),
      axis.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "normal"),
        size = ggplot2::rel(0.85),
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=12, l=12),
        lineheight = 1),
      axis.text = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "normal"),
        size = ggplot2::rel(0.85),
        colour = "gray25",
        lineheight = 1),
      axis.text.y = marquee::element_marquee(
        hjust = 1,
        vjust=0),
      axis.text.x = marquee::element_marquee(
        margin = ggplot2::margin(t=3),
        hjust = 0.5),
      plot.subtitle = marquee::element_marquee(
        style = ofce_style,
        size = ggplot2::rel(0.85),
        hjust = 0,
        margin = ggplot2::margin(),
        lineheight = 1),
      plot.caption = marquee::element_marquee(
        style = marquee::modify_style(
          ofce_style, tag = "p",
          margin = marquee::trbl(2, 0, 0, 0)),
        size = ggplot2::rel(0.85),
        hjust = 0,
        margin = ggplot2::margin(t=6,b=6),
        width = 0.99),
      strip.text = marquee::element_marquee(
        style = ofce_style,
        size = ggplot2::rel(0.9),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6,b=6)),
      legend.title = marquee::element_marquee(
        size = ggplot2::rel(0.85),
        color = "gray25",
        margin = ggplot2::margin(r=12, b=6, t=6, l=6)),
      legend.text = ggplot2::element_text(
        size = ggplot2::rel(0.5),
        hjust=0.5,
        color = "gray25")
      )
  else
    ggplot2::theme(
      plot.title = ggtext::element_markdown(
        face = "bold",
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      axis.title  = ggplot2::element_text(
        size = ggplot2::rel(0.75),
        color = "#222222",
        margin = margin(t = 0, b=0, l= 0, r=0),
        hjust = 1),
      axis.text = ggplot2::element_text(
        family = base_family,
        size = ggplot2::rel(0.75)),
      axis.text.y = ggplot2::element_text(
        color = "gray25",
        hjust = 1,
        vjust=0),
      axis.text.x = ggplot2::element_text(
        color = "gray25",
        margin=margin(t=6, b=0),
        hjust = 0.5),
      plot.subtitle = ggtext::element_markdown(
        size = ggplot2::rel(0.85),
        hjust = 0,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      plot.caption = ggtext::element_markdown(
        size = ggplot2::rel(0.85),
        hjust = 0,
        margin = ggplot2::margin(l = 0, t = 6),
        lineheight = 1.25),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(0.9),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, b=6)),
      legend.text = ggplot2::element_text(
        size = ggplot2::rel(0.75),
        color = "gray25"),
      legend.title = ggplot2::element_text(
        size = ggplot2::rel(0.80),
        color = "gray25")
      )

  theme_foundation() +
    ggplot2::theme(
      text = ggplot2::element_text(
        family = base_family,
        size = base_size
      ),
      plot.background = ggplot2::element_rect(fill="white"),
      rect = ggplot2::element_rect(
        fill = NA,
        colour = NA,
        linetype = 0),

      plot.title.position = "panel",
      plot.margin = ggplot2::margin(b=6, t=6, l=2, r=2),
      plot.caption.position = "panel",
      # Legend format
      legend.justification= "center",
      legend.text.align = 0,
      legend.background = element_blank(),
      legend.location = "plot",
      legend.position = "bottom",
      legend.direction = "horizontal",
      legend.key.height = unit(9, "pt"),
      legend.key.width = unit(9, "pt"),
      legend.key.size = unit(9, "pt"),
      legend.spacing = unit(24, "pt"),
      legend.key.spacing = unit(1, "pt"),
      legend.margin = ggplot2::margin(t=6, r=0, b=6, l=0),
      legend.box.spacing = unit(6, "pt"),
      # #Axis format
      axis.ticks = element_line(
        color="gray25",
        size = unit(0.2, "pt")),
      axis.ticks.length.x = unit(-3,"pt"),
      axis.ticks.length.y = unit(-3,"pt"),
      axis.minor.ticks.length = rel(0.75),
      axis.line = element_line(
        colour = "gray40",
        size = unit(0.2, "pt"),
        lineend="round"),
      # Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(
        size = unit(0.1, "pt"),
        color = "gray80"),
      panel.grid.major.x = element_line(
        size = unit(0.1, "pt"),
        color = "gray80"),
      # Blank background
      panel.background = element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color")),
      panel.spacing = unit(3, "pt"),

      strip.background = element_rect(fill="white"))+
    theme_text +
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


theme_ofce_void <- function(base_size = getOption("ofce.base_size"),
                            base_family = getOption("ofce.base_family"),
                            marquee = FALSE, ...) {
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
        margin = ggplot2::margin(b=-6, t=0),
        lineheight = 1),
      plot.subtitle = marquee::element_marquee(
        style = ofce_style,
        size = ggplot2::rel(0.6),
        hjust = 0,
        margin = ggplot2::margin(b=0, t=-6),
        lineheight = 1),
      plot.caption = marquee::element_marquee(
        style = marquee::modify_style(
          ofce_style, tag = "p",
          margin = marquee::trbl(2, 0, 0, 0)),
        size = ggplot2::rel(0.75),
        hjust = 0,
        margin = margin(l = 0, t = 0),
        width = 0.8),
      strip.text = marquee::element_marquee(
        style = ofce_style,
        size = ggplot2::rel(0.85),
        hjust = 0.5,
        vjust = 0.5,
        margin = margin(t=6, b=6)))
  else
    ggplot2::theme(
      legend.text = ggplot2::element_text(
        size = ggplot2::rel(0.75),
        color = "gray25"),
      plot.title = ggtext::element_markdown(
        face = "bold",
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      plot.subtitle = ggplot2::element_text(
        size = ggplot2::rel(0.60),
        hjust = 0,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      plot.caption = ggtext::element_markdown(
        size = ggplot2::rel(0.80),
        hjust = 0,
        margin = ggplot2::margin(l = 0, t = 6),
        lineheight = 1.25),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(0.9),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, b=6)))

  theme_foundation() +
    ggplot2::theme(
      # general
      plot.background = ggplot2::element_rect(fill="white"),
      text = ggplot2::element_text(
        family=base_family,
        size = base_size),
      rect = ggplot2::element_rect(
        fill = NA,
        size = base_size,
        colour = NA,
        linetype = 0),
      plot.title.position = "panel",
      plot.margin = ggplot2::margin(b=2, t=2, l=2, r=2),
      plot.caption.position = "plot",
      #Legend format
      legend.position = "right",
      legend.justification= c(1,1),
      legend.text.align = 0,
      legend.background = ggplot2::element_blank(),
      legend.margin = ggplot2::margin(t=0, r=0, b=0, l=0),
      # #Axis format
      axis.title  = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      #Grid lines
      panel.grid = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      #Blank background
      panel.background = ggplot2::element_blank(),
      panel.spacing = ggplot2::unit(3, "pt"),
      strip.background = ggplot2::element_rect(fill="white"))+
    theme_text +
    ggplot2::theme(...) # pour passer les arguments en plus
}
