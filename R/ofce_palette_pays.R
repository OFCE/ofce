
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

  dat <- palette.ofce |>
    dplyr::filter(ISO %in% list_iso3) |>
    dplyr::arrange(match(ISO, list_iso3))

  return(rlang::set_names(dat$HEX, list_iso3))
}
