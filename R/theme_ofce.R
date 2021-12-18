#' Thème OFCE
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' d'autres éléments de la norme comme les couleurs, l'allure générale du graphique
#' sont à introduire par ailleurs
#'
#' @param base_size double(1) Taille des éléments texte du thème
#' @param base_family character(1) string, police de charactère du thème (Stone sans par défaut)
#'
#' @return un thème qui peut être utilisé dans ggplot
#' @importFrom ggplot2 theme element_text element_rect element_blank element_line margin unit theme_grey rel
#' @family themes
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mtcars) +
#'     geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'     theme_ofce(base_family="sans")


theme_ofce <- function(base_size = 12, base_family = "Stone sans") {
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
        margin = margin(b=2.5, t=2.5)),
      plot.subtitle =  element_text(
        size = rel(0.75),
        face = "plain",
        hjust = 0,
        margin = margin(b=2.5, t=2.5)),
      plot.caption = element_text(
        size = rel(0.6666),
        color = "gray25",
        face="italic",
        hjust = 0,
        margin=margin(b=0, t=0)),
      plot.margin = margin(b=2.5, t=2.5, l=2.5, r=2.5),
      plot.caption.position = "panel",
      panel.spacing = margin(b=0, t=0, r=0, l = 0),
      #Legend format
      legend.position = "bottom",
      legend.justification= "center",
      legend.text.align = 0,
      legend.title = element_text(
        face = "bold",
        size = rel(0.75),
        color = "gray25"),
      legend.background = element_blank(),
      legend.text = element_text(
        face = "bold",
        size = rel(0.75),
        color = "gray25"),
      legend.margin = margin(t=0, r=0, b=0, l=0),
      # #Axis format
      axis.title  = element_text(
        size = rel(0.75),
        color = "#222222"),
      axis.text = element_text(
        size = rel(0.75),
        color = "#222222"),
      axis.text.y = element_text(
        color = "gray25",
        margin=margin(r=1.5, b=0, t=0, l=0),
        hjust = 1,
        vjust=0.5),
      axis.text.x = element_text(
        color = "gray25",
        margin=margin(t=2.5, b=0)),
      axis.ticks = element_line(
        color="gray50",
        size = unit(0.3, "pt")),
      axis.ticks.length.x = unit(4,"pt"),
      axis.ticks.length.y = unit(2.5,"pt"),
      axis.line = element_line(
        colour = "gray40",
        size = unit(0.5, "pt"),
        lineend="round"),
      #Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(
        size = unit(0.25, "pt"),
        color = "gray80"),
      panel.grid.major.x = element_blank(),
      # #Blank background
      panel.background = element_rect(
        fill = "gray95",
        colour = "gray95"),
      strip.background = element_rect(fill="white"),
      strip.text = element_text(
        size = rel(0.333),  hjust = 0.5)
    )

}

#' Theme foundation
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. \code{theme_foundation()}
#' is a complete theme with only minimal number of elements defined.
#' It is easier to create new themes by extending this one rather
#' than \code{\link[ggplot2]{theme_gray}()} or \code{\link[ggplot2]{theme_bw}()},
#' because those themes define elements deep in the hierarchy.
#'
#' This theme takes \code{\link[ggplot2]{theme_gray}()} and sets all
#' \code{colour} and \code{fill} values to \code{NULL}, except for the top-level
#' elements (\code{line}, \code{rect}, and \code{title}), which have
#' \code{colour = "black"}, and \code{fill = "white"}. This leaves the spacing
#' and-non colour defaults of the default \pkg{ggplot2} themes in place.
#'
#' @inheritParams ggplot2::theme_grey
#'
#' @family themes
#' @export
#' @importFrom ggplot2 theme_grey element_text element_line element_rect
theme_foundation <- function(base_size=12, base_family="") {
  thm <- theme_grey(base_size = base_size, base_family = base_family)
  for (i in names(thm)) {
    if ("colour" %in% names(thm[[i]])) {
      thm[[i]]["colour"] <- list(NULL)
    }
    if ("fill" %in% names(thm[[i]])) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm + theme(panel.border = element_rect(fill = NA),
              legend.background = element_rect(colour = NA),
              line = element_line(colour = "black"),
              rect = element_rect(fill = "white", colour = "black"),
              text = element_text(colour = "black"))
}

