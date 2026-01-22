#' Licence avec auteur et logo
#'
#' Ajoute un bandeau vertical sur le côté droit du graphique contenant
#' le nom de l'auteur suivi du logo OFCE. Le texte et le logo sont
#' tournés de 90 degrés.
#'
#' @param author nom de l'auteur ("" par défaut)
#' @param logo chemin vers le logo (utilise ofce_m.png par défaut si NULL)
#' @param license texte de la licence (non utilisé pour le moment, NULL par défaut)
#' @param logo_size taille relative du logo (0.35 par défaut)
#' @param text_size taille du texte en points (3 par défaut)
#' @param y_  pos position verticale en npc (0.01 par défaut, en bas)
#' @param color couleur du texte ("grey30" par défaut)
#' @param spacing espacement entre l'auteur et le logo ("  " par défaut)
#'
#' @return un élément ggplot (à ajouter avec +)
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars) +
#'   geom_point(aes(x = mpg, y = hp)) +
#'   theme_ofce() +
#'   licence_auteur(author = "X. Timbeau")
#' }
licence_auteur <- function(author="",
                            logo = NULL,
                            license = TRUE ,
                            year = 2026,
                            logo_size = 0.4,
                            text_size = 2.75,
                            y_pos = 0.99,
                            color = "grey3",
                            spacing = "") {

  rlang::check_installed("ggpp", reason = "to add logo_author annotation")
  rlang::check_installed("magick", reason = "to read logo image")

  # LOGO OFCE

  if (is.null(logo)) {
    logo <- system.file("ofce_m.png", package = "ofce")
    if (logo == "") {
      cli::cli_abort("Logo file not found. Please provide a logo path.")
    }
  }
  logo_img <- magick::image_read(logo) |>
    magick::image_rotate(270)

  logo_width <- logo_size * 65/142

  ## Grob du logo (déjà tourné) - positionné en haut (après l'auteur)
  logo_grob <- grid::rasterGrob(
    logo_img,
    x = grid::unit(0.5, "npc"),
    y = y_pos,
    height = grid::unit(logo_size, "snpc"),
    width = grid::unit(logo_width, "snpc"),
    hjust = 0.5,
    vjust = 1
  )

  # AUTEUR ET ANNEE

  author_y <- grid::unit(y_pos,"npc") - grid::unit(1, "grobheight", logo_grob) - grid::unit(0.02,"npc")

  if(!is.null(year)){
    year_lab <-  paste0(", ", year )
  }else{
    year_lab <-  ""}

  ## Grob auteur - tourné 90 degrés avant le logo


  author_grob <- grid::textGrob(
    label = paste0(spacing, author,year_lab," "),
    x = grid::unit(0.5, "npc"),
    y = author_y,
    hjust = 1,
    vjust = 0.5,
    rot = 90,
    gp = grid::gpar(
      fontfamily = getOption("ofce.base_family", "Open Sans"),
      fontsize = text_size * ggplot2::.pt,
      col = color
    )
  )

  # LICENCE

  ## Logo de pour la licence

  if(license) {
    license_logo_fp <- system.file("cc_icon.png", package = "ofce")
    license_logo <- magick::image_read(license_logo_fp) |>
      magick::image_rotate(270) |>
      magick::image_colorize(opacity = 50, color = "white")

    ## Grob license - tourné 90 degrés avant le logo
    license_y <- grid::unit(y_pos,"npc") - grid::unit(1, "grobheight", logo_grob) - grid::unit(1, "grobheight", author_grob) - grid::unit(0.04,"npc")

    license_grob <- grid::rasterGrob(
      license_logo,
      x = grid::unit(0.5, "npc"),
      y = license_y,
      height = grid::unit(logo_width * 2/1*0.8, "snpc"),
      width = grid::unit(logo_width  * 0.8 , "snpc"),
      hjust = 0.5,
      vjust = 1
    )

  }else{
    license_logo <- NULL
    license_grob <- NULL
  }


  # Combiner logo et texte
  if (license) {
    combined_grob <- grid::grobTree(license_grob, author_grob, logo_grob)
  } else {
    combined_grob <- grid::grobTree(author_grob, logo_grob)
  }

  # # Retourner l'annotation
  ggpp::annotate(
    geom = "grob_npc",
    label = combined_grob,
    npcx = 0.975,
    npcy = y_pos,
    hjust = 0.5,
    vjust = 1
  )

  # theme(plot.background = element_rect(fill = combined_grob))
}

# rlang::check_installed("magick", reason = "to add a logo inside")
# assertthat::assert_that(position%in%c("bottom", "top"), msg = "position doit être soit 'top' soit 'bottom'")
# if(position == "top") {
#   x <- 1
#   y <- 1
#   just <- c(1,1)
# }
# if(position == "bottom") {
#   x <- 1
#   y <- 0
#   just <- c(1,0)
# }
# logo <- ofce_logo |>
#   magick::image_read() |>
#   grid::rasterGrob(
#     x = x, y = y,
#     width = unit(0.075*size, "snpc"),
#     height = unit(0.075*size/142*65, "snpc"),
#     just = just) |>
#   grid::pattern(
#     extend = "none",
#     gp = grid::gpar(fill = "transparent"))
# theme(plot.background = element_rect(fill = logo))
#
#
