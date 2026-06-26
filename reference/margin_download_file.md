# Bouton de téléchargement d'un fichier

Cette fonction peremt d'ajouter un bouton de télchargement dans la marge
d'un document quarto. Elle repose sur
[`downloadthis::download_file`](https://rdrr.io/pkg/downloadthis/man/download_file.html)
et prépare le div pour son affichage correct. Elle doit être appelée
dans un chunk `r` avec `results="asis"` impérativement.

## Usage

``` r
margin_download_file(
  path,
  output_name = fs::path_file(path),
  label = "données",
  margin = TRUE,
  prefix = getOption("ofce.output_prefix")
)
```

## Arguments

- path:

  le chemin du fichier à télécharger

- output_name:

  (`fs::path_file(path)` par défaut) le nom du fichier de sortie

- label:

  ("données") le nom du bouton qui apparaît dans le rendu du quarto

- margin:

  (TRUE) si FALSE le bouton est inline (non implémenté pour le moment)

- prefix:

  préfixe pour les fichiers téléchargés (`ofce.output_prefix` par
  défaut)

## Value

NULL (side effect : du markdown)
