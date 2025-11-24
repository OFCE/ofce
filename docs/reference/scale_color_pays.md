# Palette de couleur associée à un sous-ensemble de pays, compatible avec les normes graphiques de la revue OFCE

Le code "oth" correspond à "Autres" et propose un gris clair.

## Usage

``` r
scale_color_pays(
  format = "iso3",
  lang = "fr",
  name = NULL,
  aesthetics = c("color", "fill"),
  ...
)
```

## Arguments

- format:

  chr, le format des données ("iso3", "eurostat", "fr" pour les noms en
  clair, et tous les codes qu'accepte countrycode::countrycode)

- lang:

  chr, le choix de la langue c("fr","en")

- name:

  titre de la légende

- aesthetics:

  couleur ou fill ou les deux

- ...:

  passé à scale_colour_manual

## Value

un scale configuré
