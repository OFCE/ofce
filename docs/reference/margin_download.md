# Bouton de téléchargement

Cette fonction peremt d'ajouter un bouton de télchargement dans la marge
d'un document quarto. Elle repose sur `downloadthis` et prépare le div
pour son affichage correct. Elle doit être appelée dans un chunk `r`
avec `results="asis"` impérativement.

## Usage

``` r
margin_download(
  data,
  output_name = "donnees",
  label = "données",
  margin = TRUE,
  output_extension = getOption("ofce.output_extension"),
  prefix = getOption("ofce.output_prefix")
)
```

## Arguments

- data:

  les données à téélcharger (un tibble donc)

- output_name:

  ("données" par défaut) le nom du fichier de sortie

- label:

  ("données") le nom du bouton qui apparaît dans le rendu du quarto

- margin:

  (TRUE) si FALSE le bouton est inline (non implémenté pour le moment)

- prefix:

  préfixe pour les fichiers téléchargés (`ofce.output_prefix` par
  défaut)

- format:

  format du ficher à télécharger, mis en option du package (
  `ofce.output_extension` par défaut), peut être ".csv", ".xlsx"

## Value

NULL (side effect : du markdown)
