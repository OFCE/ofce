% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/init_qmd.R
\name{pathify}
\alias{pathify}
\title{déroule le chemin à partir du début du projet}
\usage{
pathify(path, root = NULL)
}
\arguments{
\item{path}{chemin}

\item{root}{racine (absolu), NULL par défaut}
}
\value{
chemin absolu (string)
}
\description{
Lorsque le chemin commence par un "/", il est calculé à partir de la racine du projet
}
