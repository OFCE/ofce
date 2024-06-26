% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graph2xxx.R
\name{graph2jpg}
\alias{graph2jpg}
\title{Enregistre un graphe en jpg à la taille revue}
\usage{
graph2jpg(
  graph,
  file = "",
  rep = "svg",
  ratio = 4/3,
  height = width/ratio,
  width = 18,
  units = "cm",
  bg = "white",
  quality = 100,
  dpi = 600,
  ...
)
}
\arguments{
\item{graph}{un objet graphique (grid, un ggplot plus communément mais aussi un objet tmap)}

\item{file}{Le chemin vers le fichier résultat (string)}

\item{rep}{le répertoire dans lequel on met les graphiques}

\item{ratio}{le ratio entre largeu
r et hauteur}

\item{height}{la hauteur, si la hauteur est spécifiée la ratio est ignoré}

\item{width}{la largeur}

\item{units}{l'unité ("cm" par exemple)}

\item{bg}{couleur du fond (background)}

\item{quality}{qualité du fichier (par défault 100)}

\item{dpi}{résolution du fichier image crée (par défault 600)}

\item{...}{autres arguments à passer dans la fonction}
}
\value{
l'objet en entrée, invisible, enregistre un .jpeg dans le répertoire avec le nom donné
}
\description{
Enregistrement d'un graphique avec une taille par défaut de 18 cm de large et un ratio de 4/3
Les paramètres peuvent être facilement modifiés
}
