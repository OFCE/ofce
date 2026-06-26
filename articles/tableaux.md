# Recommandations pour les tableaux OFCE

## Les tableaux dans quarto

### Différentes façons de faire apparaître un tableau dans un quarto

Pour faire figurer un tableau dans un markdown, il y a plusieurs
méthodes

1.  La capture d’écran

Ça peut se faire, mais ça ne se fait pas, donc on ne fera pas.

2.  L’intégration brute du data.frame dans le qmd

Dans l’absolu, un data.frame peut être directement intégré dans un qmd
sans manipulation supplémentaire.

Quelques remarques :

- En cas de base de données larges, cela prend trop de place sur le
  documents
- le formatage reste sommaire et difficile à améliorer
- des packages markdown peuvent être appelés pour

3.  La syntaxe markdown

Ce format peut convenir pour les tableaux à texte. Il est cependant
difficile à formater et éditer.

4.  L’utilisation de packages R pour les tableaux formatés

Cette méthode est à priviligier pour tout tableau contenant des données
principalement numériques ou extraites de base de données.

Plusieurs packages existent: `huxtable`, `flextable`, `formattable`,
`gt` etc..

Le package privilégié pour l’ofce est `gt`.

On notera cependant que d’autres package peuvent présenter quelques
fonctionnalités supplémentaires qui peuvent être intéressantes pour
certaines applications. Par exemple, le package `flextable` est très
utiles si le document de sortie est un `.docx` et est plus flexible sur
la gestion des cellules mergées.

### Comment faire un tableau

Pour faire un tableau, nous conseillons *vivement* d’utiliser
[gt](https://gt.rstudio.com). Le principe est assez simple, un peu comme
dans [ggplot2](https://ggplot2.tidyverse.org) on ajoute des couches qui
petit à petit construisent le tableau. Ca peut paraître fastidieux, mais
ça ne l’est pas tant que ça : c’est ce qu’on fait dans excel ou word
pour mettre en forme un tableau. L’intérêt de
[gt](https://gt.rstudio.com) c’est de dissocier la phase données de la
phase mise en page.

Le manuel de [gt](https://gt.rstudio.com) est d’une lecture simple, avec
plein d’exemples : [Easily Create Presentation-Ready Display Tables • gt
(rstudio.com)](https://gt.rstudio.com/)

Le code d’un [gt](https://gt.rstudio.com) est du genre :

``` r
library(gt)

# le fichier excel est préformaté, un onglet contient les données 
# prêtes à l'utilisation
readxl::read_xlsx(
  "analyses/Tables/patrimoine menages.v2.xlsx", 
  sheet = "masspat") |> 
  # on filtre les lignes les colonnes dont on a besoin
  filter(tranche %in% c("0-90%", "90-99%", "99-100%", "Total")) |> 
  select(-revraw) |> 
  # on les met dans l'ordre souhaité, 
  # plus le tibble est comme le tableau final le mieux c'est
  relocate(tranche, revdisp) |> 
  # pour avoir les chiffres par tête on fait un dernier mutate
  mutate(across(c(revdisp, tot, fi, pro, imm, autre), ~.x/30.5*1000/men)) |>
  select(-men) |> 
  mutate(tranche = str_replace(tranche, "Total", "Moyenne")) |>
  # gt sert à fabriquer le tableau mis en forme
  # a partir de là, plus de manip possible
   gt() |> 
  # le spanner regroupe des colonnes sous un même label
   tab_spanner(columns = -c(tranche, revdisp), label  = "Patrimoine") |> 
  # on a gardé les noms simples dans les données, on les traduit en clair ici
  # on privilégie cette approche : qui permet de corriger dans le qmd le texte
  # qui permet de traduire
  # qui permet d'uniformiser les labels si on a plusieurs tableaux
  cols_label(tranche = "", revdisp = "Revenu disponible", 
             tot = "Total", fi = "Financier", 
             pro  = "Professionnel", imm = "Immobilier", 
             autre = "Autres") |> 
  # idem, on passe des nombres, on les formatte ici
  fmt_number(columns = -tranche, scale = 1,
             n_sigfig = 3,  decimals = 0, sep_mark = " " ) |> 
  # on met en gras en en darkred une ligne -- notez la syntaxe élégante de gt
  tab_style(style = cell_text(weight = "bold", color = "darkred"), 
            locations = cells_body(rows = tranche == "Moyenne")) |> 
  # indispensable, les sources. md() permet d'avoir un texte enrichi qui comprend markdown
  # <br> retourne à la ligne dans la note
  # on met les notes ici, ca permet corrections, uniformisation et traduction
  tab_source_note(
    md(
   22222   "Revenu disponible brut et actifs bruts (hors passif) par ménage, en euros, année 2022
      <br>Calculs réalisés à partir de l'enquête patrimoine des ménages 2017-2018 de l'Insee croisés avec les comptes nationaux du patrimoine de l'Insee de 2022
      <br>*Sources* : Insee, calculs OFCE"))
```

#### D’autres solutions pour les tableaux

Le pire du pire est de mettre le tableau comme une copie d’écran d’excel
ou d’un pdf. C’est à banir.

Moins pire est d’utiliser la syntaxe `markdown`. Ca peut paraître plus
simple mais c’est rapidement dépassé et permet très peu de présentation
avancée.
