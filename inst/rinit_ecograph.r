## rinit.r est exécuté par init_qmd(), normalement en début de qmd.
## On peut ajouter toute fonction ou toute option que l'on souhaite propager sur l'ensemble de son projet.

library(knitr)
opts_chunk$set(
  fig.pos="htb",
  out.extra="",
  dev="svglite",
  dev.args = list(bg = "transparent"),
  out.width="100%",
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

scale_font_typst <- ifelse(exists("scale_font_typst"), scale_font_typst,1)  # argument à laisser à 1, sauf si format particulier, modifier dans le qmd directement
scale_font_html <- ifelse(exists("scale_font_html"), scale_font_html,1)  # argument à laisser à 1, sauf si format particulier, modifier dans le qmd directement

systemfonts::add_fonts(system.file("fonts", "OpenSans", "OpenSans-Regular.ttf", package="ofce"))


options(  
  # OutDec = ",",
  ofce.base_size = 9 * scale_font_html,
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
  "font-family:Arimo;
  background-color:snow;
  border-radius:5px;
  border-color:gray;
  border-style:solid;
  border-width:0.5px;
  font-size:9pt;
  padding:4px;
  box-shadow: 2px 2px 2px gray;
  r:20px;"

theme_gow <- theme_ofce(
  marquee = TRUE,
  plot.subtitle = element_text(face = "italic", margin = margin(t = 0, 0, b = 7, 0)),
  plot.title = element_marquee(width=0.95 ,lineheight = 0.85,margin = margin(b = 5)),
  plot.caption = element_marquee(width=1,margin = margin(t = 10, b = 2),size = 6.5,family = "Open sans" )
)

## theme_ofce() construit axis.text, axis.text.x et axis.text.y sans `style` :
## marquee lit la police dans le style et ignore le `family` herite de `text`,
## les etiquettes d'axes tombaient donc sur la police systeme (Helvetica) au
## lieu d'Open Sans. On leur redonne le style de base du theme. L'affectation
## doit se faire sur l'objet theme : passe par `+ theme(...)` ou par les `...`
## de theme_ofce(), le style est fusionne et reste sans effet.
style_gow <- marquee::classic_style(
  base_size = getOption("ofce.base_size"),
  body_font = getOption("ofce.base_family"),
  header_font = getOption("ofce.base_family"))

theme_gow$axis.text   <- element_marquee(size = rel(0.7), colour = "gray25", style = style_gow)
theme_gow$axis.text.x <- element_marquee(margin = margin(t = 0, b = 0), hjust = 0.5, style = style_gow)
theme_gow$axis.text.y <- element_marquee(hjust = 1, style = style_gow)

ggplot2::set_theme(theme_gow)


if(knitr::is_html_output())
  ggplot2::update_theme(text = element_text(size = 9 * scale_font_html)
                        ) else
    ggplot2::update_theme(
      text = element_text(size = 9 * scale_font_typst),
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
    dev="svglite",
    dev.args = list(bg = "transparent"),
    out.width="95%",
    fig.showtext=TRUE,
    message = qmd_message,
    warning = qmd_warning,
    echo = qmd_echo,
    error = TRUE)
  
}
