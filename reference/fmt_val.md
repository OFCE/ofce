# Formate un nombre

Semblable aux innombrables fonctions de formatage formate en français
("," et " " comme séparateurs)

## Usage

``` r
fmt_val(x, digits = 1, scale = 1, suffix = "")
```

## Arguments

- x:

  le nombre

- digits:

  (defaut 1) nombre de chiffres après la virgule

- scale:

  (defaut 1) échelle (mulitplie par ce nombre)

- suffix:

  (defaut "") ajoute un suffix

## Value

string

## Examples

``` r
fmt_val(10.56, 1, 1, " euros")
#> [1] "10,6 euros"
```
