#' Palettes de couleur pour la norme de la revue OFCE
#'
#' @param ncolor integer, nombre de couleur
#'
#' @return une palette de couleur
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
