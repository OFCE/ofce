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
#' \dontrun{
#' library(ggplot2)
#' plot <- ggplot(mtcars) +
#'         geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
#'         theme_ofce(base_family="Nunito")
#' # plot |> add_logo_ofce_inside()
#'}
add_logo_ofce_inside <- function(plot, logo =  ofce_logo, size = 0.25) {
  rlang::check_installed("ggpp", reason = "to add a logo inside")
  rlang::check_installed("magick", reason = "to add a logo inside")
  rlang::check_installed("grid", reason = "to add a logo inside")
  grob <- grid::rasterGrob(logo, width=size, just = c("right", "bottom"))
  plot+ ggpp::annotate(geom = "grob_npc",
                       label=grob,
                       npcx=0.995, npcy=0, hjust=0.5, vjust=0.5)
}
