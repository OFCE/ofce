# Date en jour

Transforme une date dans le format trimestriel standard (revue de
l'OFCE) 2025-01-01 -\> 1 janvier 2025

## Usage

``` r
date_jour(date)
```

## Arguments

- date:

  la date

## Value

une chaine de caractères

## Examples

``` r
date_jour("2025-10-01")
#> Error in str_c(lubridate::day(date), " ", lubridate::month(date, label = TRUE,     abbr = FALSE), " ", lubridate::year(date)): could not find function "str_c"
```
