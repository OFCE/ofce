## rinit.r est exécuté par init_qmd(), normalement en début de qmd.
## On peut ajouter toute fonction ou toute option que l'on souhaite propager sur l'ensemble de son projet.

library(knitr)
opts_chunk$set(
  fig.pos="htb",
  out.extra="",
  dev="svg",
  dev.args = list(bg = "transparent"),
  out.width="95%",
  fig.showtext=TRUE,
  message = qmd_message,
  warning = qmd_warning,
  echo = qmd_echo,
  error = TRUE)

library(tidyverse)
library(glue)
library(ggiraph)
library(ofce)
library(yaml)
library(gt)
library(marquee)
library(readxl)

systemfonts::add_fonts(system.file("fonts", "OpenSans", "OpenSans-Regular.ttf", package="ofce"))

options(
  ofce.base_size = 12,
  ofce.background_color = "transparent",
  ofce.source_data.src_in = "project",
  ofce.caption.ofce = FALSE,
  ofce.marquee = TRUE,
  ofce.caption.srcplus = NULL,
  ofce.caption.wrap = 0,
  sourcoise.init_fn = ofce::init_qmd,
  sourcoise.grow_cache = Inf,
  ofce.output_extension = "xlsx",
  ofce.savegrah = FALSE,
  ofce.output_prefix = "ofce-")

showtext::showtext_opts(dpi = 120)
showtext::showtext_auto()

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

ggplot2::set_theme(
  theme_ofce(
    marquee = TRUE,
    plot.subtitle =element_text(face = "italic", margin = margin(0, 0, 20, 0)),
    plot.title = element_marquee(width=0.9 ,lineheight = 0.85,margin = margin(b = 10)),
    plot.caption = element_marquee(width=0.95),
    legend.position = c(0.05, 1)
  ) 
)

if(knitr::is_html_output())
  ggplot2::update_theme(text = element_text(size = 10)) else
    ggplot2::update_theme(text = element_text(size = 9),
                          plot.title = element_blank(),
                          plot.subtitle = element_blank()
                          )

if(.Platform$OS.type=="windows")
  Sys.setlocale(locale = "fr_FR.utf8") else
    Sys.setlocale(locale = "fr_FR")

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

conflicted::conflict_prefer_all("dplyr", quiet = TRUE)
conflicted::conflicts_prefer(lubridate::year, .quiet = TRUE)
conflicted::conflicts_prefer(lubridate::month, .quiet = TRUE)
conflicted::conflicts_prefer(lubridate::quarter, .quiet = TRUE)

####
options(ofce.output_prefix = "g_")
titre <- rmarkdown::metadata$title
auteur <- rmarkdown::metadata$author[[1]]$name

if(!knitr::is_html_output()){
  opts_chunk$set(
    fig.pos="htb",
    out.extra="",
    dev="svg",
    dev.args = list(bg = "transparent"),
    out.width="95%",
    fig.showtext=TRUE,
    message = qmd_message,
    warning = qmd_warning,
    echo = qmd_echo,
    error = TRUE)
  
}
