# Add logo

Ajoute le logo de l'OFCE en bas à droite du graphique

## Usage

``` r
add_logo_ofce(plot, logo = NULL, size = 0.04)
```

## Arguments

- plot:

  un graphique ggplot

- logo:

  un logo au format png, avec une transparence

- size:

  la taille du logo (relative)

## Value

un graphique ggplot

## See also

add_logo_ofce_inside

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
plot <- ggplot(mtcars) +
    geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
    theme_ofce()
# plot |> add_logo_ofce()
} # }
```
