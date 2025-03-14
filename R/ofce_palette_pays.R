
#' Palette de couleur associée à un sous-ensemble de pays, compatible avec les normes graphiques de la revue OFCE
#'
#' @param list_iso3 chr, une liste de nom de pays
#' @param HEX boolean (by default) set TRUE to have the color code in HEX
#' @param RVB boolean set TRUE to have the color code in RVB
#' @importFrom dplyr filter
#' @importFrom dplyr arrange
#' @importFrom purrr set_names
#'
#' @return une palette de couleur (format HEX)
#' @export
#'
#'
#'
ofce_palette_pays <- function(list_iso3 = NULL,
                              HEX = NULL,
                              RVB = NULL) {

  if (is.null(list_iso3)){list_iso3 = c("FRA", "ITA")}

  if (is.null(HEX)){HEX = TRUE}
  if (is.null(RVB)){RGB = FALSE}
  if (isTRUE(RVB)){HEX = FALSE}

  dat <- ofce::palette_pays |>
    dplyr::filter(ISO3 %in% list_iso3) |>
    dplyr::arrange(match(ISO3, list_iso3))

  ## HEX = TRUE
  if (isTRUE(HEX)){
    return(rlang::set_names(dat$HEX, list_iso3))
  } else
  {
    ## RGB = TRUE
    if (isTRUE(RGB)){
      return(purrr::set_names(dat$`R-V-B`, list_iso3))
    }
  }
}
