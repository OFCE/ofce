% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quarto.R
\name{setup_quarto}
\alias{setup_quarto}
\title{Extensions OFCE pour quarto}
\usage{
setup_quarto(dir = ".", quiet = FALSE)
}
\arguments{
\item{dir}{Répertoire dans lequel l'extension est installée}

\item{quiet}{Ne fait pas de bruit (défault FALSE)}
}
\description{
Installe gentiment les extensions quarto suivantles templates OFCE
Trois templates sont prévus et s'insèrent dans un yml (ou dans la section yml) comme suit
format:
ofce-html: default # on peut ajouter tous les champs html
ofce-pdf: default # pour les pdf, à affiner
ofce-revealjs: default # pour les présentations
}
\details{
Il est possible de spécifier toutes les éléments habituels des formats sous jacents par la syntaxe habituelle

Si le document à rendre est dans un dossier, il faut utiliser l'argument dir et l'extension sera installé à cet endroit
}
