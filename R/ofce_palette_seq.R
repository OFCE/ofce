


#' Palette de couleurs associée de type sequentiel qui à partir de deux codes HEX génère une palette de n couleur compatible avec les normes graphiques de la revue OFCE
#'
#' @param colors vecteur de deux couleurs à partir duquel la palette est générée
#' @param n integer, nombre de couleurs
#'
#' @import colorspace farver
#' @return une palette de couleurs (format HEX)
#' @export
#'
ofce_palette_seq <- function(colors = c("#005DA4", "#C51315"),
                             n = NULL)
{
  # Colors of refere
  hex_1 = colors[1]
  hex_2 = colors[2]

  # Number of colors
  if (is.null(n)){ n = 6}

  pal <- colorspace::sequential_hcl(n = n, h = c(farver::decode_colour(hex_1, to = "hcl")[1], farver::decode_colour(hex_2, to = "hcl")[1]),
                                    c = c(farver::decode_colour(hex_1, to = "hcl")[2], NA, farver::decode_colour(hex_2, to = "hcl")[2]),
                                    l = c(farver::decode_colour(hex_1, to = "hcl")[3], farver::decode_colour(hex_2, to = "hcl")[3]),
                                    power = c(0.7, 1.3))




  return(pal)
}
