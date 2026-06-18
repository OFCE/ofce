# Vide le cache

Vide le cache

## Usage

``` r
clear_source_cache(
  what = source_data_status(root = root),
  cache_rep = NULL,
  root = NULL
)
```

## Arguments

- what:

  (–) un tibble issu de source_data, éventuellement filtré

- data_rep:

  le répertoire de cache

## Value

la liste des fichiers supprimés

## See also

Other source_data:
[`set_cache_rep`](https://ofce.github.io/ofce/reference/set_cache_rep.md)`()`,
[`source_data`](https://ofce.github.io/ofce/reference/source_data.md)`()`,
[`source_data_refresh`](https://ofce.github.io/ofce/reference/source_data_refresh.md)`()`,
[`source_data_status`](https://ofce.github.io/ofce/reference/source_data_status.md)`()`
