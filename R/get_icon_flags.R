#' Obtenir les URLs des icônes Twemoji à partir de codes hexadécimaux Unicode
#'
#' Prend un vecteur de codes hexadécimaux Unicode et retourne les URLs
#' correspondantes des fichiers SVG Twemoji hébergés sur le CDN jsDelivr.
#' Utiliser [show_emojis()] pour parcourir la liste des emojis disponibles
#' et trouver les codes hexadécimaux correspondants.
#'
#' @param hex Un vecteur de chaînes de caractères contenant des codes
#'   hexadécimaux Unicode (par exemple `"1F430"` pour le lapin).
#'   Les codes peuvent être en majuscules ou minuscules.
#'   Les valeurs `NA` sont conservées dans le résultat.
#' @param tooltip Logique. Si `TRUE`, retourne une balise HTML `<img>` prête
#'   à l'emploi (utile pour les tooltips ou les tableaux HTML).
#'   Si `FALSE` (par défaut), retourne uniquement l'URL du SVG.
#' @param size Taille en pixels de l'icône lorsque `tooltip = TRUE`
#'   (par défaut `15`).
#'
#' @return Un vecteur de chaînes de caractères contenant les URLs des fichiers
#'   SVG Twemoji correspondants, ou des balises HTML `<img>` si
#'   `tooltip = TRUE`. Les éléments `NA` en entrée produisent des `NA`
#'   en sortie.
#'
#' @examples
#' get_icons("1F430")
#' get_icons(c("1F430", "1F600"))
#' get_icons("1F430", tooltip = TRUE)
#' get_icons("1F430", tooltip = TRUE, size = 20)
#'
#' @importFrom cli cli_abort
#' @export
get_icons <- function(hex, tooltip = FALSE, size = 15) {
  if (!is.character(hex)) {
    cli::cli_abort("{.arg hex} doit \u00eatre un vecteur de cha\u00eenes de caract\u00e8res, pas {.obj_type_friendly {hex}}.")
  }
  if (length(hex) == 0) {
    return(character(0))
  }
  invalid <- !is.na(hex) & !grepl("^[0-9A-Fa-f]+(-[0-9A-Fa-f]+)*$", hex)
  if (any(invalid)) {
    cli::cli_abort(
      "Code{?s} hexad\u00e9cima{?l/ux} invalide{?s} : {.val {hex[invalid]}}."
    )
  }
  hex_lower <- tolower(hex)
  if (tooltip) {
    base_url <- "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/"
    res <- ifelse(
      is.na(hex),
      NA_character_,
      paste0(
        "<img src='", base_url, hex_lower, ".svg' ",
        "style='height:", size, "px;width:", size, "px;vertical-align:-2px;'>"
      )
    )
  } else {
    base_url <- "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/"
    res <- ifelse(is.na(hex), NA_character_, paste0(base_url, hex_lower, ".svg"))
  }

  return(res)
}

#' Obtenir les icônes de drapeaux à partir de codes ou noms de pays
#'
#' Convertit un vecteur de codes pays ISO 3166-1 alpha-2, alpha-3 ou de
#' noms de pays (dans n'importe quelle langue) en URLs ou balises HTML
#' des drapeaux Twemoji correspondants, en s'appuyant sur [get_icons()].
#' La détection du format est automatique via le package \pkg{countrycode}.
#'
#' @param country Un vecteur de chaînes de caractères contenant des codes pays
#'   ISO2 (`"FR"`), ISO3 (`"FRA"`) ou des noms de pays dans n'importe quelle
#'   langue (`"France"`, `"Allemagne"`, `"Germany"`).
#'   On peut mélanger les formats dans le même vecteur.
#'   Les valeurs `NA` sont conservées dans le résultat.
#' @param tooltip Logique. Si `TRUE`, retourne une balise HTML `<img>`.
#'   Si `FALSE` (par défaut), retourne uniquement l'URL du SVG.
#'   Passé à [get_icons()].
#' @param size Taille en pixels de l'icône lorsque `tooltip = TRUE`
#'   (par défaut `15`). Passé à [get_icons()].
#'
#' @return Un vecteur de chaînes de caractères contenant les URLs ou balises
#'   HTML des drapeaux Twemoji. Les éléments `NA` en entrée ou les pays
#'   non reconnus produisent des `NA` en sortie.
#'
#' @examples
#' get_flags("FR")
#' get_flags(c("FRA", "DEU", "USA"))
#' get_flags(c("FR", "DEU", "US"))
#' get_flags("France")
#' get_flags(c("Allemagne", "Italy", "Estados Unidos"))
#' get_flags("FRA", tooltip = TRUE)
#'
#' @importFrom cli cli_abort cli_warn
#' @importFrom countrycode countrycode
#' @export
get_flags <- function(country, tooltip = FALSE, size = 15) {
  if (!is.character(country)) {
    cli::cli_abort("{.arg country} doit \u00eatre un vecteur de cha\u00eenes de caract\u00e8res, pas {.obj_type_friendly {country}}.")
  }
  if (length(country) == 0) {
    return(character(0))
  }
  iso2 <- rep(NA_character_, length(country))
  not_na <- !is.na(country)
  upper <- toupper(country)
  # ISO2: exactly 2 letters
  is_iso2 <- not_na & grepl("^[A-Za-z]{2}$", country)
  iso2[is_iso2] <- upper[is_iso2]
  # ISO3: exactly 3 letters
  is_iso3 <- not_na & grepl("^[A-Za-z]{3}$", country)
  if (any(is_iso3)) {
    iso2[is_iso3] <- countrycode::countrycode(
      upper[is_iso3],
      origin = "iso3c",
      destination = "iso2c",
      warn = FALSE
    )
  }
  # Country names: everything else (longer strings, spaces, accents, etc.)
  is_name <- not_na & !is_iso2 & !is_iso3
  if (any(is_name)) {
    iso2[is_name] <- countrycode::countrycode(
      country[is_name],
      origin = "country.name",
      destination = "iso2c",
      warn = FALSE
    )
  }
  unrecognized <- not_na & is.na(iso2)
  if (any(unrecognized)) {
    cli::cli_warn(
      "Pays non reconnu{?s} : {.val {country[unrecognized]}}."
    )
  }
  c1 <- match(substr(iso2, 1, 1), LETTERS)
  c2 <- match(substr(iso2, 2, 2), LETTERS)
  hex <- ifelse(
    is.na(iso2),
    NA_character_,
    paste0(sprintf("%x", 0x1F1E5 + c1), "-", sprintf("%x", 0x1F1E5 + c2))
  )
  get_icons(hex, tooltip = tooltip, size = size)
}

#' Afficher la liste des emojis Twemoji
#'
#' Ouvre dans le navigateur la page de référence des emojis Twemoji
#' avec leurs codes hexadécimaux, utile pour trouver les codes à
#' passer à [get_icons()].
#'
#' @return Appelée pour son effet de bord (ouverture du navigateur).
#'   Retourne `NULL` de manière invisible.
#'
#' @examples
#' \dontrun{
#' show_emojis()
#' }
#'
#' @importFrom utils browseURL
#' @export
show_emojis <- function() {
  utils::browseURL("https://twemoji-cheatsheet.vercel.app")
}

#' Afficher les drapeaux correspondant à un vecteur de pays
#'
#' Produit un graphique interactif (via \pkg{ggiraph}) montrant les
#' drapeaux Twemoji associés à chaque pays. Le survol d'un label
#' affiche le drapeau en tooltip HTML.
#'
#' @param country Un vecteur de chaînes de caractères (codes ISO2, ISO3
#'   ou noms de pays). Passé à [get_flags()].
#'
#' @return Un objet `girafe` (widget HTML interactif).
#'
#' @examples
#' \dontrun{
#' show_flags(c("FRA", "DEU", "USA", "Japon"))
#' }
#'
#' @importFrom magick image_read_svg
#' @importFrom ggplot2 ggplot aes coord_cartesian theme_void annotation_raster
#' @importFrom ggiraph geom_text_interactive girafe opts_tooltip
#' @importFrom grDevices as.raster
#' @export
show_flags <- function(country) {
  urls <- get_flags(country)
  tooltips <- get_flags(country, tooltip = TRUE, size = 64)
  imgs <- lapply(urls, function(u) {
    if (is.na(u)) return(NULL)
    magick::image_read_svg(u, width = 120)
  })
  n <- length(country)
  ncol <- min(n, 6)
  nrow <- ceiling(n / ncol)
  df <- data.frame(
    label = country,
    tooltip = tooltips,
    x = rep(seq_len(ncol), length.out = n),
    y = rep(seq(nrow, 1), each = ncol, length.out = n)
  )
  p <- ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
    ggplot2::coord_cartesian(
      xlim = c(0.5, ncol + 0.5),
      ylim = c(0.25, nrow + 0.5)
    ) +
    ggplot2::theme_void()
  for (i in seq_len(n)) {
    if (!is.null(imgs[[i]])) {
      raster <- grDevices::as.raster(imgs[[i]])
      p <- p + ggplot2::annotation_raster(
        raster,
        xmin = df$x[i] - 0.25, xmax = df$x[i] + 0.25,
        ymin = df$y[i] - 0.35, ymax = df$y[i] + 0.15
      )
    }
  }
  p <- p + ggiraph::geom_text_interactive(
    ggplot2::aes(label = label, tooltip = tooltip),
    vjust = -1.8, size = 3.5
  )
  ggiraph::girafe(ggobj = p, options = list(
    ggiraph::opts_tooltip(css = "background:white;padding:5px;border-radius:3px;border:1px solid #ccc;")
  ))
}

