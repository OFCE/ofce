#' Palette de cinq couleurs principales compatible avec les normes graphiques de la revue OFCE
#'
#' @param n number un nombre de couleurs à retenir pour la palette
#'
#' @return un vector de couleurs de taille compris entre 2 et 5
#' @export
#'
#' @examples
#' ofce_palette(n = 2)
ofce_palette <- function(n = 2) {
  if (n <= 2){
    # Bleu et rouge
    return(c("#185CA1","#D40F14"))
  }
  if (n == 3){
    # Bleu, Jaune, Rouge, Vert
    return(c("#185CA1","#D40F14", "#D3A170"))
  }

  if (n == 4){
    # Bleu, Jaune, Rouge, Vert
    return(c("#185CA1","#D3A170", "#D40F14", "#008D36"))
  }

  if (n == 5){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#185CA1","#D3A170", "#EB5B25", "#008D36","#D40F14"))
  }

  if (n == 6){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#185CA1","#D3A170", "#EB5B25", "#008D36","#D40F14","#7B4F7A"))
  }
  if (n == 7){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#4EA6DA","#185CA1","#D3A170","#81600B",  "#008D36","#D40F14","#7B4F7A"))
  }

  if (n == 8){
    # Bleu, Jaune, Rouge, Vert, Violet
    return(c("#4EA6DA","#185CA1","#D3A170","#81600B",  "#008D36","#D40F14","#7B4F7A","#EB5B25"))
  }
  if (n > 8){
    cat("Nombre de couleurs dépassent celles enregistrées: il vaudrait mieux utiliser les fonctions `ofce_palette_seq` ou `ofce_palette_div`\n")
  }
}
