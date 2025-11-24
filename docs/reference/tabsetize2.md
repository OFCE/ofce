# Tabsetize2 : tabset à deux étages

fabrique un tabset de tabset à partir d'une liste de liste de graphiques
(a priori des ggplots, mais cela peut être des chemins). Ne s'utilise
que dans un qmd ou un markdown (ca n'a pas de sens sinon). Les noms de
la liste sont utilisés pour les noms des onglets. Il est important de
mettre l'option `results="asis"` au chunk (ou `#| results: asis` dans le
chunk) Tabsetize prend en charge aussi les formats non intercatifs et
affiche la liste dépliée (d'autres possibilités viendront dans le futur)

## Usage

``` r
tabsetize2(
  list,
  facety = TRUE,
  cap = TRUE,
  girafy = FALSE,
  asp = NULL,
  r = 1.5
)
```

## Arguments

- list:

  liste des graphiques

- facety:

  (ne pas utiliser)

- cap:

  TRUE par défaut, insère une caption à la figure, spécifiée comme la
  caption du chunk (`#| fig-cap: un titre`).

- girafy:

  FALSE par défaut, wrappe avec girafy (qui doit être défini donc dans
  le rinit.r)

- asp:

  aspect de ratio, mais privilégiez l'aspect ratio général
  (`#| fig-asp: 1.1`)

- r:

  rayon du cercle de hover pour girafy (paramètre `r` de girafy)

## Value

string inserted in markdown
