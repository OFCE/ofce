# Logo de l'OFCE

Ajoute le logo de l'OFCE sur le graphique

## Usage

``` r
logo_ofce(size = 1)
```

## Arguments

- size:

  (1 par défaut) la taille relative du logo (1 c'est bien)

## Value

un élément ggplot ( + )

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
plot <- ggplot(mtcars) +
        geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
        theme_ofce() +
        logo_ofce()
} # }
```
