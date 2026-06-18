# Lit un graphique sauvegardé

Lorsque `ofce.savegraph` est non NULL, chaque tableau qui passe dans
`save_gt` est enregistré dans le dossier `ofce.savegraph`. Son nom est
formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le
label du fichier (séparé par des tirets) par exmple : "index-fig-psal"
ou "france-synthese-fig-indicateurs"

## Usage

``` r
load_graphe(object)
```

## Arguments

- object:

  (string) nom du graphique composé du dossier d'un tiret du nom du
  document d'un tiret et du label du graphique

## Value

un ggplot

## See also

[`load_object()`](https://ofce.github.io/ofce/reference/load_object.md)
