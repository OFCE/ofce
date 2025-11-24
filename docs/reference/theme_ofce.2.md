# Thème OFCE 2

Applique le theme ofce compatible avec la norme des working papers
d'autres éléments de la norme comme les couleurs, l'allure générale du
graphique sont à introduire par ailleurs

## Usage

``` r
theme_ofce.2(
  base_size = getOption("ofce.base_size"),
  base_family = getOption("ofce.base_family"),
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
  [`theme`](https://ggplot2.tidyverse.org/reference/theme.html)`()`

## Value

un thème qui peut être utilisé dans ggplot

## See also

Other themes:
[`theme_foundation`](https://ofce.github.io/ofce/reference/theme_foundation.md)`()`,
[`theme_ofce`](https://ofce.github.io/ofce/reference/theme_ofce.md)`()`,
[`theme_ofce_void`](https://ofce.github.io/ofce/reference/theme_ofce_void.md)`()`
