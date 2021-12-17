
#' Variation de ggplot2::annotate pour intégrer une position
#' @param position fonction position (comme position_nudge()) pour modifier la position de l'annotation
#' @inheritParams ggplot2::annotate
#' @importFrom plyr compact
#' @importFrom glue glue
#' @importFrom vctrs new_data_frame
#' @importFrom rlang abort
#' @importFrom ggplot2 layer
#' @return
#'
annotate2 <- function (geom, x = NULL, y = NULL, xmin = NULL, xmax = NULL,
                       ymin = NULL, ymax = NULL, xend = NULL, yend = NULL, position=PositionIdentity,...,
                       na.rm = FALSE)
{
  deposition <- plyr::compact(list(x = x, xmin = xmin, xmax = xmax,
                                   xend = xend, y = y, ymin = ymin, ymax = ymax, yend = yend))
  aesthetics <- c(deposition, list(...))
  lengths <- vapply(aesthetics, length, integer(1))
  n <- unique(lengths)
  if (length(n) > 1L) {
    n <- setdiff(n, 1L)
  }
  if (length(n) > 1L) {
    bad <- lengths != 1L
    details <- paste(names(aesthetics)[bad], " (",
                     lengths[bad], ")", sep = "", collapse = ", ")
    rlang::abort(glue::glue("Unequal parameter lengths: {details}"))
  }
  data <- vctrs::new_data_frame(deposition, n = n)
  ggplot2::layer(geom = geom, params = list(na.rm = na.rm, ...), stat = StatIdentity,
                 position = position, data = data, mapping = aes_all(names(data)),
                 inherit.aes = FALSE, show.legend = FALSE)
}
