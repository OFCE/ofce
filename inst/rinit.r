library(knitr)
opts_chunk$set(
  fig.pos="htb",
  out.extra="",
  dev="ragg_png",
  out.width="100%",
  fig.showtext=TRUE,
  cache=FALSE)

suppressPackageStartupMessages(
  library(tidyverse, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))
library(ofce, quietly = TRUE, verbose = FALSE)
library(showtext, quietly = TRUE, verbose = FALSE)
library(gt, quietly = TRUE, verbose = FALSE)
library(readxl, quietly = TRUE, verbose = FALSE)
library(ggiraph, quietly = TRUE, verbose = FALSE)

options(
  ofce.base_size = 12,
  ofce.background_color = "transparent")
showtext_opts(dpi = 192)
showtext_auto()

tooltip_css  <-
  "font-family:Open Sans;
  background-color:snow;
  border-radius:5px;
  border-color:gray;
  border-style:solid;
  border-width:0.5px;
  font-size:9pt;
  padding:4px;
  box-shadow: 2px 2px 2px gray;"

gdtools::register_gfont("Open Sans")

girafe_opts <- function(x, ...) girafe_options(
  x,
  opts_hover(css = "stroke-width:1px;", nearest_distance = 60),
  opts_tooltip(css = tooltip_css)) |>
  girafe_options(...)

girafy <- function(plot, r=4, ...) {
  girafe(ggobj = plot) |>
    girafe_options(
      opts_hover_inv(css = "opacity:0.75;"),
      opts_hover(css = glue::glue("stroke-width:2px;r:{r}px;")),
      opts_tooltip(css = tooltip_css)) |>
    girafe_options(...)
}

milliards <- function(x, n_signif = 3L) {
  stringr::str_c(
    format(
      x,
      digits = n_signif,
      big.mark = " ",
      decimal.mark = ","),
    " milliards d'euros")
}

f_taux <- function(x) {
  str_replace(str_c(signif(x,3),"%"), "\\.", ",")
}

if(.Platform$OS.type=="windows")
  Sys.setlocale(locale = "fr_FR.utf8") else
    Sys.setlocale(locale = "fr_FR")
