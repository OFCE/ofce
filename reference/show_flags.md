# Afficher les drapeaux correspondant à un vecteur de pays

Produit un graphique interactif (via ggiraph) montrant les drapeaux
Twemoji associés à chaque pays. Le survol d'un label affiche le drapeau
en tooltip HTML.

## Usage

``` r
show_flags(country)
```

## Arguments

- country:

  Un vecteur de chaînes de caractères (codes ISO2, ISO3 ou noms de
  pays). Passé à
  [`get_flags()`](https://ofce.github.io/ofce/reference/get_flags.md).

## Value

Un objet `girafe` (widget HTML interactif).

## Examples

``` r
if (FALSE) { # \dontrun{
show_flags(c("FRA", "DEU", "USA", "Japon"))
} # }
```
