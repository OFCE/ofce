# Palette de couleurs associée de type divergente qui à partir de deux codes HEX génère une palette de n couleurs compatible avec les normes graphiques de la revue OFCE

Palette de couleurs associée de type divergente qui à partir de deux
codes HEX génère une palette de n couleurs compatible avec les normes
graphiques de la revue OFCE

## Usage

``` r
ofce_palette_div(colors = c("#005DA4", "#C51315"), n = NULL)
```

## Arguments

- colors:

  un vecteur de deux couleurs à partir duquel la palette est générée.

- n:

  integer, nombre de couleurs

## Value

un vecteur de couleurs de taille n

## Examples

``` r
ofce_palette_div(n = 4)
#> [1] "#005DA4" "#2263A6" "#9E4545" "#993D3D"
```
