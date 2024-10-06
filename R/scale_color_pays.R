
#' Palette de couleur associée à un sous-ensemble de pays, compatible avec les normes graphiques de la revue OFCE
#'
#' @param lang chr, le choix de la langue c("fr","en")
#' @param list_iso3 chr, une liste de nom de pays
#' @param name titre de la légende
#' @param aesthetics couleur ou fill ou les deux
#' @param ... passé à scale_colour_manual
#'
#' @importFrom dplyr filter
#' @importFrom dplyr arrange
#' @importFrom dplyr mutate
#'
#' @return un scale configuré
#' @export
#'
#'
scale_color_pays <- function(list_iso3 = c("FRA", "ITA", "ESP", "DEU"),
                             lang = "fr", name = NULL, aesthetics= c("color", "fill"), ...) {

  dat <- ofce::palette_pays |>
    dplyr::filter(ISO3 %in% list_iso3) |>
    dplyr::arrange(match(.data[["ISO3"]], list_iso3))

  if(lang == "fr"){
    dat <- dat |> dplyr::mutate(label = .data[["label_fr"]])} else {
      if(lang == "en"){
        dat <- dat |> dplyr::mutate(label = .data[["label_en"]])} else {
          dat <- dat |> dplyr::mutate(label = .data[["ISO3"]])
          cat("Il n'existe pas de traduction pour la langue demandée. Seuls le français (\"fr\") et l'anglais (\"en\") sont pour l'instant proposés.")
          }
    }

  scale_colour_manual(values = dat$HEX,
                      breaks = dat$ISO3,
                      labels = dat$label,
                      name = name,
                      aesthetics = aesthetics,
                      ...)
}

