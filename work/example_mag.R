library(tidyverse)
library(ggplot)
library(ofce)
library(purrr)
library(stringr)
library(lubridate)
library(eurostat)
# devtools::install_github("AllanCameron/geomtextpath", quiet = TRUE)
library(geomtextpath)
library(ggh4x)
load("work/IC_DR_ECFIN.Rda")
v_source <- ""
# un calcul un peu complqué pour les breaks, faudra le mettre à sa place dans le package ofce
#
bb <- {
  ymin <- min(lubridate::year(IC_DR_ECFIN$period))
  ymax <- max(lubridate::year(IC_DR_ECFIN$period))
  breaks <- c(ymin, seq(floor(ymin/5)*5, ceiling(ymax/5)*5, 5), ymax) |> unique()
  lubridate::ym(str_c(breaks, "-01"))  }

IC_DR_ECFIN <- IC_DR_ECFIN |> mutate(period = lubridate::ymd(period))

g_IC_DR<- ggplot(IC_DR_ECFIN, aes(x=period)) +
  geom_line(aes(y=DE_ic, color="DE"), size=1, key_glyph="timeseries")+
  geom_line(aes(y=EA19_ic, color="EA19"), size=1, color="black", key_glyph="timeseries")+
  geom_line(aes(y=ES_ic, color="ES"), size=1, key_glyph="timeseries")+
  geom_line(aes(y=IT_ic,color="IT"), size=1, key_glyph="timeseries")+
  geom_line(aes(y=FR_ic,color="FR"), size=1, key_glyph="timeseries")+
  # theme_void(base_family="Nunito", base_size=6)+ (ca sert à rien)
  labs( x = "Date", y = NULL,  color = NULL , # tu peux tout mettre dans labs NULL ne garde pas l'espace pour le texte
        title="Indice de difficultés de recrutement",
        caption=str_c("Source:  ", v_source, ", DG ECFIN",
                      ", Business and consumer surveys.   ",
                      "\nIndicateur pondéré par la part de l'emploi dans l'industrie, les services et la construction.") #\n fait un retour à la ligne
  )+
  scale_color_manual(values = ofce_palette(4))+
  theme_ofce()+
  annotate(geom="text", x = as.Date("2018-10-01"), y = 17, label="zone euro", size = 3, fontface = "bold" , color="black")+
  theme(legend.position=c(0.1, 0.9))+
  # scale_x_date(breaks = bb , date_minor_breaks = "1 year", guide="axis_minor", date_labels = "%Y")
 scale_x_date(date_breaks = "5 years" , date_minor_breaks = "1 year", guide="axis_minor", date_labels = "%Y") # alternative pas mal aussi

g_IC_DR
# je pivote tes données pour éviter d'avoir à taper tous les geom_line,
# du coup on peut utiliser l'échelle directement
#  je transforme les codes en nom, ça tient

data <- IC_DR_ECFIN |>
  pivot_longer(cols = -period) |>
  mutate(name = str_remove(name, "_ic"),
         name = label_eurostat(name, dic="geo", lang = "fr"),
         name = if_else(str_detect(name, "Allemagne"), "Allemagne", name),
         name = if_else(str_detect(name, "Zone euro"), "Zone euro", name))

#  et ensuite j'utilise le package geomtextpath qui est trop cool
# (bien installer la version github, il y a des fonctionnalités en plus, le rendu est meilleur)
#  les noms sont sur la courbe et ils la suivent, en couleur
#  et d'un coup de baguette magique
#
g_IC_DR_2<- ggplot(data, aes(x=period, y=value, col = name, group=name)) +
  # geom_line(key_glyph="timeseries")+ # option 1
  geom_line(size = 0.5, alpha=0.25, show.legend = FALSE)+ # permet de garder la trace sous le texte (accessoire)
  geom_textline(aes(label=name), size = 3, padding=unit(1, "mm"), linewidth=0.5, text_smoothing = 30, show.legend = FALSE)+
  labs( x = NULL, y = NULL,  color = NULL , # tu peux tout mettre dans labs NULL ne garde pas l'espace pour le texte
        title="Indice de difficultés de recrutement",
        caption=str_c("Source:  ", v_source, ", DG ECFIN",
                      ", Business and consumer surveys.   ",
                      "\nIndicateur pondéré par la part de l'emploi dans l'industrie, les services et la construction."))+
  scale_color_manual(values = c( ofce_palette(4), "gray15"))+
  theme_ofce()+
  scale_y_continuous(minor_breaks = minor_breaks_unity, guide="axis_minor")+ # ca met des breaks mineurs (ggh4x)
  scale_x_date(breaks = bb , date_minor_breaks = "1 year", guide="axis_minor", date_labels = "%Y")
  # scale_x_date(date_breaks = "5 years" , date_minor_breaks = "1 year", guide="axis_minor", date_labels = "%Y") # alternative pas mal aussi

g_IC_DR_2
