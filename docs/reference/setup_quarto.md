# Extensions OFCE pour quarto

Installe gentiment les extensions quarto suivantles templates OFCE Trois
templates sont prévus et s'insèrent dans un yml (ou dans la section yml)
comme suit format: ofce-html: default \# on peut ajouter tous les champs
html ofce-pdf: default \# pour les pdf, à affiner ofce-revealjs: default
\# pour les présentations

## Usage

``` r
setup_quarto(dir = ".", quiet = FALSE)
```

## Arguments

- dir:

  Répertoire dans lequel l'extension est installée

- quiet:

  Ne fait pas de bruit (défault FALSE)

## Details

Il est possible de spécifier toutes les éléments habituels des formats
sous jacents par la syntaxe habituelle

Si le document à rendre est dans un dossier, il faut utiliser l'argument
dir et l'extension sera installé à cet endroit
