# exécute le fichier rinit.R à la racine du projet, ou dans \_utils, ou en dessous. s'il ne le trouve pas il utilise une version par défaut, stockée dans le package et qui est copiée dans le répertoire du projet

exécute le fichier rinit.R à la racine du projet, ou dans \_utils, ou en
dessous. s'il ne le trouve pas il utilise une version par défaut,
stockée dans le package et qui est copiée dans le répertoire du projet

## Usage

``` r
init_qmd(
  init = "rinit.r",
  echo = FALSE,
  message = FALSE,
  warning = FALSE,
  local = getOption("ofce.init_qmd.local")
)
```

## Arguments

- init:

  nom du fichier à utiliser (`"rinit.r"` par défaut)

- echo:

  (défaut FALSE) passé aux chunks

- message:

  (défaut FALSE) passé aux chunks

- warning:

  (défaut FALSE) passé aux chunks
