# Rend un graphique interactif (avec ggiraph)

Cette fonction prend en charge le passage par ggiraph, en spécifiant les
options importantes (dont les tooltips). Elle enregistre le graphique
pour usage ultérieur (dans une présentation) afin de garantir l'unicité
des sources. L'interactivité repose sur l'utilisation des fonctions de
`ggiraph` `geom_*_interactive()`.

## Usage

``` r
girafy(
  plot,
  ...,
  r = 1.5,
  o = 0.5,
  id = NULL,
  pointsize = 12,
  width_svg = NULL,
  height_svg = NULL,
  tooltip_css = .tooltip_css,
  biratio = NULL
)
```

## Arguments

- plot:

  le graphique ggplot à rendre interactif

- ...:

  autres options passées à
  [`ggiraph::girafe_options()`](https://davidgohel.github.io/ggiraph/reference/girafe_options.html)

- r:

  (1.5) le rayon du zoom sur le point en cas de survol (en pixels)

- o:

  (0.5) l'opacité des autres éléments en cas de survol (entre 0 et 1)

- id:

  identifiant unique pour le graphique, utilisé pour l'enregistrement

- pointsize:

  \(12\) taille de la police pour le rendu SVG (en points)

- width_svg:

  largeur du graphique SVG en inches. Si NULL, déterminée
  automatiquement

- height_svg:

  hauteur du graphique SVG en inches. Si NULL, déterminée
  automatiquement

- tooltip_css:

  chaîne de style CSS personnalisé pour les tooltips. Utilise
  `.tooltip_css` par défaut (style intégré)

- biratio:

  vecteur numérique de longueur 2 pour le responsive design :
  `c(ratio_desktop, ratio_mobile)`. Par défaut NULL. Si fourni, génère
  deux versions du graphique adaptées à la largeur d'écran (desktop et
  mobile). Exemple : `c(0.6, 1.333)` produit un graphique plus carré
  pour desktop et plus haut pour mobile.

## Value

un objet ggiraph (en sortie HTML/interactive) ou un ggplot (en sortie
statique)
