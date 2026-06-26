# Formate en milliards d'euros

Semblable aux innombrables fonctions de formatage formate en français
("," et " " comme séparateurs)

## Usage

``` r
fmt_mds(x, log = 3, digits = 1, suffix = " Mds €")
```

## Arguments

- x:

  le nombre

- log:

  (defaut 3) différence en log10 entre l'origine et la destination 3
  passe de millions à milliards

- digits:

  (defaut 1) nombre de chiffres après la virgule

- suffix:

  (defaut " Mds €") ajoute un suffix

## Value

string

## Examples

``` r
fmt_mds(0.12)
#> [1] "120,0 Mds €"
```
