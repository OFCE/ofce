# Mets les spanners en gras

Mets les spanners en gras

## Usage

``` r
ofce_spanners_bold(data)
```

## Arguments

- data:

  le tableau gt passé en paramètre

## Value

un tableau gt

## See also

[`ofce_tab_options()`](ofce_tab_options.md),
[`ofce_caption()`](ofce_caption.md),
[`ofce_cols_fill()`](ofce_cols_fill.md),
[`ofce_row_italic()`](ofce_row_italic.md),
[`ofce_align_decimal()`](ofce_align_decimal.md),
[`ofce_fmt_decimal()`](ofce_fmt_decimal.md),
[`ofce_hide_col_pdf()`](ofce_hide_col_pdf.md)

## Examples

``` r
head(mtcars) |> gt::gt() |> gt::tab_spanner("spanner A", c(am, gear, carb)) |> ofce_spanners_bold()
#> Error in tab_style(data, style = cell_text(weight = "bold"), locations = gt::cells_column_spanners()): could not find function "tab_style"
```
