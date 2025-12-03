# Date en mois

Transforme une date dans le format mensuel standard (revue de l'OFCE)
2025-01-01 -\> janvier 2025 2025-04 -\> avril 2025

## Usage

``` r
date_mois(date)
```

## Arguments

- date:

  la date

## Value

une chaine de caractères

## Examples

``` r
date_mois("2025-10-01")
#> [1] "October 2025"
```
