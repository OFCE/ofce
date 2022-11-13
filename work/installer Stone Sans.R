# pour installer Stone Sans dans R
#
# Il faut d'abord installer Stone Sans à partir des fichiers dans le dossier stone-sans-cufonfonts
#
# Ensuite il faut installer cette version de ce package

remotes::install_version("Rttf2pt1", version = "1.3.8")
extrafont::font_import(pattern="Stone",recursive = TRUE, prompt=FALSE)
extrafont::loadfonts(device="all")
extrafont::font_import()
extrafont::loadfonts()

# vérifier que agg est le moteur graphique (global options/R général/Graphics sélectionner AGG)
