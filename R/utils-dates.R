# Fonctions internes pour les noms de mois, communes à R/dates.r et
# R/ofce_caption.R.
#
# Les noms de mois sont hardcodés plutôt qu'obtenus via l'argument
# `locale =` de lubridate/base R (qui dépend des locales installées sur
# l'OS, ex. "fr_FR" vs "fr_FR.UTF-8" vs "French_France", souvent absentes
# sur des systèmes minimaux/CI). Cela garantit un résultat identique
# quelle que soit la plateforme.

.mois_fr <- c("janvier", "f\u00e9vrier", "mars", "avril", "mai", "juin",
              "juillet", "ao\u00fbt", "septembre", "octobre", "novembre", "d\u00e9cembre")
.mois_en <- month.name

#' Nom du mois sans dépendre de la locale du système
#'
#' @param date la date
#' @param locale ou lang, une chaine commençant par "fr" ou "en" (les
#'   autres valeurs sont traitées comme "fr")
#' @param abbr abrège le nom du mois (3 premières lettres)
#' @noRd
.mois_nom <- function(date, locale = "fr_FR.UTF-8", abbr = FALSE) {
  lang <- if (stringr::str_detect(tolower(locale), "^en")) "en" else "fr"
  noms <- if (lang == "en") .mois_en else .mois_fr
  nom <- noms[lubridate::month(date)]
  if (abbr) nom <- stringr::str_sub(nom, 1, 3)
  nom
}
