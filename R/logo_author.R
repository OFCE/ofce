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
#'   du logo. Si `NULL` (par défaut), utilise `logo_down.png` inclus dans
#'   le package.
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
                           license = TRUE,
                           year = 2026,
                           text_size = 2.5,
                           color = "grey3",
                           tag_position = c(0.98,0.99),
                           tag_location = "plot"
                           ) {

  # rlang::check_installed("munch", reason = "for element_md()")

  # --- LOGO OFCE ---

  if (is.null(logo)) {
    logo <- system.file("logo_down.png", package = "ofce")
    if (logo == "") {
      cli::cli_abort("Logo file not found. Please provide a logo path.")
    }
  }

  logo_md <- glue::glue("![]({logo})")

  # --- CC LICENSE ICON ---

  cc_md <- ""
  if (license) {
    cc_fp <- system.file("cc_icon_down.png", package = "ofce")
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
