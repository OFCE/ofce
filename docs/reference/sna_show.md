# Infos sur une base sna Eurostat

Affiche les principales informations sur une base téléchargée sur
Eurostat. Les informations sont en partie stockées dans les attributs du
tibble. Ils peuvent être perdus en route.

## Usage

``` r
sna_show(sna, lang = "fr", n = 100)
```

## Arguments

- sna:

  le tibble téléchargé sur eurostat

- lang:

  langue

- n:

  nombre de lignes imprimées (par défaut n=100)

## Value

le tibble, invisible plus un effet de bord sur la console

## Examples

``` r
if(interactive()) {
data <- sna_get("nama_10_gdp")
sna_show(data)
}
```
