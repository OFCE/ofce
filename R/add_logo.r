#' Logo de l'OFCE
#'
#' Ajoute le logo de l'OFCE sur le graphique
#'
#' @param size (1 par défaut) la taille relative du logo (1 c'est bien)
#'
#' @return un élément ggplot ( + )
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce() +
#'         logo_ofce()
#'}
logo_ofce <- function(size = 1, position = "bottom") {
  rlang::check_installed("magick", reason = "to add a logo inside")
  assertthat::assert_that(position%in%c("bottom", "top"), msg = "position doit être soit 'top' soit 'bottom'")
  if(position == "top") {
    x <- 1
    y <- 1
    just <- c(1,1)
  }
  if(position == "bottom") {
    x <- 1
    y <- 0
    just <- c(1,0)
  }
  logo <- ofce_logo |>
    magick::image_read() |>
    grid::rasterGrob(
      x = x, y = y,
      width = unit(0.075*size, "snpc"),
      height = unit(0.075*size/142*65, "snpc"),
      just = just) |>
    grid::pattern(
      extend = "none",
      gp = grid::gpar(fill = "transparent"))
  theme(plot.background = element_rect(fill = logo))
}

#' Add logo
#'
#' Ajoute le logo de l'OFCE sur le graphique (inside donc)
#'
#' Fin de vie. Ne plus utiliser
#'
#' @param plot un graphique ggplot
#' @param logo un logo au format png, avec une transparence (si NULL utilise le logo OFCE)
#' @param size la taille du logo (relative)
#'
#' @return un graphique ggplot
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce()
#' # plot |> add_logo()
#'}
add_logo <- function(plot, logo =  NULL, size = 0.25) {
  rlang::check_installed("ggpp", reason = "to add a logo inside")
  rlang::check_installed("magick", reason = "to add a logo inside")
  rlang::check_installed("grid", reason = "to add a logo inside")
  if(is.null(logo)) logo <- ofce_logo
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
#' \dontrun{
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce(base_family="Nunito")
#' # plot |> add_label_unit("horse power")
#'}
add_label_unit <- function(plot, ylabel="") {
  build <- ggplot2::ggplot_build(plot)
  pparams <- build$layout$panel_params
  y_break_max <- pparams[[1]]$y$get_breaks() |> max(na.rm=TRUE)
  if("ScaleContinuousDate" %in% class(pparams[[1]]$x$scale))
  {
    x_lim  <- lubridate::as_date(-Inf)
  }
  else
    x_lim <- -Inf

  axis_theme <- ggplot2::calc_element("axis.text.x", build$plot$theme)

  if(length(pparams)>1) {
    facet_data <- purrr::imap_dfc(build$layout$facet_params$facets,
                                  ~plot$data |> dplyr::transmute("{.y}":=eval(.x))) |>
      dplyr::distinct() |>
      dplyr::arrange(dplyr::across(dplyr::everything()))

    facet_data <- facet_data |>
      dplyr::mutate(label_unit = c(paste0("\u00A0",ylabel), rep("", nrow(facet_data)-1)))

    annotation <- ggplot2::geom_label(data = facet_data, ggplot2::aes(x=x_lim, y=y_break_max, label=label_unit),
                                      position = ggplot2::position_nudge(y=0),
                                      color = "grey25", label.size=0,
                                      fill=getOption("ofce.background_color"),
                                      family = axis_theme$family, size = axis_theme$size/.pt, fontface = axis_theme$face,
                                      hjust = 0, vjust = 0.5)
  }
  else
    annotation <- annotate2("label",label = paste0("\u00A0",ylabel), position = ggplot2::position_nudge(y=0),
                            x = x_lim, y = y_break_max, color = "grey25", label.size=0,
                            fill=getOption("ofce.background_color"),
                            family = axis_theme$family, size = axis_theme$size/.pt, fontface = axis_theme$face,
                            hjust = 0, vjust = 0.5)

  plot + annotation
}

