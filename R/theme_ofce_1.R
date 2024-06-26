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

theme_ofce <- function(base_size = getOption("ofce.base_size"),
                       base_family = getOption("ofce.base_family"), ...) {

  ofce_style <- marquee::classic_style(
    base_size = base_size,
    body_font = base_family,
    header_font = base_family,
    code_font = "Fira Code")

  ggplot2::theme(
    # general
    plot.background = ggplot2::element_rect(fill="white"),

    rect = ggplot2::element_rect(
      fill = NA,
      colour = NA,
      linetype = 0),
    # Text format:
    text = ggplot2::element_text(
      family = base_family,
      size = base_size
    ),
    plot.title.position = "panel",
    plot.title = marquee::element_marquee(
      style = marquee::modify_style(ofce_style, tag = "base", weight = "bold"),
      hjust = 0,
      vjust = 0.5,
      margin = ggplot2::margin(b=-6, t=0),
      lineheight = 1),
    plot.subtitle = marquee::element_marquee(
      style = ofce_style,
      size = ggplot2::rel(0.75),
      hjust = 0,
      margin = ggplot2::margin(b=0, t=-6),
      lineheight = 1),
    plot.margin = ggplot2::margin(b=2, t=2, l=2, r=2),
    plot.caption.position = "panel",
    plot.caption = marquee::element_marquee(
      style = ofce_style,
      size = ggplot2::rel(0.75),
      hjust = 0,
      margin = margin(l = 0, t= 9),
      width = 0.9),

    # Legend format
    legend.justification= "center",
    legend.text.align = 0,
    legend.title = ggplot2::element_text(
      size = ggplot2::rel(0.75),
      color = "gray25"),
    legend.background = element_blank(),
    legend.text = ggplot2::element_text(
      size = ggplot2::rel(0.75),
      color = "gray25"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.key.height = unit(9, "pt"),
    legend.key.width = unit(9, "pt"),
    legend.key.size = unit(9, "pt"),
    legend.margin = ggplot2::margin(t=-12, r=0, b=0, l=0),
    # #Axis format
    axis.title  = ggplot2::element_text(
      size = ggplot2::rel(0.75),
      color = "#222222",
      margin = margin(t = 0, b=0, l= 0, r=0)),
    axis.title.x = element_text(hjust=1),
    axis.title.y = element_text(hjust=1),
    axis.text = ggplot2::element_text(
      family = base_family,
      size = ggplot2::rel(0.75)),
    axis.text.y = ggplot2::element_text(
      color = "gray25",
      hjust = 1,
      vjust=0.5),
    axis.text.x = ggplot2::element_text(
      color = "gray25",
      margin=margin(t=3, b=0),
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
    # Grid lines
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(
      size = unit(0.1, "pt"),
      color = "gray80"),
    panel.grid.major.x = element_blank(),
    # Blank background
    panel.background = element_rect(
      fill = getOption("ofce.background_color"),
      colour = getOption("ofce.background_color")),
    panel.spacing = unit(3, "pt"),
    # strip.text = marquee::element_marquee(
    #   size = ggplot2::rel(0.85),
    #   hjust = 0.5,
    #   vjust = 0.5,
    #   margin = margin(t=8, b=6)),
    strip.background = element_rect(fill="white"))+
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
      plot.title.position = "panel",
      plot.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = "bold"),
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b=-6, t=0),
        lineheight = 1),
      plot.subtitle = marquee::element_marquee(
        style = ofce_style,
        size = ggplot2::rel(0.75),
        hjust = 0,
        margin = ggplot2::margin(b=0, t=-6),
        lineheight = 1),
      plot.margin = ggplot2::margin(b=2, t=2, l=2, r=2),
      plot.caption = marquee::element_marquee(
        style = ofce_style,
        size = ggplot2::rel(0.75),
        hjust = 0,
        margin = margin(l = 0, t= 9),
        width = 0.9),

      plot.caption.position = "plot",
      #Legend format
      legend.position = "right",
      legend.justification= c(1,1),
      legend.text.align = 0,
      legend.title = element_text(
        face = "plain",
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
      panel.grid = element_blank(),
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

