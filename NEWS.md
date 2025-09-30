## OFCE 1.3.20

* modification marginale de `tabsetize` (ajout d'une option, comportement différent en pdf et html)

## OFCE 1.3.19

* ajout de `pathify`

## OFCE 1.3.18

* ajout de `tabsetize` et `tabsetize2`

## OFCE 1.3.17

* init_qmd peut prendre sustématiquement le rinit.r dans le dossier du qmd (option local=TRUE)

## OFCE 1.3.16

* ofce dans ocfe_caption fonctionne comme attendu

## OFCE 1.3.15

* corrections de bugs dans `init_qmd()` (réécriture)

## OFCE 1.3.14

* corrections de bug dont `init_qmd()` et `board()`

## OFCE 1.3.13

* `source_data()` a son propre package `{sourcoise}`, qui est importé dans `{ofce}`.

## OFCE 1.3.12

* ajout de `bd_read()` et `bd_write()` pour l'accès à Azure

## OFCE 1.3.11

* modification de ofce_caption (traduit marquee)

## OFCE 1.3.10

* ajustement de theme_ofce et theme_ofce_void

## OFCE 1.3.9

* `marquee` passe en version 1.0, modification de `ofce_caption` pour en tenir compte (wrap = 0)

## OFCE 1.3.9

* `ofce_caption` : Ajout de *Champ* et options par défaut.

## OFCE 1.3.8

* `rinit.r` : Modification du mode chargement des packages pour vérifier l'installation des packages du rinit, installer les packages manquants au besoin, et les charger.

## OFCE 1.3.7

* `ofce_caption()` : Ajout d'une option auteurs pour calcul des auteurs plutôt que calcul OFCE (notamment pour les publications externes pour lesquels la responsabilité de l'OFCE n'est pas engagée)

## OFCE 1.3.6

* `source_data()` : fonctionne avec une nouvelle option src_in, qui relativise tout au répertoire qui contient le fichier source et le qmd, 
les données sont cachés dans ce répertoire. Destiné au blog et permet de déplacer les données avec le post.

## OFCE 1.3.5

* `source_data()` : les métadonnées sont dasn un fichier séparé et en json (facilite git)

## OFCE 1.3.4

* `source_data()` : correction de plusieurs bugs

## OFCE 1.3.3

* `source_data()` tracke des fichiers et peut *unfreezer* un qmd
* ajout de `source_data_refresh()`

## OFCE 1.3.2

* `source_data()` utilise un id unique pour chaque utilisateur, pour ne pas déclencher de conflits dans github
* `source_data()` accepte des arguments passés au source exécuté.

## OFCE 1.3.1

* `source_data()` utilise maintenant fs pour les fichiers - ce qui doit être plus robuste.

## OFCE 1.3.0

* ajout de `source_data()`, et de `source_data_status()`

## OFCE 1.2.1

* corrections de bugs 

## OFCE 1.2.0
  
* ajout de `ofce_caption()` ; ajout de `scale_ofce_date()`

* corrections de bugs mineurs

## OFCE 1.1.0

* documentation et vignettes

## OFCE 1.0.0

* première version avec notamment les fonctions :

** `theme_ofce()`
** `setup_quarto()`
** `setup_wp()`

