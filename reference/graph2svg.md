# Enregistre un graphe en svg à la taille revue

Enregistrement d'un graphique avec une taille par défaut de 18 cm de
large et un ratio de 4/3 Les paramètres peuvent être facilement modifiés

## Usage

``` r
graph2svg(
  graph,
  file = "",
  rep = "svg",
  ratio = 4/3,
  height = width/ratio,
  width = 18,
  units = "cm",
  bg = "white",
  ...
)
```

## Arguments

- graph:

  un objet graphique (grid, un ggplot plus communément, mais aussi un
  objet tmap)

- file:

  Le chemin vers le fichier résultat (string)

- rep:

  le répertoire dans lequel on met les graphiques

- ratio:

  le ratio entre largeur et hauteur

- height:

  la hauteur, si la hauteur est spécifiée la ratio est ignoré

- width:

  la largeur

- units:

  l'unité ("cm" par exemple)

- bg:

  couleur du fond (background)

- ...:

  autres arguments à passer dans la fonction

## Value

l'objet en entrée, invisible, enregistre un .svg dans le répertoire avec
le nom donné
