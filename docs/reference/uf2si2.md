# Formatte un vecteur en produisant des éléments distincts

Utilise f2si2 pour formatter un vecteur, et arrondi tant que les
éléments formattés sont tous disctints. Cela permet de les utiliser dans
une échelle ou pour des noms. Les nombres en entrée doivent être
différents

## Usage

``` r
uf2si2(number, rounding = TRUE, unit = "median", digits_max = 4)
```

## Arguments

- number:

  le nombre ou le vecteur de nombre

- rounding:

  doit-on arrondir ?

- unit:

  Arrondi soit à la "median" soit au "max"

- digits_max:

  le nombre maximal de chiffres après la virgule

## Value

une chaine de charactères

## Examples

``` r
uf2si2(c(1000,1100,2000,2100))
#> [1] "1k"   "1.1k" "2k"   "2.1k"
```
