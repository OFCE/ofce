#' Palettes de couleurs pour la norme de la revue OFCE
#'
#' @param ncolor integer, nombre de couleurs
#'
#' @return une palette de couleurs (format HEX)
#' @export
#'
ofce_palette <- function(ncolor=2) {
  if (ncolor<=2){
    # Bleu et rouge
    return(c("#005DA4","#C51315"))
  }
  if (ncolor==3){
    # Bleu, Jaune, Rouge, Vert
    return(c("#005DA4", "#F59C00", "#C51315"))
  }

  if (ncolor>=4){
    # Bleu, Jaune, Rouge, Vert
    return(c("#005DA4", "#F59C00", "#C51315", "#008D36"))
  }

    if (ncolor>=5){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#005DA4", "#F59C00", "#C51315", "#008D36", "#9900CC"))
  }
}

#' Palettes de couleur associées aux pays pour la norme de la revue OFCE
#'
#' @param list_iso3 chr, une liste de nom de pays
#'
#' @return une palette de couleur (format HEX)
#' @export
#'
#'
ofce_palette_pays <- function(list_iso3 = list_iso.full) {

  list_iso.full <- read.csv("work/palette/palette_OFCE.csv", sep = ";")[["ISO"]]

  dat <- read.csv("work/palette/palette_OFCE.csv", sep = ";") |>
    dplyr::filter(ISO %in% list_iso3) |>
    dplyr::arrange(match(ISO, list_iso3))

  return(dat$HEX)
}
