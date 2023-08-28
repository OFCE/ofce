#' OFCE palette principale
#'
#' @param n number un nombre de couleurs à retenir pour la palette
#'
#' @return un vector de couleurs de taille compris entre 2 et 5
#' @export
#'
#' @examples
#' ofce_palette_main(n = 3)
ofce_palette_main <- function(n = 2) {
  if (n <= 2){
    # Bleu et rouge
    return(c("#005DA4","#C51315"))
  }
  if (n == 3){
    # Bleu, Jaune, Rouge, Vert
    return(c("#005DA4", "#F59C00", "#C51315"))
  }

  if (n >= 4){
    # Bleu, Jaune, Rouge, Vert
    return(c("#005DA4", "#F59C00", "#C51315", "#008D36"))
  }

  if (n >= 5){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#005DA4", "#F59C00", "#C51315", "#008D36", "#9900CC"))
  }
}
