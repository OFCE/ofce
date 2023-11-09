#' Palette de cinq couleurs principales compatible avec les normes graphiques de la revue OFCE
#'
#' @param n number un nombre de couleurs à retenir pour la palette
#'
#' @return un vector de couleurs de taille compris entre 2 et 5
#' @export
#'
#' @examples
#' ofce_palette(n = 3)
ofce_palette <- function(n = 2) {
  if (n <= 2){
    # Bleu et rouge
    return(c("#005DA4","#C51315"))
  }
  if (n == 3){
    # Bleu, Jaune, Rouge, Vert
    return(c("#005DA4", "#F59C00", "#C51315"))
  }

  if (n == 4){
    # Bleu, Jaune, Rouge, Vert
    return(c("#005DA4", "#F59C00", "#C51315", "#008D36"))
  }

  if (n == 5){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#005DA4", "#F59C00", "#C51315", "#008D36", "#9900CC"))
  }
  if (n > 5){
    cat("Nombre de couleurs dépassent celles enregistrées: il vaudrait mieux utiliser les fonctions `ofce_palette_seq` ou `ofce_palette_div`\n")
  }
}
