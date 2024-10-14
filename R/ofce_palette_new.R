c("#80A1C1FF", "#C94277FF", "#EEE3ABFF", "#274C77FF", "#5E8C61FF")

#' Palette de cinq couleurs principales compatible avec les normes graphiques de la revue OFCE
#'
#' @param set choix du jeu de couleurs qui va être retenu
#'
#' @return un vector de couleurs de taille compris entre 2 et 5
#' @export
#'
#' @examples
#' ofce_palette(n = 2)
ofce_palette_new <- function(set = NULL) {

  if (is.null(set)){set =1 }

  if (set == 1){return(c("#80A1C1FF", "#C94277FF", "#ffe45c", "#274C77FF", "#5E8C61FF"))
    } else {
    if (set == 2){ return(c("#413C58" , "#D1495B", "#EDAE49" , "#00798C", "#003D5B")) }
  }

}

