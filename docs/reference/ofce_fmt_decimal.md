# Formate en français les nombres

Formate en français les nombres

## Usage

``` r
ofce_fmt_decimal(
  data,
  columns = tidyselect::where(is.numeric),
  rows = tidyselect::everything(),
  decimals = 1
)
```

## Arguments

- data:

  le tableau gt passé en paramètres

- columns:

  les colonnes sélectionnées (tout ce qui est numérique par défaut)

- rows:

  les lignes sélectionnées (tout par défaut)

- decimals:

  (le nombre de chiffres après la , 1 par défaut)

## Value

un tableau gt

## See also

[`ofce_tab_options()`](https://ofce.github.io/ofce/reference/ofce_tab_options.md),
[`ofce_caption()`](https://ofce.github.io/ofce/reference/ofce_caption.md),
[`ofce_cols_fill()`](https://ofce.github.io/ofce/reference/ofce_cols_fill.md),
[`ofce_spanners_bold()`](https://ofce.github.io/ofce/reference/ofce_spanners_bold.md),
[`ofce_row_italic()`](https://ofce.github.io/ofce/reference/ofce_row_italic.md),
[`ofce_align_decimal()`](https://ofce.github.io/ofce/reference/ofce_align_decimal.md),
[`ofce_hide_col_pdf()`](https://ofce.github.io/ofce/reference/ofce_hide_col_pdf.md)

## Examples

``` r
head(mtcars) |> gt::gt() |> ofce_fmt_decimals()
#> Error in ofce_fmt_decimals(gt::gt(head(mtcars))): could not find function "ofce_fmt_decimals"
```
