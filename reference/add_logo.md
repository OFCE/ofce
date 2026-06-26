# Add logo

Ajoute le logo de l'OFCE sur le graphique (inside donc)

## Usage

``` r
add_logo(plot, logo = NULL, size = 0.25)
```

## Arguments

- plot:

  un graphique ggplot

- logo:

  un logo au format png, avec une transparence (si NULL utilise le logo
  OFCE)

- size:

  la taille du logo (relative)

## Value

un graphique ggplot

## Details

Fin de vie. Ne plus utiliser

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
plot <- ggplot(mtcars) +
        geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
        theme_ofce()
# plot |> add_logo()
} # }
```
