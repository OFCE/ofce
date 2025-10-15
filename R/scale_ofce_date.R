
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
                            right_red = TRUE,
                            ...) {
  if(!is.null(labels))
    date_labels <- waiver() else
      labels <- waiver()
    if(right_red)
      expand <- expansion(mult=c(0.04,0)) else
        expand <- waiver()
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
      guides(x = guide_axis(minor.ticks = TRUE)))
}
