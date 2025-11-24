# Utilisation mémoire par objet

Permet de lister les plus gros objets en mémoire et de connaître leur
empreinte.

## Usage

``` r
showMemoryUse(
  sort = "size",
  decreasing = TRUE,
  limit = 10,
  envir = parent.frame()
)
```

## Arguments

- sort:

  Variable sur lequel le tri est fait (défaut "size", alternative
  "alphabetical")

- decreasing:

  En sens décroissant (défaut TRUE)

- limit:

  Nombre de lignes affichées (défaut 10)

- envir:

  l'environement dans lequel sont listé les objets. Mieux vaut ne pas le
  toucher si on ne sait pas à quoi ça sert.

## Value

Une liste des objets en mémoire, invisible et affiche dans la console
cette liste

## Details

copié de https://rdrr.io/github/zlfccnu/econophysics/ (merci!).

## Examples

``` r
showMemoryUse()
#> [1] "No objects"
```
