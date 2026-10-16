#' Normalise l'argument/l'option `marquee`
#'
#' Convertit les valeurs acceptées pour `marquee` (dans [theme_ofce()],
#' [theme_ofce_void()] ou l'option `ofce.marquee`) en l'un des modes
#' `"marquee"`, `"munch"` ou `"none"`.
#'
#' @param marquee `TRUE`/`FALSE` (historique) ou `"munch"`
#' @return character(1) : `"marquee"`, `"munch"` ou `"none"`
#' @noRd
ofce_marquee_mode <- function(marquee) {
  if (isTRUE(marquee)) return("marquee")
  if (isFALSE(marquee)) return("none")
  if (is.character(marquee) && length(marquee) == 1 && marquee %in% c("marquee", "munch", "none"))
    return(marquee)
  cli::cli_abort(c(
    "{.arg marquee} doit valoir {.code TRUE} (marquee), {.code FALSE} (texte simple) ou {.val munch} (munch, compatible ggiraph).",
    "x" = "{.val {marquee}} n'est pas une valeur valide."
  ))
}

#' munch::element_md() en gras
#'
#' munch ignore `face` : le label est donc entouré de `**` (markdown) au
#' moment du rendu, paragraphe par paragraphe.
#'
#' @param ... arguments passés à [munch::element_md()]
#' @noRd
element_md_bold <- function(...) {
  el <- munch::element_md(...)
  class(el) <- c("ofce_element_md_bold", class(el))
  el
}

#' @exportS3Method ggplot2::element_grob
element_grob.ofce_element_md_bold <- function(element, label = "", ...) {
  if (!is.null(label) && !identical(label, "")) {
    paras <- strsplit(as.character(label), "\n\\s*\n")[[1]]
    paras <- trimws(paras)
    to_bold <- nzchar(paras) & !grepl("^\\*\\*.*\\*\\*$", paras)
    paras[to_bold] <- paste0("**", paras[to_bold], "**")
    label <- paste(paras, collapse = "\n\n")
  }
  class(element) <- setdiff(class(element), "ofce_element_md_bold")
  ggplot2::element_grob(element, label = label, ...)
}

#' theme OFCE
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' d'autres éléments de la norme comme les couleurs, l'allure générale du graphique
#' sont à introduire par ailleurs
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Arimo"))
#' @param title_family character(1) string, police de charactère du titre (globalement et défaut options(ofce.title_family="Merriweather"))
#' @param marquee utilise un rendu riche (markdown) pour la plupart des textes du plot. `TRUE`
#'   utilise \pkg{marquee} (solution historique, rendu de meilleure qualité mais incompatible
#'   avec le device SVG utilisé par \pkg{ggiraph} -- voir Details) ; `"munch"` utilise
#'   \pkg{munch}, pensé pour rester léger et compatible avec \pkg{ggiraph}/\code{girafy()} ;
#'   `FALSE` revient à du texte simple (\code{\link[ggplot2]{element_text}}). Par défaut,
#'   \code{getOption("ofce.marquee")}.
#' @inheritDotParams ggplot2::theme
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @details
#' `marquee` s'appuie sur l'API de glyphes de R (>= 4.3), non supportée par le device SVG de
#' \pkg{ggiraph} : le texte y est alors redessiné comme des polygones/rasters, ce qui est plus
#' lent et produit des SVG beaucoup plus volumineux (voir \url{https://github.com/r-lib/marquee/issues/10}).
#' `munch` a été conçu par les auteurs de \pkg{ggiraph} pour éviter ce problème en restant du
#' texte SVG natif. Pour un graphique destiné à \code{\link{girafy}()}, préférer `marquee = "munch"`.
#' @export
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit
#' @importFrom munch element_md
#' @import marquee

theme_ofce <- function(base_size = getOption("ofce.base_size"),
                       base_family = getOption("ofce.base_family"),
                       title_family = getOption("ofce.title_family", base_family),
                       marquee = getOption("ofce.marquee"), ...) {

  marquee_mode <- ofce_marquee_mode(marquee)

 ofce_style <- marquee::classic_style(
    base_size = base_size,
    body_font = base_family,
    header_font = base_family,
    code_font = "Fira Code")

  theme_text <- if(marquee_mode == "marquee")
    ggplot2::theme(
      plot.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 700),
        family = title_family,
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b = 6),
        lineheight = 1),
      axis.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 400),
        size = ggplot2::rel(0.7),
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, r=6),
        lineheight = 1),
      axis.title.x = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 400),
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=0, r=6),
        lineheight = 1),
      axis.title.y = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 400),
        angle = 90,
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=0, r=6),
        lineheight = 1),
      axis.text = marquee::element_marquee(
        size = ggplot2::rel(0.7),
        colour = "gray25"),
      axis.text.y = marquee::element_marquee(
        hjust = 1,
        vjust=0,
        margin = ggplot2::margin(r=2, b=0)),
      axis.text.x = marquee::element_marquee(
        margin = ggplot2::margin(t=0, b=0),
        hjust = 0.5),
      plot.subtitle = marquee::element_marquee(
        style = marquee::modify_style(
          ofce_style, tag = "p",
          weight = "normal",
          padding = marquee::trbl(0, 0, 0, 0),
          margin = marquee::trbl(0, 0, 0, 0),
          lineheight = 0.9),
        size = ggplot2::rel(0.85),
        vjust = 0,
        hjust = 0,
        margin = ggplot2::margin(t = 6, b = 0)),
      plot.caption = marquee::element_marquee(
        style = marquee::modify_style(
          ofce_style, tag = "p",
          weight = "normal",
          align = "left-aligned",
          padding = marquee::trbl(3, 3, 3, 3),
          hanging = marquee::em(0.),
          margin = marquee::trbl(0, 0, 3, 0),
          lineheight = 0.9),
        size = ggplot2::rel(0.8),
        hjust = 0,
        margin = ggplot2::margin(t=9,b=3),
        width = 0.99),
      strip.text = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 400),
        size = ggplot2::rel(0.85),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6,b=3)),
      legend.title = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 400),
        size = ggplot2::rel(0.7),
        color = "gray25",
        margin = ggplot2::margin(r=3, b=0, t=0, l=3)),
      legend.text = marquee::element_marquee(
        style = marquee::modify_style(ofce_style, tag = "base", weight = 400),
        size = ggplot2::rel(0.7),
        hjust=0,
        lineheight = 0.9,
        color = "gray25",
        margin = ggplot2::margin(r=3, b=0, t=0, l=1))
    )
  else if(marquee_mode == "munch")
    ggplot2::theme(
      plot.title = element_md_bold(
        family = title_family,
        hjust = 0,
        vjust = 0.5,
        size = base_size,
        margin = ggplot2::margin(b = 6),
        lineheight = 1.2),
      axis.title = munch::element_md(
        size = ggplot2::rel(0.7),
        colour = "#222222",
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, r=6),
        lineheight = 1.2),
      axis.title.x = munch::element_md(
        size = ggplot2::rel(0.7),
        colour = "#222222",
        hjust = 1,
        vjust = 0.5,
        margin = ggplot2::margin(t=0, r=6),
        lineheight = 1.2),
      axis.title.y = munch::element_md(
        size = ggplot2::rel(0.7),
        colour = "#222222",
        angle = 90,
        hjust = 1,
        vjust = 1,
        margin = ggplot2::margin(t=0, r=6),
        lineheight = 1.2),
      # axis.text reste du element_text standard : ggplot2 fournit toutes les
      # étiquettes d'un axe en un seul appel vectorisé à element_grob(), ce
      # que munch::element_md() (pensé pour une étiquette à la fois) ne gère pas.
      axis.text = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        colour = "gray25"),
      axis.text.y = ggplot2::element_text(
        hjust = 1,
        vjust=0,
        margin = ggplot2::margin(r=2, b=0)),
      axis.text.x = ggplot2::element_text(
        margin = ggplot2::margin(t=0, b=0),
        hjust = 0.5),
      plot.subtitle = munch::element_md(
        size = ggplot2::rel(0.8),
        vjust = 0,
        hjust = 0,
        lineheight = 0.9,
        margin = ggplot2::margin(t = 6, b = 0)),
      plot.caption = munch::element_md(
        size = ggplot2::rel(0.8),
        hjust = 0,
        lineheight = 1.2,
        margin = ggplot2::margin(t=9,b=3)),
      strip.text = munch::element_md(
        size = ggplot2::rel(0.8),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6,b=3)),
      legend.title = munch::element_md(
        size = ggplot2::rel(0.7),
        colour = "gray25",
        margin = ggplot2::margin(r=3, b=0, t=0, l=3),
        lineheight = 1.2),
      legend.text = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        hjust = 0,
        vjust = 0.5,
        lineheight = 1,
        colour = "gray25",
        margin = ggplot2::margin(r=3, b=0, t=0, l=2))
    )
  else
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        family = title_family,
        face = "bold",
        hjust = 0,
        vjust = 0.5,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      axis.title  = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "#222222",
        margin = margin(t = 0, b=0, l= 0, r=0),
        hjust = 1),
      axis.title.x  = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "#222222",
        margin = margin(t = 0, b=0, l= 0, r=0),
        hjust = 1),
      axis.title.y  = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "#222222",
        margin = margin(t = 0, b=0, l= 0, r=0),
        hjust = 1),
      axis.text = ggplot2::element_text(
        size = ggplot2::rel(0.75),
        colour = "gray25"),
      axis.text.y = ggplot2::element_text(
        hjust = 1,
        vjust=0,
        margin = ggplot2::margin(r=2, b=0)),
      axis.text.x = ggplot2::element_text(
        margin = ggplot2::margin(t=0, b=0),
        hjust = 0.5),
      plot.subtitle = ggplot2::element_text(
        size = ggplot2::rel(0.85),
        hjust = 0,
        margin = ggplot2::margin(b=0, t=0),
        lineheight = 1.25),
      plot.caption = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        hjust = 0,
        margin = ggplot2::margin(l = 0, t = 6),
        lineheight = 1.25),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(0.85),
        hjust = 0.5,
        vjust = 0.5,
        margin = ggplot2::margin(t=6, b=6)),
      legend.text = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "gray25"),
      legend.title = ggplot2::element_text(
        size = ggplot2::rel(0.7),
        color = "gray25")
    )

    theme_text +
    ggplot2::theme(
      text = ggplot2::element_text(
        family = base_family,
        size = base_size
      ),
      rect = ggplot2::element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color"),
        linetype = 0),
      panel.background = ggplot2::element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color"),
        linetype = 0),
      strip.background = ggplot2::element_rect(
        fill = getOption("ofce.background_color"),
        colour = getOption("ofce.background_color"),
        linetype = 0),
      plot.title.position = "panel",
      plot.margin = ggplot2::margin(b=12, t=6, l=6, r=18),
      plot.caption.position = "plot",
      # Legend format
      # legend.text.align = 0,
      legend.position = c(0.05, 0.95),
      legend.justification = c(0, 1),
      legend.direction = "vertical",
      legend.key.height = unit(9, "pt"),
      legend.key.width = unit(9, "pt"),
      legend.key.size = unit(9, "pt"),
      legend.key.spacing.x = unit(3, "pt"),
      legend.key.spacing.y = unit(1, "pt"),
      legend.margin = ggplot2::margin(t=0, r=0, b=0, l=0),
      legend.box.spacing = unit(3, "pt"),
      #Axis format
      axis.ticks = element_line(
        color="gray25",
        linewidth = unit(0.1, "pt")),
      axis.ticks.length.x = unit(3,"pt"),
      axis.ticks.length.y = unit(-2,"pt"),
      axis.minor.ticks.length = rel(0.5),
      axis.line = element_line(
        colour = "gray25",
        linewidth = unit(0.1, "pt"),
        lineend="round"),
      # Grid lines
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(
        linewidth = unit(0.1, "pt"),
        color = "gray85"),
      panel.grid.major.x = element_line(
        linewidth = unit(0.1, "pt"),
        color = "gray85"),
      panel.spacing = unit(3, "pt"))+
    ggplot2::theme(...) # pour passer les arguments en plus
}

#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#' Convient pour des cartes par exemple
#'
#' @param base_size double(1) Taille des éléments texte du thème. Peut être donné globalement par options(ofce.base_size=12).
#' @param base_family character(1) string, police de charactère du thème (globalement et défaut options(ofce.base_family="Nunito"))
#' @param ... paramètres passés à \code{\link[ggplot2]{theme}()}
#' @importFrom ggplot2 theme_grey element_text element_line element_rect element_blank margin unit
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
#' @import marquee
#' @export


theme_ofce_void <- function(base_size = getOption("ofce.base_size"),
                            base_family = getOption("ofce.base_family"),
                            marquee = getOption("ofce.marquee"), ...) {
  theme_ofce(base_size = base_size,
             base_family = base_family,
             marquee = marquee,
             ...) +
    theme(
      legend.background = element_blank(),
      axis.title  = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      #Blank background
      panel.background = ggplot2::element_blank())}
