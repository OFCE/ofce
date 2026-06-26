# Utilise le SI pour formatter les nombres en fonction des mulitples de 10^3

Utilise le SI pour formatter les nombres en fonction des mulitples de
10^3

## Usage

``` r
f2si2(number, rounding = TRUE, digits = 1, unit = "median")
```

## Arguments

- number:

  le nombre ou le vecteur à formatter (numérique)

- rounding:

  doit-on arrondir le chiffre ?

- digits:

  Combien de chiffres après la virgule

- unit:

  Arrondi soit à la "median" soit au "max"

## Value

une chaine de caractère (character) formattée

## See also

if2si2 (inverse la transformation)

## Examples

``` r
f2si2(100000)
#> [1] "100k"
```
