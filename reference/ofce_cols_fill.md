# Teinte les colonnes choisies en fond de couleur

Teinte les colonnes choisies en fond de couleur

## Usage

``` r
ofce_cols_fill(data, columns, fill = getOption("ofce.tab.fill"))
```

## Arguments

- data:

  le tableau gt passé en paramètre

- columns:

  les colonnes à teinter

- fill:

  la couleur (par défaut "#FFEDED")

## Value

tableau gt

## Examples

``` r
head(mtcars) |> gt::gt() |> ofce_cols_fill(disp)
#> Error in tab_style(data, style = cell_fill(color = fill), locations = cells_body(columns = {    {        columns    }})): could not find function "tab_style"
```
