#' Palette de couleurs associée de type divergente qui à partir de deux codes HEX génère une palette de n couleurs compatible avec les normes graphiques de la revue OFCE
#'
#' @param colors un vecteur de deux couleurs à partir duquel la palette est générée.
#' @param n integer, nombre de couleurs
#'
#' @return un vecteur de couleurs de taille n
#' @export
#'
#' @examples
#' ofce_palette_div(n = 4)
#'
ofce_palette_div <- function(colors = c("#005DA4", "#C51315"),
                             n = NULL)

{
  # Colors of refere
  hex_1 = colors[1]
  hex_2 = colors[2]
  # Number of colors
  if (is.null(n)){ n = 6}

  pal <- colorspace::diverging_hcl(n = n,
                                   h = c(farver::decode_colour(hex_1, to = "hcl")[1], farver::decode_colour(hex_2, to = "hcl")[1]),
                                   c = c(farver::decode_colour(hex_1, to = "hcl")[2], farver::decode_colour(hex_2, to = "hcl")[2]),
                                   l = c(farver::decode_colour(hex_1, to = "hcl")[3], farver::decode_colour(hex_2, to = "hcl")[3]),
                                   power = c(1, 1.3))


  return(pal)
}
