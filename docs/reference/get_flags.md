# Obtenir les icônes de drapeaux à partir de codes ou noms de pays

Convertit un vecteur de codes pays ISO 3166-1 alpha-2, alpha-3 ou de
noms de pays (dans n'importe quelle langue) en URLs ou balises HTML des
drapeaux Twemoji correspondants, en s'appuyant sur
[`get_icons()`](https://ofce.github.io/ofce/reference/get_icons.md). La
détection du format est automatique via le package countrycode.

## Usage

``` r
get_flags(
  country,
  tooltip = FALSE,
  size = 15,
  format = c("svg", "png"),
  out = NULL
)
```

## Arguments

- country:

  Un vecteur de chaînes de caractères contenant des codes pays ISO2
  (`"FR"`), ISO3 (`"FRA"`) ou des noms de pays dans n'importe quelle
  langue (`"France"`, `"Allemagne"`, `"Germany"`). On peut mélanger les
  formats dans le même vecteur. Les valeurs `NA` sont conservées dans le
  résultat.

- tooltip:

  Logique. Si `TRUE`, retourne une balise HTML `<img>`. Si `FALSE` (par
  défaut), retourne uniquement l'URL. Passé à
  [`get_icons()`](https://ofce.github.io/ofce/reference/get_icons.md).

- size:

  Taille en pixels de l'icône lorsque `tooltip = TRUE` (par défaut
  `15`). Passé à
  [`get_icons()`](https://ofce.github.io/ofce/reference/get_icons.md).

- format:

  Format de l'image : `"svg"` (par défaut) ou `"png"` (72×72 px). Passé
  à [`get_icons()`](https://ofce.github.io/ofce/reference/get_icons.md).

- out:

  Format de sortie : `"url"`, `"md"`, ou `"html"`. Passé à
  [`get_icons()`](https://ofce.github.io/ofce/reference/get_icons.md).

## Value

Un vecteur de chaînes de caractères contenant les URLs ou balises HTML
des drapeaux Twemoji. Les éléments `NA` en entrée ou les pays non
reconnus produisent des `NA` en sortie.

## Examples

``` r
get_flags("FR")
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1eb-1f1f7.svg"
get_flags(c("FRA", "DEU", "USA"))
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1eb-1f1f7.svg"
#> [2] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1e9-1f1ea.svg"
#> [3] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1fa-1f1f8.svg"
get_flags(c("FR", "DEU", "US"))
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1eb-1f1f7.svg"
#> [2] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1e9-1f1ea.svg"
#> [3] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1fa-1f1f8.svg"
get_flags("France")
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1eb-1f1f7.svg"
get_flags(c("Allemagne", "Italy", "Estados Unidos"))
#> Warning: Pays non reconnus : "Allemagne" and "Estados Unidos".
#> [1] NA                                                                         
#> [2] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1ee-1f1f9.svg"
#> [3] NA                                                                         
get_flags("FRA", tooltip = TRUE)
#> [1] "<img src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1eb-1f1f7.svg' style='height:15px;width:15px;vertical-align:-2px;'>"
get_flags("FRA", format = "png")
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/72x72/1f1eb-1f1f7.png"
```
