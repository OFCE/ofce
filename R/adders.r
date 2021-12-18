#' Add logo
#'
#' Ajoute le logo de l'OFCE en bas à droite du graphique
#'
#' @param plot un graphique ggplot
#' @param logo un logo au format png, avec une transparence
#' @param size la taille du logo (relative)
#'
#' @return un graphique ggplot
#' @export
#' @seealso add_logo_ofce_inside
#' @importFrom cowplot ggdraw draw_plot draw_image
#' @import magick
#' @examples
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'     geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'     theme_ofce(base_family="sans")
#' plot |> add_logo_ofce()
add_logo_ofce <- function(plot, logo = ofce_logo, size = 0.04) {
  cowplot::ggdraw() +
    cowplot::draw_plot(plot)+
    cowplot::draw_image(
      logo,
      x=0.99, y=0.01,
      width=size, height=size,
      hjust=1, vjust=0,
      valign = 0, halign = 1)
}

#' Add logo inside
#'
#' Ajoute le logo de l'OFCE sur le graphique (inside donc)
#'
#' @param plot un graphique ggplot
#' @param logo un logo au format png, avec une transparence
#' @param size la taille du logo (relative)
#'
#' @return un graphique ggplot
#' @export
#' @importFrom ggpp annotate
#' @importFrom grid rasterGrob
#' @importFrom magick image_read
#' @seealso add_logo_ofce
#' @examples
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce(base_family="sans")
#' plot |> add_logo_ofce_inside()
#'
add_logo_ofce_inside <- function(plot, logo =  ofce_logo, size = 0.15) {
  grob <- grid::rasterGrob(logo, width=size)
  plot+
    ggpp::annotate(geom="grob_npc",
                   label=grob,
                   npcx=0.885, npcy=0.11, hjust=0, vjust=1)
}

#' Add label unit
#'
#' Ajoute un label pour les unités sur le plus grand des labels y
#'
#' @param plot un graphique ggplot
#' @param ylabel string, un label
#'
#' @return un graphique ggplot
#' @export
#' @importFrom ggplot2 ggplot_build calc_element
#' @examples
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce(base_family="sans")
#' plot |> add_label_unit("horse power")
#'
add_label_unit <- function(plot, ylabel="") {
  build <- ggplot_build(plot)
  layout <- build$layout$layout
  selected <- layout[layout$ROW == 1 & layout$COL == 1, , drop = FALSE]
  y <- build$layout$panel_scales_y[[selected$SCALE_Y]]
  y_break_max <- y$get_breaks() |> max(na.rm=TRUE)
  axis_theme <- calc_element("axis.text.x", build$plot$theme)
  plot +
    annotate2("label",label = paste0("\u00A0",ylabel), position = position_nudge(y=0),
              x = -Inf, y = y_break_max, color = "grey25", label.size=0, fill="gray95",
              family = axis_theme$family, size = axis_theme$size/.pt, fontface = axis_theme$face,
              hjust = 0, vjust = 0.5)
}
