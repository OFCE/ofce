# Applique le theme ofce compatible avec la norme de la Revue de l'OFCE Convient pour des cartes par exemple

Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
Convient pour des cartes par exemple

## Usage

``` r
theme_ofce_void(
  base_size = getOption("ofce.base_size"),
  base_family = getOption("ofce.base_family"),
  marquee = getOption("ofce.marquee"),
  ...
)
```

## Arguments

- base_size:

  double(1) Taille des éléments texte du thème. Peut être donné
  globalement par options(ofce.base_size=12).

- base_family:

  character(1) string, police de charactère du thème (globalement et
  défaut options(ofce.base_family="Nunito"))

- ...:

  paramètres passés à
  [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html)

## Value

un thème qui peut être utilisé dans ggplot

## See also

Other themes:
[`theme_foundation()`](https://ofce.github.io/ofce/reference/theme_foundation.md),
[`theme_ofce()`](https://ofce.github.io/ofce/reference/theme_ofce.md)
