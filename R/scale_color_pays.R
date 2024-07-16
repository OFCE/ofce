
#' Palette de couleur associée à un sous-ensemble de pays, compatible avec les normes graphiques de la revue OFCE
#'
#' @param lang
#' @param list_iso3 chr, une liste de nom de pays
#'
#' @importFrom dplyr filter
#' @importFrom dplyr arrange
#' @importFrom dplyr mutate
#' @importFrom purrr set_names
#'
#' @return une palette de couleur (format HEX)
#' @export a scale_color
#'
#'
#'
scale_color_pays <- function(list_iso3 = NULL,
                             lang = NULL) {

  load("data/palette_pays.rda")

  if (is.null(list_iso3)){list_iso3 = c("FRA", "ITA")}
  if (is.null(lang)){lang = "fr"}

  dat <- palette_pays |>
    dplyr::filter(ISO3 %in% list_iso3) |>
    dplyr::arrange(match(ISO3, list_iso3))

  if(lang == "fr"){

    dat <- dat |> dplyr::mutate(label = label_fr)} else {

      if(lang == "en"){

        dat <- dat |> dplyr::mutate(label = label_en)} else {

          dat <- dat |> dplyr::mutate(label = ISO3)}

      cat("Il n'existe pas de traduction pour la langue demandée. Seuls le français (\"fr\") et l'anglais (\"en\") sont pour l'instant proposés.")

    }

  scale_colour_manual(values = dat$HEX,
                      breaks = dat$ISO3,
                      labels = dat$label)


}

