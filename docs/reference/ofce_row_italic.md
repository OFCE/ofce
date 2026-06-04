# Mets une ligne en italique

Mets une ligne en italique

## Usage

``` r
ofce_row_italic(data, row = everything())
```

## Arguments

- data:

  le tableau gt passé en paramètre

- row:

  le sélecteur de ligne

## Value

un tableau gt

## See also

[`ofce_tab_options()`](ofce_tab_options.md),
[`ofce_caption()`](ofce_caption.md),
[`ofce_cols_fill()`](ofce_cols_fill.md),
[`ofce_spanners_bold()`](ofce_spanners_bold.md),
[`ofce_align_decimal()`](ofce_align_decimal.md),
[`ofce_fmt_decimal()`](ofce_fmt_decimal.md),
[`ofce_hide_col_pdf()`](ofce_hide_col_pdf.md)

## Examples

``` r
head(mtcars) |> gt::gt() |> ofce_row_italic(gear == 4)
#> Error in tab_style(data, style = cell_text(style = "italic"), locations = cells_body(rows = {    {        row    }})): could not find function "tab_style"
```
