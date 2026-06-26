# Obtenir les URLs des icônes Twemoji à partir de codes hexadécimaux Unicode

Prend un vecteur de codes hexadécimaux Unicode et retourne les URLs
correspondantes des fichiers SVG ou PNG Twemoji hébergés sur le CDN
cdnjs. Utiliser
[`show_emojis()`](https://ofce.github.io/ofce/reference/show_emojis.md)
pour parcourir la liste des emojis disponibles et trouver les codes
hexadécimaux correspondants.

## Usage

``` r
get_icons(
  hex,
  tooltip = FALSE,
  size = 15,
  format = c("svg", "png"),
  out = NULL
)
```

## Arguments

- hex:

  Un vecteur de chaînes de caractères contenant des codes hexadécimaux
  Unicode (par exemple `"1F430"` pour le lapin). Les codes peuvent être
  en majuscules ou minuscules. Les valeurs `NA` sont conservées dans le
  résultat.

- tooltip:

  Logique. Si `TRUE`, retourne une balise HTML `<img>` prête à l'emploi
  (utile pour les tooltips ou les tableaux HTML). Si `FALSE` (par
  défaut), retourne uniquement l'URL. Ignoré si `out` est fourni.

- size:

  Taille en pixels de l'icône dans le rendu HTML (par défaut `15`).
  Utilisé uniquement quand le format de sortie est `"html"`.

- format:

  Format de l'image : `"svg"` (par défaut) ou `"png"` (72×72 px).

- out:

  Format de sortie : `"url"` (URL brute), `"md"` (syntaxe Markdown
  `![](url)`), `"html"` (balise `<img>`), ou `"path"` (chemin local). Si
  `NULL` (par défaut), le format est déterminé par `tooltip` (`FALSE` →
  `"url"`, `TRUE` → `"html"`). Quand `out` est fourni, il prend le
  dessus sur `tooltip`.

## Value

Un vecteur de chaînes de caractères. Les éléments `NA` en entrée
produisent des `NA` en sortie.

## Examples

``` r
get_icons("1F430")
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg"
get_icons(c("1F430", "1F600"))
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg"
#> [2] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f600.svg"
get_icons("1F430", tooltip = TRUE)
#> [1] "<img src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg' style='height:15px;width:15px;vertical-align:-2px;'>"
get_icons("1F430", tooltip = TRUE, size = 20)
#> [1] "<img src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg' style='height:20px;width:20px;vertical-align:-2px;'>"
get_icons("1F430", format = "png")
#> [1] "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/72x72/1f430.png"
get_icons("1F430", out = "md")
#> Error in loadNamespace(x): there is no package called ‘rsvg’
get_icons("1F430", out = "html", size = 24)
#> [1] "<img src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg' style='height:24px;width:24px;vertical-align:-2px;'>"
```
