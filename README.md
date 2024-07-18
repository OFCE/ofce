# Publication de documents scientifiques <a href="https://ofce.github.io/ofce/"><img src="man/figures/logo.png" align="right" height="136" alt="ofce website" /></a>


Ce package met à disposition des outils utilisés régulièrement à l'OFCE, que ce soit pour la production de documents quarto ou de mise en page de graphiques `ggplot2`.

La charte graphique, les instructions de flux de travail, des exemples de documents et de code, des tutos sont sur [https://ofce.github.io/ofce/](https://ofce.github.io/ofce/).

N'hésitez pas à poster des *issues* sur ce dépôt pour toute remarque ou requête.

## Installation

Le package s'installe par la commande du package `pak` (si vous ne l'avez pas déjà installé, `install.packages("pak")`)

``` r
pak::pak("ofce/ofce")
```

## Mise à jour des templates quarto OFCE

Les templates existants sont mis à jour ; pour récupérer la dernière version, il suffit de lancer la commande `ofce::setup_quarto()` qui installera en local la dernière version des extensions pour votre projet.

Les formats disponibles sont :

``` r
---
format:
  ofce-html: default # une page en html
  wp-html: default # Document de travail en html
  wp-pdf: default # Document de travail en pdf
  wp-en-html: default # Document de travail html en anglais
  wp-en-html: default # Document de travail pdf en anglais
  pres-revealjs: default # presentation
  blog-html: default # Post de blog en html
  blog-pdf: default # Post de blog en pdf
---
```

## Utilisation

Pour une description plus complète, vous pouvez lancez la commande suivante dans la console RStudio qui recense l'ensemble des fonctions du package : `library(help="ofce")` ou `?nom_de_la_function`.

Sur le [site qui documente le package](https://ofce.github.io/ofce/) vous trouverez des documents détaillant tous les aspects de l'utilisation du package et de la réalisation de documents à l'OFCE -- les chartes graphiques.
