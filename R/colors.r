#' couleur pays de la charte graphique de l'OFCE
#'
#' Un dataset contenant les codes iso3 pour un ensemble de pays associés à un code couleur.
#'
#' @format Un dataframe avec 19 observations de 2 variables:
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
ofce_palette_main <- function(ncolor=2) {
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



#' Palette de couleur associée de type sequentiel compatible avec les normes graphiques de la revue OFCE
#'
#'
#' @param colors vecteur de deux couleurs à partir duquel la palette est générée
#' @param n integer, nombres de couleurs
#'
#' @return une palette de couleurs (format HEX)
#' @export
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

#' Palette de couleur associée de type sequentiel compatible avec les normes graphiques de la revue OFCE qui à partir de valeurs HEX produit une palette de n couleurs.
#'
#' @param colors vecteur de deux couleurs à partir duquel la palette est générée
#' @param n integer, de couleurs
#'
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

  pal <- colorspace::sequential_hcl(n = 7, h = c(farver::decode_colour(hex_1, to = "hcl")[1], farver::decode_colour(hex_2, to = "hcl")[1]),
                        c = c(farver::decode_colour(hex_1, to = "hcl")[2], NA, farver::decode_colour(hex_2, to = "hcl")[2]),
                        l = c(farver::decode_colour(hex_1, to = "hcl")[3], farver::decode_colour(hex_2, to = "hcl")[3]),
                        power = c(0.7, 1.3))




  return(pal)
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
