# Reset RStudio prefs

Principalement, pas d'enregistrement de l'environnement, pipe natif,
ragg en backend graphique

## Usage

``` r
setup_RStudio(theme = "iPlastic", right_console = TRUE)
```

## Arguments

- theme:

  Theme à utiliser (défaut "iPlastic")

- right_console:

  Met la console à droite (défaut TRUE)

## Examples

``` r
if(interactive()) setup_RStudio()
```
