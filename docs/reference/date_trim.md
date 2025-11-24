# Date en trimestriel

Transforme une date dans le format trimestriel standard (revue de
l'OFCE) 2025-01-01 -\> T1 2025 2025-04 -\> T2 2025

## Usage

``` r
date_trim(date)
```

## Arguments

- date:

  la date

## Value

une chaine de caractères

## Examples

``` r
date_trim("2025-10-01")
#> Error in str_c("T", lubridate::quarter(date), " ", lubridate::year(date)): could not find function "str_c"
```
