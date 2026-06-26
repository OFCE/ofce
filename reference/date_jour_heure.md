# Date en jour / avec l'heure

Transforme une date dans le format trimestriel standard (revue de
l'OFCE) 2025-01-01 -\> 1 janvier 2025 12h02

## Usage

``` r
date_jour_heure(
  date,
  locale = "fr_FR.UTF-8",
  tz = "Europe/Paris",
  short = FALSE,
  compact = FALSE,
  abbr = FALSE
)
```

## Arguments

- date:

  la date

- locale:

  "fr_FR"

- tz:

  Time zone

- short:

  format court

- abbr:

  abrège les noms de mois

## Value

une chaine de caractères

## Examples

``` r
date_jour("2025-10-01")
#> Error in Sys.setlocale("LC_TIME", locale): (converted from warning) OS reports request to set locale to "fr_FR.UTF-8" cannot be honored
```
