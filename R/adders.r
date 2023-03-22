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
#' @examples
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'     geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'     theme_ofce(base_family="sans")
#' # plot |> add_logo_ofce()
add_logo_ofce <- function(plot, logo = ofce_logo, size = 0.04) {
  rlang::check_installed("cowplot", reason = "to add a logo")
  rlang::check_installed("magick", reason = "to add a logo inside")
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
#' @seealso add_logo_ofce
#' @examples
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce(base_family="sans")
#' # plot |> add_logo_ofce_inside()
#'
add_logo_ofce_inside <- function(plot, logo =  ofce_logo, size = 0.25) {
  rlang::check_installed("ggpp", reason = "to add a logo inside")
  rlang::check_installed("magick", reason = "to add a logo inside")
  rlang::check_installed("grid", reason = "to add a logo inside")
  grob <- grid::rasterGrob(logo, width=size, just = c("right", "bottom"))
  plot+ ggpp::annotate(geom = "grob_npc",
                       label=grob,
                       npcx=0.995, npcy=0, hjust=0.5, vjust=0.5)
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
#' # plot |> add_label_unit("horse power")
#'
add_label_unit <- function(plot, ylabel="") {
  build <- ggplot_build(plot)
  pparams <- build$layout$panel_params
  y_break_max <- pparams[[1]]$y$get_breaks() |> max(na.rm=TRUE)
  if("ScaleContinuousDate" %in% class(pparams[[1]]$x$scale))
  {
    x_lim  <- lubridate::as_date(-Inf)
  }
  else
    x_lim <- -Inf

  axis_theme <- calc_element("axis.text.x", build$plot$theme)

  if(length(pparams)>1) {
    facet_data <- purrr::imap_dfc(build$layout$facet_params$facets,
                                  ~plot$data |> dplyr::transmute("{.y}":=eval(.x))) |>
      dplyr::distinct() |>
      dplyr::arrange(dplyr::across(dplyr::everything()))

    facet_data <- facet_data |>
      dplyr::mutate(label_unit = c(paste0("\u00A0",ylabel), rep("", nrow(facet_data)-1)))

    annotation <- ggplot2::geom_label(data = facet_data, aes(x=x_lim, y=y_break_max, label=label_unit),
                                      position = position_nudge(y=0),
                                      color = "grey25", label.size=0,
                                      fill=getOption("ofce.background_color"),
                                      family = axis_theme$family, size = axis_theme$size/.pt, fontface = axis_theme$face,
                                      hjust = 0, vjust = 0.5)
  }
  else
    annotation <- annotate2("label",label = paste0("\u00A0",ylabel), position = position_nudge(y=0),
                            x = x_lim, y = y_break_max, color = "grey25", label.size=0,
                            fill=getOption("ofce.background_color"),
                            family = axis_theme$family, size = axis_theme$size/.pt, fontface = axis_theme$face,
                            hjust = 0, vjust = 0.5)

  plot + annotation
}
