# Worked examples

All examples come from the OFCE webblog repository (https://github.com/OFCE/webblog).

## 1. Legacy post migration — `posts/2024/20240524_RSMPXR`

Before: the `.qmd` chunk downloaded the Insee debt series inline; a Nov 2026
Insee API change (plus an `insee` 1.1.7 bug in `get_idbank_list()`) broke every
fresh render.

After:

`data/dette.r` (single dataset, direct idbank, period pinned to the article's
2007-2023 scope):

```r
# Données de dette publique (Insee, base DETTE-TRIM-APU-2020) ----
# Appelé depuis le .qmd via source_data("data/dette.r") ; résultat mis en cache
# dans data/.sourcoise/ (commité avec le billet).

# library() et non init_qmd() : ce billet historique n'utilise pas init_qmd,
# et init_qmd() modifierait les options knitr du rendu en cours.
library(insee)
library(dplyr)
library(lubridate)

# Idbank 010777608 : dette Maastricht S13, en % du PIB, trimestrielle.
data <-
  get_insee_idbank("010777608") %>%
  select(DATE, OBS_VALUE) %>%
  arrange(DATE) %>%
  filter(year(DATE) <= 2023) # le billet porte sur la période 2007-2023

return(data)
```

`.qmd` chunk (download replaced by the cached call; figures stay in the `.qmd`):

```r
# Téléchargement Insee (idbank 010777608, cf. data/dette.r) mis en cache
data <- source_data("data/dette.r")

min_annotate <- data %>% pull(OBS_VALUE) %>% min() - 1
max_annotate <- data %>% pull(OBS_VALUE) %>% max() + 1
```

`data/pib_imf.r` shows the multi-object case: the whole DBnomics/FMI pipeline
(download, trend computations) ends with
`return(list(data.final = ..., label.var = ..., test = ...))`, and the `.qmd`
unpacks `pib <- source_data("data/pib_imf.r")` then uses `pib$data.final` etc.
Only the plotting function (`graphique_tend()`) remained in the `.qmd`.

## 2. Recent post with nested scripts — `posts/2026/20260603_EH`

Structure:

```
posts/2026/20260603_EH/
├── 20260603_EH.qmd          # ofce::init_qmd() + source_data("data/prodeh.r")
└── data/
    ├── nace.r               # shared codes/pays source
    ├── naq10_e.R            # source_data("nace.r")$...
    ├── vaq.r                # source_data("nace.r")$nace, $pays3
    ├── prodeh.R             # source_data("nace.r"), source_data("naq10_e"), source_data("vaq.r")
    ├── prodeh25t4.xlsx      # tracked input
    └── .sourcoise/          # committed cache (.qs2 + .json)
```

Scripts start with `ofce::init_qmd()` because that post's `.qmd` also calls it.
The `.qmd` chunk is simply:

```r
data <- source_data("data/prodeh.r")
```

## Migration checklist

1. Identify every `rdb()`, `get_*()`, download or heavy data-prep block in the
   `.qmd` chunks.
2. Move each one to `posts/<post>/data/<name>.r`, ending with `return()`
   (named list if several objects).
3. Check packages used by the moved code are loaded in the script
   (`library()`; `init_qmd()` only if the `.qmd` uses it).
4. Check paths are relative to `data/`.
5. For published posts: pin the period if the charts should not drift when the
   source is revised.
6. Replace the moved code in the `.qmd` with `source_data(...)` and unpacking.
7. Render the post in a fresh process to verify and populate the cache.
8. Commit `data/` including `.sourcoise/`.
