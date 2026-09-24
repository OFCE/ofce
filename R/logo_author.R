#' Licence avec auteur et logo
#'
#' Ajoute le logo OFCE, l'icône Creative Commons et le nom de l'auteur
#' dans `plot.tag` en utilisant [munch::element_md()] avec des images
#' markdown inline. Le tag est affiché verticalement (rotation 90°) et
#' positionné par défaut en haut à droite du graphique.
#'
#' @param author Chaîne de caractères. Nom de l'auteur affiché dans le tag
#'   (par défaut `""`).
#' @param logo Chaîne de caractères ou `NULL`. Chemin vers le fichier image
#'   du logo. Si `NULL` (par défaut), utilise le logo `"OFCE"` du dossier
#'   `ecograph_logos` inclus dans le package. Ignoré si `institut_logo` est
#'   renseigné.
#' @param institut_logo Chaîne de caractères ou `NULL`. Nom d'un logo du dossier
#'   `ecograph_logos` du package (sans extension, insensible à la casse, par
#'   exemple `"ife-ofce"`). Si renseigné, court-circuite `logo`.
#' @param license Logique. Si `TRUE` (par défaut), affiche l'icône Creative
#'   Commons (`cc_icon_down.png`) avant le nom de l'auteur.
#' @param year Numérique ou `NULL`. Année affichée après le nom de l'auteur
#'   (par défaut `2026`). Si `NULL`, l'année est omise.
#' @param text_size Numérique. Taille du texte en points (par défaut `2.5`).
#'   Multipliée par [ggplot2::.pt] pour le rendu dans [munch::element_md()].
#' @param color Chaîne de caractères. Couleur du texte (par défaut `"grey3"`).
#' @param tag_position Vecteur numérique de longueur 2. Position (x, y) du tag
#'   en coordonnées normalisées (par défaut `c(0.98, 0.99)`).
#' @param tag_location Chaîne de caractères. Emplacement du tag, passé à
#'   [ggplot2::theme()] via `plot.tag.location` (par défaut `"plot"`).
#'
#' @return Une liste d'éléments ggplot2 ([ggplot2::labs()] et [ggplot2::theme()])
#'   à ajouter à un graphique avec `+`.
#' @importFrom glue glue
#' @importFrom cli cli_abort
#' @importFrom munch element_md
#' @importFrom ggplot2 labs theme .pt
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars) +
#'   geom_point(aes(x = mpg, y = hp)) +
#'   theme_ofce() +
#'   licence_auteur(author = "X. Timbeau")
#' }
licence_auteur <- function(author = "",
                           logo = NULL,
                           institut_logo = NULL,
                           license = TRUE,
                           year = getOption("ofce.licence.year"),
                           text_size = getOption("ofce.licence.text_size"),
                           color = "grey3",
                           tag_position = getOption("ofce.licence.tag_position"),
                           tag_location = "plot"
                           ) {

  # rlang::check_installed("munch", reason = "for element_md()")

  # --- LOGO OFCE ---

  if (!is.null(institut_logo)) {
    logo <- ecograph_logo(institut_logo)
  }

  if (is.null(logo)) {
    logo <- ecograph_logo("OFCE")
  }

  logo_md <- glue::glue("![]({logo})")

  # --- CC LICENSE ICON ---

  cc_md <- ""
  if (license) {
    cc_fp <- system.file("ecograph_logos", "cc_icon_down.png", package = "ofce")
    if (cc_fp == "") cc_fp <- system.file("cc_icon_down.png", package = "ofce")
    if (cc_fp != "") {
      cc_md <- glue::glue(" ![]({cc_fp})")
    }
  }
  # --- Build markdown tag text: cc + author + logo ---
  year_lab <- if (!is.null(year)) paste0(", ", year) else ""
  tag_text <- glue::glue("{cc_md} {author}{year_lab} {logo_md}")

  list(
    ggplot2::labs(tag = tag_text),
    ggplot2::theme(
      plot.tag = munch::element_md(
        angle = 90,
        size = text_size * ggplot2::.pt,
        colour = color,
        family = getOption("ofce.base_family", "Open Sans"),
        vjust = 1,
        hjust = 1
      ),
      plot.tag.location = tag_location,
      plot.tag.position = tag_position

    )
  )
}

#' Chemin d'un logo du dossier `ecograph_logos`
#'
#' Retrouve le fichier d'un logo livré avec le package dans `inst/ecograph_logos`
#' à partir de son nom, sans extension et sans tenir compte de la casse.
#'
#' @param name Chaîne de caractères. Nom du logo (par exemple `"OFCE"` ou
#'   `"ife-ofce"`), sans extension.
#'
#' @return Le chemin complet vers le fichier image du logo.
#' @keywords internal
#' @noRd
ecograph_logo <- function(name) {
  dir <- system.file("ecograph_logos", package = "ofce")
  if (dir == "" || !dir.exists(dir)) {
    cli::cli_abort("Le dossier {.file ecograph_logos} est introuvable dans le package {.pkg ofce}.")
  }

  files <- list.files(dir, full.names = TRUE)
  sans_ext <- function(x) sub("\\.[^.]*$", "", x)
  noms <- tolower(sans_ext(basename(files)))
  idx <- which(noms == tolower(sans_ext(name)))

  if (length(idx) == 0) {
    dispo <- sort(sans_ext(basename(files)))
    cli::cli_abort(c(
      "Logo {.val {name}} introuvable dans {.file ecograph_logos}.",
      i = "Logos disponibles : {.val {dispo}}."
    ))
  }

  files[[idx[[1]]]]
}
