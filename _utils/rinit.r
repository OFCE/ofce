library(knitr)
opts_chunk$set(
  fig.pos="htb", 
  out.extra="",
  dev="ragg_png",
  dev.args = list(bg = "transparent"),
  out.width="100%",
  fig.showtext=TRUE,
  message = FALSE,
  warning = FALSE,
  echo = FALSE)

library(ofce)
library(showtext)
library(gt)
library(readxl)
library(ggiraph)
library(curl)
library(ggrepel)
library(gt)
library(scales)
library(glue)
library(patchwork)
library(downloadthis)
library(lubridate)
library(insee)
library(ggh4x)
library(PrettyCols)
library(cli)
library(quarto)
library(tidyverse)

options(
  ofce.base_size = 12,
  ofce.background_color = "transparent")
showtext_opts(dpi = 92)
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
  box-shadow: 2px 2px 2px gray;
  r:20px;"

gdtools::register_gfont("Open Sans")

girafe_opts <- function(x, ...) girafe_options(
  x,
  opts_hover(css = "stroke-width:1px;", nearest_distance = 60),
  opts_tooltip(css = tooltip_css)) |> 
  girafe_options(...)

girafy <- function(plot, r=2.5, o = 0.5,  ...) {
  if(knitr::is_html_output()| interactive()) {
    girafe(ggobj = plot) |> 
      girafe_options(
        opts_hover_inv(css = glue("opacity:{o};")),
        opts_hover(css = glue("r:{r}px;")),
        opts_tooltip(css = tooltip_css)) |> 
      girafe_options(...)
  } else {
    plot
  }
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

if(.Platform$OS.type=="windows")
  Sys.setlocale(locale = "fr_FR.utf8") else
    Sys.setlocale(locale = "fr_FR")

margin_download <- function(data, output_name = "donnees", label = "données") {
  if(knitr::is_html_output()) {
    if(lobstr::obj_size(data)> 1e+5)
      cli::cli_alert("la taille de l'objet est supérieure à 100kB")
    fn <- str_c("ofce-prev2409-", tolower(output_name))
    downloadthis::download_this(
      data,
      icon = "fa fa-download",
      class = "dbtn",
      button_label  = label,
      output_name = fn)
  } else
    return(invisible(NULL))
}

margin_download2 <- function(data, label = "données", output_name = "donnees") {
  htmltools::tags$div(
    class = "no-row-height column-margin column-container",
    downloadthis::download_this(
      data,
      icon = "fa fa-download",
      class = "dbtn",
      button_label  = label,
      output_name = output_name))
}


inline_download <- function(data, label = "données", output_name = "donnees") {
  downloadthis::download_this(
    data,
    icon = "fa fa-download",
    class = "dbtn-inline",
    button_label  = label,
    output_name = output_name
  )
}

ccsummer <- function(n=4) PrettyCols::prettycols("Summer", n=n)
ccjoy <- function(n=4) PrettyCols::prettycols("Joyful", n=n)

bluish <- ccjoy()[1]
redish <- ccjoy()[2]
yelish <- ccsummer()[2]
greenish <- ccsummer()[4]
darkgreenish <- ccsummer()[3]
darkbluish <- ccjoy()[4]

pays_long <- c(FRA = "France", EUZ = "Zone euro", DEU = "Allemagne", ESP = "Espagne", GBR = "Royaume-Uni", USA = "Etats-Unis d'Amérique",
               BRA = "Brésil", CHI = "Chine", PECO = "Pays d'Europe centrale et orientale", NLD = "Pays-Bas", CHE = "Suisse",
               NOR = "Norvège", GRC = "Grèce", SWE  = "Suède", ITA = "Italie", AUT = "Autriche", FIN = "Finlande", AUS = "Australie",
               BEL  = "Belgique", DEN = "Danemark", PRT = "Portugal", CAN ="Canada", MEX = "Mexique", IND = "Inde", JPN= "Japon")

tableau_labels <- c("En %", "T1", "T2", "T3", "T4", "T1", "T2", "T3", "T4", "", "", "")
tableau.font.size <- 12

out_graphes <- if(Sys.getenv("OUTGRAPHS") == "TRUE") TRUE else FALSE



date_trim <- function(date) {
  str_c("T", lubridate::quarter(date), " ", lubridate::year(date))
}

date_mois <- function(date) {
  str_c(lubridate::month(date,label = TRUE, abbr = FALSE), " ", lubridate::year(date))
}

date_jour <- function(date) {
  str_c(lubridate::day(date), " ", lubridate::month(date,label = TRUE, abbr = FALSE), " ", lubridate::year(date))
}

annotate_prevision <- function(posy = 1, xstart = "2024-07-01", xend = "2025-12-31", ymin = -Inf, ymax = Inf, size = 3) {
  midx <- (as.Date(xend) - as.Date(xstart))/2 + as.Date(xstart)
  list(
    ggplot2::annotate(
      "rect",
      xmin = as.Date(xstart), xmax = as.Date(xend),
      ymin = ymin, ymax = ymax, alpha = 0.2, fill = "gray"),
    ggplot2::annotate(
      "text",
      x=midx, y = posy,
      label="Prévisions", size = size,
      color="grey20", hjust = 0.5))
}


annotate_prevision_year <-function(posy = 1, xstart = 2024, xend = 2025, ymin = -Inf, ymax = Inf, size = 3) {
  list(
    ggplot2::annotate(
      "rect",
      xmin = xstart, xmax = xend,
      ymin = ymin, ymax = ymax, alpha = 0.2, fill = "gray"),
    ggplot2::annotate(
      "text",
      x=.5*(xstart+xend), y = posy,
      label="Prévisions", size= size,
      color="grey20", hjust = 0.5))
}

graph2prev <- function(graph, label, chunk = knitr::opts_current$get()) {
  if(!out_graphes)
    return(invisible(NULL))
  if(!exists("partie")|!exists("compteur"))
    return()
  if(is.null(label))
    label <- name <- rlang::as_name(rlang::enquo(graph))
  
  ratio <- chunk$fig.width/chunk$fig.height
  
  rep <- str_c(here::here("graphes"), "/", partie)
  dir.create(rep, recursive = TRUE)
  fn <- stringr::str_c(rep, "/g", compteur, "-", label)
  
  ofce::graph2svg(graph, file = str_c(fn, ".1610"), rep = "", ratio = 16/10)
  ofce::graph2png(graph, file = str_c(fn, ".1610"), rep = "", ratio = 16/10, dpi = 1200)
  saveRDS(object = graph, file = str_c(fn, ".ggplot"))
  
  if(length(ratio)>0) {
    ofce::graph2svg(graph, file = str_c(fn, ".original"), rep = "", ratio = ratio)
    ofce::graph2png(graph, file = str_c(fn, ".original"), rep = "", ratio = ratio, dpi = 1200)
  }
  
  compteur <<- compteur + 1
}

safe_find_root <- purrr::safely(rprojroot::find_root)
root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
if(is.null(root$error))
  ofce.project.root <- root$result
