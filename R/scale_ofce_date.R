
#' Echelle pour les x du format habituel des grahiques à date
#'
#' @param date liste de date
#' @param freq soit day, month, quarter, year
#' @param lang langue de retour
#' @return chaine de charactères
#' @export

scale_ofce_date <- function(date_breaks = "5 years",
                            labels = NULL,
                            date_minor_breaks = "1 year",
                            date_labels = "%Y",
                            guide = "minor_breaks",
                            name = NULL,
                            expand = expansion(mult=c(0.03,0.03)),
                            ...) {
  if(!is.null(labels))
    date_labels <- waiver() else
      labels <- waiver()
    list(
      scale_x_date(
        date_breaks = date_breaks,
        date_minor_breaks = date_minor_breaks,
        date_labels = date_labels,
        labels = labels,
        guide = guide,
        name = name,
        expand = expand,
        ...),
      # Ajuste hjust sur l'élément axis.text.x déjà en place (quel que soit le
      # moteur marquee/munch/texte simple choisi par theme_ofce()) plutôt que
      # de le remplacer par un element_text() nu, qui écraserait silencieusement
      # sa classe et ses autres propriétés (voir ofce_theme_patch()).
      ofce_theme_patch("axis.text.x", hjust = 0),
      guides(x = guide_axis(minor.ticks = TRUE)))
}
