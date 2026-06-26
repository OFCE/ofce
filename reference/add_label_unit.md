# Add label unit

Ajoute un label pour les unités sur le plus grand des labels y

## Usage

``` r
add_label_unit(plot, ylabel = "")
```

## Arguments

- plot:

  un graphique ggplot

- ylabel:

  string, un label

## Value

un graphique ggplot

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
plot <- ggplot(mtcars) +
        geom_point(aes(x=mpg, y=hp, size=cyl, col=gear)) +
        theme_ofce(base_family="Nunito")
# plot |> add_label_unit("horse power")
} # }
```
