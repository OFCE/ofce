# Options de tableau gt par défaut pour les standards OFCE

Applique des options de style cohérentes aux tableaux gt selon les
standards graphiques de l'OFCE. Configure la taille des polices, les
espacements, les bordures et les marques de notes de bas de page.

## Usage

``` r
ofce_tab_options(data, ..., typst_width = NULL)
```

## Arguments

- data:

  Un objet gt table

- ...:

  Arguments supplémentaires passés à
  [`gt::tab_options()`](https://gt.rstudio.com/reference/tab_options.html)
  qui remplaceront les valeurs par défaut OFCE

- typst_width:

  Largeur du tableau en sortie typst, en % de la largeur du texte
  (`NULL` par défaut, le tableau garde alors la largeur que lui donne
  typst). Les largeurs demandées par
  [`gt::cols_width()`](https://gt.rstudio.com/reference/cols_width.html)
  ne survivent pas à la conversion vers typst : la largeur passée ici
  est répartie entre les colonnes visibles en respectant leurs
  proportions. Sans effet hors typst.

## Value

Un objet gt table avec les options de style appliquées

## Details

Les options par défaut appliquées sont :

- `footnotes.font.size = "90%"` - Taille réduite pour les notes

- `source_notes.font.size = "100%"` - Taille normale pour les sources

- `quarto.disable_processing = TRUE` - Désactive le traitement Quarto

- `table_body.hlines.style = "none"` - Pas de lignes horizontales dans
  le corps

- `column_labels.padding = 3` - Espacement des en-têtes de colonnes

- `data_row.padding = 2` - Espacement des lignes de données

- `footnotes.multiline = FALSE` - Notes sur une seule ligne

- `footnotes.padding = 5` - Espacement des notes

- `source_notes.padding = 2` - Espacement des sources

- `table.border.bottom.style = "none"` - Pas de bordure inférieure

- `row_group.padding = 2` - Espacement des groupes de lignes

- `table.font.names` - Pile de polices sans famille générique CSS, que
  typst ne sait pas interpréter (option `ofce.tab.font.names`)

Les marques de notes de bas de page utilisent des lettres (a, b, c,
etc.) via
[`gt::opt_footnote_marks()`](https://gt.rstudio.com/reference/opt_footnote_marks.html).

## See also

[`gt::tab_options()`](https://gt.rstudio.com/reference/tab_options.html),
[`ofce_caption()`](https://ofce.github.io/ofce/reference/ofce_caption.md),
[`ofce_cols_fill()`](https://ofce.github.io/ofce/reference/ofce_cols_fill.md),
[`ofce_spanners_bold()`](https://ofce.github.io/ofce/reference/ofce_spanners_bold.md),
[`ofce_row_italic()`](https://ofce.github.io/ofce/reference/ofce_row_italic.md),
[`ofce_align_decimal()`](https://ofce.github.io/ofce/reference/ofce_align_decimal.md),
[`ofce_fmt_decimal()`](https://ofce.github.io/ofce/reference/ofce_fmt_decimal.md),
[`ofce_hide_col_pdf()`](https://ofce.github.io/ofce/reference/ofce_hide_col_pdf.md)

## Examples

``` r
library(gt)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# Tableau simple avec options OFCE
mtcars |>
  head() |>
  gt() |>
  ofce_tab_options()


  

mpg
```
