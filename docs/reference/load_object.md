# Lit un objet sauvegardé

Lorsque `ofce.savegraph` est non NULL, chaque graphique qui passe dans
`girafy` est enregistré dans le dossier `ofce.savegraph`. Son nom est
formé en ajoutant le dossier qui le contient, le nom du fichier .qmd, le
label du fichier (séparé par des tirets) par exmple : "index-fig-psal"
ou "france-synthese-fig-indicateurs"

## Usage

``` r
load_object(object, ext = "ggplot")
```

## Arguments

- object:

  (string) nom du graphique composé du dossier d'un tiret du nom du
  document d'un tiret et du label du graphique

- ext:

  ("ggplot") extension à utiliser

## Value

un ggplot ou un gt
