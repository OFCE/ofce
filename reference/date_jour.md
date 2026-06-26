# Date en jour

Transforme une date dans le format 2025-01-01 -\> 1er janvier 2025

## Usage

``` r
date_jour(
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
