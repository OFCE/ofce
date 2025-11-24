# Extrait les données eurostat SNA

Cette fonction permet d'extraire rapidement des données des comptes
naitonaux sur eurostat. Elle utilise la fonction
[`get_eurostat`](https://ropengov.github.io/eurostat/reference/get_eurostat.html)
et effectue plusieurs opérations supplémentaires:

- Elle met en cache le fichier eurostat, dans un dossier dans le
  répertoire courant/ Le chache est accédé avec qs pour plus de rapidité
  [`get_eurostat`](https://ropengov.github.io/eurostat/reference/get_eurostat.html)
  utilise un cachee, mais il est très lent. Cette fonction est utilisée
  la première fois.

- Elle sélectionne les données à partir des paramètres retourne un
  tibble avec uniquement ces colonnes. Les données sont retournées en
  formet long sauf si on défini une variable de pivot. Les dimensions ne
  prenant qu'une valeur sont éliminées.

- Elle documente les colonnes éliminées.

## Usage

``` r
sna_get(
  dataset,
  ...,
  pivot = "auto",
  prefix = "",
  name = "",
  cache = "./data/eurostat",
  select_time = NULL,
  lang = "en",
  force = FALSE
)
```

## Arguments

- dataset:

  string, le code eurostat du dataset en minuscule

- ...:

  une série de paramètres du nom des champs présents dans le dataset,
  suivi des valeurs qui sont sélectionnées, soit une chaîne, sous un
  vecteur de chaînes

- pivot:

  un vecteur de variables qui seront utilisées pour le pivot

- prefix:

  un prefix ajouté à tous les noms de variables

- name:

  nom de la base

- cache:

  string, le chemin d'accès au cache

- select_time:

  la période de temps téléchargée lors du chargement initial. N'est aps
  très utile sauf pour limiter l'empreinte disque.

- lang:

  langue

- force:

  télécharge systématiquement

## Value

un tibble, avec un attribut par colonne qui documente

## See also

sna_show qui affiche des informations sur la base

## Examples

``` r
# récupère toute la base des comptes annuels pour le pib et ses composantes
if(interactive()) sna_get("nama_10_gdp")
# ne garde que certaines colonnes
if(interactive()) sna_get("nama_10_gdp", unit='CLV05_MEUR', na_item = "B1G", geo=c("DE", "FR"))
```
