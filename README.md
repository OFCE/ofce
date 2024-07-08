# package OFCE pour R

Ce package met à dispositon des outils utilisés régulièrement à l'OFCE, que ce soit pour la production de documents quarto ou de mise en page de graphiques `ggplot2`

## Installation

Le package s'installe par la commande du package `pak`(si vous ne l'avez pas déjà installé, lancez d'abord la commande suivante:`install.packages("pak")`)

``` r
pak::pak("ofce/ofce")
```
## Mise à jour des templates quarto OFCE
Les templates existants (hébergés sur le repo [ofce-quarto-extensions](https://github.com/OFCE/ofce-quarto-extensions)) sont mis-à-jour de manière continue dans un souçi d'amélioration constant. Pour récupérer la dernière version, il suffit de lançer la commande `setup_quarto`qui installera en local la dernière version des extensions pour votre document. 

## Utilisation

La présentation du 13 Novembre en séminaire lunch est une rapide introduction au package (reproduite via ce [lien](https://ofce.github.io/ofce/)). 

Pour une description plus complète, vous pouvez lancez la commande suivante dans la console RStudio qui recense l'ensemble des fonctions du package : `library(help="ofce")` ou `?nom_de_la_function`.

Sur le [site qui documente le package](https://ofce.github.io/ofce/)) vous trouverez des documents détaillant tous les aspects de l'utilisation du package et de la réalisation de documents à l'OFCE -- les chartes graphiques.


