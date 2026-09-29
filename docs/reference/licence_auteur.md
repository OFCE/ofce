# Licence avec auteur et logo

Ajoute le logo OFCE, l'icône Creative Commons et le nom de l'auteur dans
`plot.tag` en utilisant
[`munch::element_md()`](https://ardata-fr.github.io/munch/reference/element_md.html)
avec des images markdown inline. Le tag est affiché verticalement
(rotation 90°) et positionné par défaut en haut à droite du graphique.

## Usage

``` r
licence_auteur(
  author = "",
  logo = NULL,
  license = TRUE,
  year = getOption("ofce.licence.year"),
  text_size = getOption("ofce.licence.text_size"),
  color = "grey3",
  tag_position = getOption("ofce.licence.tag_position"),
  tag_location = "plot"
)
```

## Arguments

- author:

  Chaîne de caractères. Nom de l'auteur affiché dans le tag (par défaut
  `""`).

- logo:

  Chaîne de caractères ou `NULL`. Chemin vers le fichier image du logo.
  Si `NULL` (par défaut), utilise `logo_down.png` inclus dans le
  package.

- license:

  Logique. Si `TRUE` (par défaut), affiche l'icône Creative Commons
  (`cc_icon_down.png`) avant le nom de l'auteur.

- year:

  Numérique ou `NULL`. Année affichée après le nom de l'auteur (par
  défaut `2026`). Si `NULL`, l'année est omise.

- text_size:

  Numérique. Taille du texte en points (par défaut `2.5`). Multipliée
  par
  [ggplot2::.pt](https://ggplot2.tidyverse.org/reference/graphical-units.html)
  pour le rendu dans
  [`munch::element_md()`](https://ardata-fr.github.io/munch/reference/element_md.html).

- color:

  Chaîne de caractères. Couleur du texte (par défaut `"grey3"`).

- tag_position:

  Vecteur numérique de longueur 2. Position (x, y) du tag en coordonnées
  normalisées (par défaut `c(0.98, 0.99)`).

- tag_location:

  Chaîne de caractères. Emplacement du tag, passé à
  [`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
  via `plot.tag.location` (par défaut `"plot"`).

## Value

Une liste d'éléments ggplot2
([`ggplot2::labs()`](https://ggplot2.tidyverse.org/reference/labs.html)
et
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html))
à ajouter à un graphique avec `+`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
ggplot(mtcars) +
  geom_point(aes(x = mpg, y = hp)) +
  theme_ofce() +
  licence_auteur(author = "X. Timbeau")
} # }
```
