
#' Palette de couleur associée à un sous-ensemble de pays, compatible avec les normes graphiques de la revue OFCE
#'
#' @param lang chr, le choix de la langue c("fr","en")
#' @param format chr, le format des données ("iso3", "eurostat", "fr" pour les noms en clair, et tous les codes qu'accepte countrycode::countrycode)
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
scale_color_pays <- function(format = NULL,
                             lang = "fr", name = NULL, aesthetics= c("color", "fill"), ...) {

  format <- case_match( format,
                        "iso3" ~ "iso3c",
                        "iso2" ~ "iso2c",
                        "fr" ~ "country.name.fr",
                        .default = format)

  dat <- ofce::palette_pays |>
    mutate(
      code = countrycode::countrycode(ISO3, "iso3c", format)
    )

  if(lang == "fr"){
    dat <- dat |> dplyr::mutate(label = .data[["label_fr"]])} else {
      if(lang == "en"){
        dat <- dat |> dplyr::mutate(label = .data[["label_en"]])} else {
          dat <- dat |> dplyr::mutate(label = .data[["code"]])
          cat("Il n'existe pas de traduction pour la langue demandée. Seuls le français (\"fr\") et l'anglais (\"en\") sont pour l'instant proposés.")
          }
    }

  scale_colour_manual(values = dat$HEX,
                      breaks = dat$code,
                      labels = dat$label,
                      name = name,
                      aesthetics = aesthetics,
                      ...)
}

