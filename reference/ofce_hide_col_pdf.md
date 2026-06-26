# Masque des colonnes en pdf

Lorsqu'on utilise des colonnes qui peuvent bloquer en pdf, comme les
nanoplots, cette fonction sert à les enlever sélectivement.

## Usage

``` r
ofce_hide_col_pdf(tbl, col)
```

## Arguments

- tbl:

  le gt passé en paramètre

- col:

  les colonnes sélectionnées

## Value

un gt

## Details

Encore à tester avec typst

## See also

[`ofce_tab_options()`](https://ofce.github.io/ofce/reference/ofce_tab_options.md),
[`ofce_caption()`](https://ofce.github.io/ofce/reference/ofce_caption.md),
[`ofce_cols_fill()`](https://ofce.github.io/ofce/reference/ofce_cols_fill.md),
[`ofce_spanners_bold()`](https://ofce.github.io/ofce/reference/ofce_spanners_bold.md),
[`ofce_row_italic()`](https://ofce.github.io/ofce/reference/ofce_row_italic.md),
[`ofce_align_decimal()`](https://ofce.github.io/ofce/reference/ofce_align_decimal.md),
[`ofce_fmt_decimal()`](https://ofce.github.io/ofce/reference/ofce_fmt_decimal.md)

## Examples

``` r
head(mtcars) |> gt::gt() |> cols_hide_pdf(disp)
#> Error in cols_hide_pdf(gt::gt(head(mtcars)), disp): could not find function "cols_hide_pdf"
```
