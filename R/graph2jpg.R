

#' Enregistre un graphe en jpg à la taille revue
#'
#' Enregistrement d'un graphique avec une taille par défaut de 18 cm de large et un ratio de 4/3
#' Les paramètres peuvent être facilement modifiés
#'
#' @param graph un objet graphique (grid, un ggplot plus communément mais aussi un objet tmap)
#' @param file Le chemin vers le fichier résultat (string)
#' @param rep le répertoire dans lequel on met les graphiques
#' @param ratio le ratio entre largeu
#' r et hauteur
#' @param height la hauteur, si la hauteur est spécifiée la ratio est ignoré
#' @param width la largeur
#' @param units l'unité ("cm" par exemple)
#' @param bg couleur du fond (background)
#' @param quality qualité du fichier (par défault 100)
#' @param dpi résolution du fichier image crée (par défault 600)
#' @param ... autres arguments à passer dans la fonction
#'
#' @return l'objet en entrée, invisible, enregistre un .jpeg dan le répertoire avec le nom donné
#' @export
#'

graph2jpg <- function(graph,
                      file="",
                      rep="svg",
                      ratio = 4/3,
                      height = width/ratio,
                      width = 18,
                      units="cm",
                      bg="white",
                      quality = 100,
                      dpi = 600,
                      ...)
{
  file <- glue::glue(file)
  rep <- glue::glue(rep)
  if(rep!="")
    dir.create(rep, recursive=TRUE, showWarnings = FALSE)
  fn <- make_filename(rlang::as_name(rlang::enquo(graph)), file, rep, parent.frame(), "jpg")

  cl <- dplyr::case_when(
    "gg" %in% class(graph) ~ "gg",
    "ggplot" %in% class(graph) ~ "gg",
    "tmap" %in% class(graph) ~ "tmap",
    TRUE ~ "err")
  switch(cl,
         gg = ggplot2::st_ggsave(filename=fn, device = ragg::agg_jpeg, plot=graph,
                        height = height, width = width, units=units,
                        quality=quality, bg=bg, dpi=dpi, showtext = TRUE, ...),
         tmap = tmap::tmap_save(filename=fn, tm=graph, height = height, width = width, units=units, quality=quality, bg=bg, ...),
         err = message("save not implemented"))
  invisible(graph)
}

# fonction pour fabriquer le nom du fichier
make_filename <- function(x, file="", rep="", env, ext)
{
  if(file=="") {
    file <- x
  }
  else
    file <- glue::glue(file, .envir = env)
  if(rep!="")
    rep <- stringr::str_c(glue::glue(rep, .envir = env), "/")
  stringr::str_c(rep, file, ".", ext)
}
