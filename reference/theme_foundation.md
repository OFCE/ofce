# Theme foundation

This theme is designed to be a foundation from which to build new
themes, and not meant to be used directly. `theme_foundation()` is a
complete theme with only minimal number of elements defined. It is
easier to create new themes by extending this one rather than
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
or [`theme_bw()`](https://ggplot2.tidyverse.org/reference/ggtheme.html),
because those themes define elements deep in the hierarchy.

## Usage

``` r
theme_foundation(une_base_size = 12, base_family = "")
```

## Arguments

- base_family:

  base font family

## Value

un thème qui peut être utilisé dans ggplot

## Details

This theme takes
[`theme_gray()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
and sets all `colour` and `fill` values to `NULL`, except for the
top-level elements (`line`, `rect`, and `title`), which have
`colour = "black"`, and `fill = "white"`. This leaves the spacing
and-non colour defaults of the default ggplot2 themes in place.

## See also

Other themes:
[`theme_ofce()`](https://ofce.github.io/ofce/reference/theme_ofce.md),
[`theme_ofce_void()`](https://ofce.github.io/ofce/reference/theme_ofce_void.md)
