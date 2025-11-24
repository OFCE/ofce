# Rend un graphique interactif (avec ggiraph)

Cette fonction prend en charge le passage par ggirapoh, en spécifiant
les options importantes (dont les tooltips) Possiblement, elle
enregistre le graphique pour usage ultérieur (dans une présentation)
ainf de garantir l'unicité des sources Elle prend en charge également la
sortie pdf si nécessaire L'interactivité repose sur l'utilisation des
fonctions de `ggiraph` `geom_*_interactive()`

## Usage

``` r
girafy(plot, r = 2.5, o = 0.5, id = NULL, tooltip_css = .tooltip_css, ...)
```

## Arguments

- plot:

  le graphique ggplot

- r:

  (1.5) le rayon du zoom sur le point en cas de hover

- o:

  (0.5) l'opacité des autres éléments en cas de hover

- id:

  utilisé pour tabsetize

- ...:

  autres options passées à `girafe_options()`

- out:

  (NULL) répertoire pour enregistrer

## Value

un ggplot ou un objet ggiraph
