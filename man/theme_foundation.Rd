% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/theme_foundation.R
\name{theme_foundation}
\alias{theme_foundation}
\title{Theme foundation}
\usage{
theme_foundation(une_base_size = 12, base_family = "")
}
\arguments{
\item{base_family}{base font family}
}
\value{
un thème qui peut être utilisé dans ggplot
}
\description{
This theme is designed to be a foundation from which to build new
themes, and not meant to be used directly. \code{theme_foundation()}
is a complete theme with only minimal number of elements defined.
It is easier to create new themes by extending this one rather
than \code{\link[ggplot2]{theme_gray}()} or \code{\link[ggplot2]{theme_bw}()},
because those themes define elements deep in the hierarchy.
}
\details{
This theme takes \code{\link[ggplot2]{theme_gray}()} and sets all
\code{colour} and \code{fill} values to \code{NULL}, except for the top-level
elements (\code{line}, \code{rect}, and \code{title}), which have
\code{colour = "black"}, and \code{fill = "white"}. This leaves the spacing
and-non colour defaults of the default \pkg{ggplot2} themes in place.
}
\seealso{
Other themes: 
\code{\link{theme_ofce}()},
\code{\link{theme_ofce.2}()},
\code{\link{theme_ofce_void}()}
}
\concept{themes}
