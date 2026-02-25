#' Licence avec auteur et logo
#'
#' Ajoute le logo OFCE, l'icône CC et le nom de l'auteur dans `plot.tag`
#' en utilisant `element_md()` avec des images markdown inline.
#'
#' @param author nom de l'auteur ("" par défaut)
#' @param logo chemin vers le logo (utilise ofce_m.png par défaut si NULL)
#' @param license logical, affiche l'icône CC (TRUE par défaut)
#' @param year année affichée après l'auteur (2026 par défaut, NULL pour omettre)
#' @param text_size taille du texte en points (2.75 par défaut)
#' @param color couleur du texte ("grey3" par défaut)
#'
#' @return une liste d'éléments ggplot (à ajouter avec +)
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
                           text_size = 5,
                           color = "grey3") {

  # rlang::check_installed("munch", reason = "for element_md()")

  # --- LOGO OFCE ---

  if (is.null(logo)) {
    logo <- system.file("ofce_m.png", package = "ofce")
    if (logo == "") {
      cli::cli_abort("Logo file not found. Please provide a logo path.")
    }
  }

  logo_md <- glue::glue("![]({logo})")

  # --- CC LICENSE ICON ---

  cc_md <- ""
  if (license) {
    cc_fp <- system.file("cc_icon.png", package = "ofce")
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
      plot.tag = element_marquee(
        angle = 90,
        size = text_size * ggplot2::.pt,
        colour = color,
        family = getOption("ofce.base_family", "Open Sans"),
        vjust = 0,
        hjust = 1
      ),
      plot.tag.location = "plot",
      plot.tag.position = c(1,0.98)

    )
  )
}
