# Enregistre un graphe

Enregistre un graphe

## Usage

``` r
save_graph(
  graph,
  label = NULL,
  chunk = knitr::opts_current$get(),
  document = knitr::current_input(),
  id = NULL,
  dest = getOption("ofce.savegraph.dir")
)
```

## Arguments

- graph:

  le ggplot

- label:

  son label (mis à partir de knitr si possible)

- chunk:

  les infos de chunk (de knitr)

- document:

  le nom du document qmd (à partir de quarto)

- id:

  un id pour les tabset

- dest:

  le dossier de sauvegarde (ofce.savegraph)

## Value

le graphique, avec un effet de bord qui est le ggplot enregistré
