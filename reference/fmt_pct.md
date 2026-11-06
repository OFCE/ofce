# Formate un nombre en pourcent

Semblable aux innombrables fonctions de formatage formate en français
("," et " " comme séparateurs)

## Usage

``` r
fmt_pct(x, digits = 0, plus = FALSE)
```

## Arguments

- x:

  le nombre

- digits:

  (defaut 0) nombre de chiffres après la virgule

- plus:

  (defaut FALSE) force un signe `+` si positif

## Value

string

## Examples

``` r
fmt_pct(0.12)
#> [1] "12%"
```
