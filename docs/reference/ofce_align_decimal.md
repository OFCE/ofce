# Aligne sur le séparateur décimal (,)

Si aucune colonne n'est passée en paramètre, alors toutes les colonnes
numériques sont alignées.

## Usage

``` r
ofce_align_decimal(data, columns = tidyselect::where(is.numeric))
```

## Arguments

- data:

  le tableau gt passé en paramètre

- columns:

  les colonnes sélectionnées

## Value

un tableau gt

## See also

[`ofce_tab_options()`](ofce_tab_options.md),
[`ofce_caption()`](ofce_caption.md),
[`ofce_cols_fill()`](ofce_cols_fill.md),
[`ofce_spanners_bold()`](ofce_spanners_bold.md),
[`ofce_row_italic()`](ofce_row_italic.md),
[`ofce_fmt_decimal()`](ofce_fmt_decimal.md),
[`ofce_hide_col_pdf()`](ofce_hide_col_pdf.md)

## Examples

``` r
head(mtcars) |> gt::gt() |> ofce_align_decimals(qsec)
#> Error in ofce_align_decimals(gt::gt(head(mtcars)), qsec): could not find function "ofce_align_decimals"
```
