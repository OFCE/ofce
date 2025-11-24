# Tabsetize : fait un tabset à partir d'une liste

fabrique un tabset à partir d'une liste de graphiques (a priori des
ggplots). Ne s'utilise que dans un qmd ou un markdown (ca n'a pas de
sens sinon). On peut également passer des chaines de caractères qui sont
des chemins vers des images enregistrées. Cela peut permettre de faire
un rendu plus vite. Les noms de la liste sont utilisés pour les noms des
onglets Il est important de mettre l'option `results="asis"` au chunk
(ou `#| results: asis` dans le chunk) Tabsetize prend en charge aussi
les formats non intercatifs et affiche la liste dépliée (d'autres
possibilités viendront dans le futur)

## Usage

``` r
tabsetize(
  list,
  facety = TRUE,
  cap = TRUE,
  girafy = TRUE,
  asp = NULL,
  r = 1.5,
  pdf = getOption("ofce.tabsetize.pdf"),
  active = 1
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

  TRUE par défaut, wrappe avec girafy (qui doit être défini donc dans le
  rinit.r)

- asp:

  aspect de ratio, mais privilégiez l'aspect ratio général
  (`#| fig-asp: 1.1`)

- r:

  rayon du cercle de hover pour girafy (paramètre `r` de girafy)

- pdf:

  si l'output est pdf, doit-on aficher tous les graphiques ("all",
  défaut) ou un seul ("one")

## Value

string inserted in markdown
