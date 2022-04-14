#' couleur pays de la charte graphique de l'OFCE
#'
#' Un dataset contenant les codes iso3 pour un ensemble de pays associés à un code couleur.
#'
#' @format Un dataframe avec 19 observations  and 2 variable:
#' \describe{
#'   \item{nom}{label, en français}
#'   \item{ISO}{le code iso, en 3 charactères}
#'   ...
#' }
#'
"palette.ofce"

#' Palettes de couleurs pour la norme de la revue OFCE
#'
#' @param ncolor integer, nombre de couleurs
#'
#' @return une palette de couleurs (format HEX)
#' @export
#'
#'
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

#' Palette de couleur associée à un sous-ensemble de pays, compatible avec les normes graphiques de la revue OFCE
#'
#' @param list_iso3 chr, une liste de nom de pays
#'
#' @return une palette de couleur (format HEX)
#' @export
#'
#'
#'
ofce_palette_pays <- function(list_iso3 = palette.ofce$ISO) {

  dat <- palette.ofce|>
    dplyr::filter(ISO %in% list_iso3) |>
    dplyr::arrange(match(ISO, list_iso3))

  return(rlang::set_names(dat$HEX, list_iso3))
}
