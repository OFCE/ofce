
#' Theme foundation
#'
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. \code{theme_foundation()}
#' is a complete theme with only minimal number of elements defined.
#' It is easier to create new themes by extending this one rather
#' than \code{\link[ggplot2]{theme_gray}()} or \code{\link[ggplot2]{theme_bw}()},
#' because those themes define elements deep in the hierarchy.
#'
#' This theme takes \code{\link[ggplot2]{theme_gray}()} and sets all
#' \code{colour} and \code{fill} values to \code{NULL}, except for the top-level
#' elements (\code{line}, \code{rect}, and \code{title}), which have
#' \code{colour = "black"}, and \code{fill = "white"}. This leaves the spacing
#' and-non colour defaults of the default \pkg{ggplot2} themes in place.
#'
#' @inheritParams ggplot2::theme_grey
#'

#' @importFrom ggplot2 theme_grey element_text element_line element_rect
#' @export
#' @return un thème qui peut être utilisé dans ggplot
#' @family themes
theme_foundation <- function(une_base_size = 12, base_family="") {
  thm <- ggplot2::theme_grey(base_size = une_base_size,
                             base_family = base_family)
  for (i in names(thm)) {
    if ("colour" %in% names(thm[[i]])) {
      thm[[i]]["colour"] <- list(NULL)
    }
    if ("fill" %in% names(thm[[i]])) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm + ggplot2::theme(panel.border = ggplot2::element_rect(fill = NA),
              legend.background = ggplot2::element_rect(colour = NA),
              line = ggplot2::element_line(colour = "black"),
              rect = ggplot2::element_rect(fill = "white", colour = "black"))
}
