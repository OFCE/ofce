#' Enregistre un graphe en png à la taille revue
#'
#' Enregistrement d'un graphique avec une taille par défaut de 18 cm de large et un ratio de 4/3
#' Les paramètres peuvent être facilement modifiés. Le propblème de la résolution est résolu (dsl)
#' en utilisant {showtext}.
#'
#' @param graph un objet graphique (grid, un ggplot plus communément mais aussi un objet tmap)
#' @param file Le chemin vers le fichier résultat (string)
#' @param rep le répertoire dans lequel on met les graphiques
#' @param ratio le ratio entre largeur et hauteur
#' @param height la hauteur, si la hauteur est spécifiée la ratio est ignoré
#' @param width la largeur
#' @param units l'unité ("cm" par exemple)
#' @param bg couleur du fond (background)
#' @param dpi résolution du fichier image crée (par défault 600)
#' @param ... autres arguments à passer dans la fonction
#'
#' @return l'objet en entrée, invisible, enregistre un .png dan le répertoire avec le nom donné
#' @export
#'

graph2png <- function(graph, file="", rep="svg",
                      ratio = 4/3,
                      height = width/ratio,
                      width = 18,
                      units="cm",
                      bg="white",
                      dpi=600, ...)
{
  if(!requireNamespace("showtext", quietly = TRUE))
    showtext = FALSE
  if(rep!="")
    dir.create(rep, recursive=TRUE, showWarnings = FALSE)
  fn <- make_filename(rlang::as_name(rlang::enquo(graph)),
                      file,
                      rep,
                      parent.frame(), "png")

  cl <- dplyr::case_when(
    "gg" %in% class(graph) ~ "gg",
    "ggplot" %in% class(graph) ~ "gg",
    "tmap" %in% class(graph) ~ "tmap",
    TRUE ~ "err")
  switch(cl,
         gg = ggplot2::st_ggsave(
           filename=fn,
           device = ragg::agg_png,
           plot=graph,
           height = height,
           width = width,
           units=units,
           bg=bg,
           dpi=dpi,
           showtext=TRUE, ...),
         tmap = tmap::tmap_save(
           filename=fn,
           tm=graph,
           height = height,
           width = width,
           units=units,
           bg=bg,
           dpi=dpi, ...),
         err = message("save not implemented"))
  invisible(graph)
}


# non exporté
# from ggplot2

st_ggsave <- function (filename, plot = ggplot2::last_plot(), device = NULL, path = NULL,
                       scale = 1, width = NA, height = NA,
                       units = c("in", "cm","mm", "px"),
                       dpi = 300, limitsize = TRUE, bg = NULL,
                       showtext=FALSE,
                       ...)
{
  dpi <- ggplot2:::parse_dpi(dpi)
  dev <- ggplot2:::plot_dev(device, filename, dpi = dpi)
  dim <- ggplot2:::plot_dim(c(width, height), scale = scale, units = units,
                            limitsize = limitsize, dpi = dpi)
  if (!is.null(path)) {
    filename <- file.path(path, filename)
  }
  if (is.null(bg)) {
    bbg <- if(is.null(ggplot2:::plot_theme(plot)$fill))
      "transparent"
    else
      ggplot2:::plot_theme(plot)$fill
    bg <- ggplot2:::calc_element("plot.background", bbg)
  }
  old_dev <- grDevices::dev.cur()
  dev(filename = filename, width = dim[1], height = dim[2],
      bg = bg, ...)
  if(showtext) {
    opts <- showtext::showtext_opts()
    showtext::showtext_opts(dpi=dpi)
    showtext::showtext_begin()
  }
  on.exit(utils::capture.output({
    if(showtext) {
      showtext::showtext_end()
      showtext::showtext_opts(opts)
    }
    grDevices::dev.off()
    if (old_dev > 1) grDevices::dev.set(old_dev)
  }))
  grid::grid.draw(plot)
  invisible(filename)
}
