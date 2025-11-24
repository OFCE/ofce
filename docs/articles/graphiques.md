# Faire un graphique

Il y a au moins trois méthodes pour mettre un graphique dans dans un
document quarto : [ggplot2](https://ggplot2.tidyverse.org),
copier-coller, fichier image.

## ggplot2

La façon préférée de faire un graphique est
[ggplot2](https://ggplot2.tidyverse.org). Elle est la plus flexible,
permet d’avoir une source unique, peut être facilement modifiée
(uniformisation, traduction, correction, raffinements) et s’intègre
parfaitement en html et en pdf.

Avec un faible coût on peut rendre le graphique interactif (avec
[plotly](https://plotly-r.com) ou
[ggiraph](https://davidgohel.github.io/ggiraph/)).

Un graphique `ggplot` doit contenir une couche (layer)
[`theme_ofce()`](https://ofce.github.io/ofce/reference/theme_ofce.md) et
limiter au maximum les définitions de taille (par exemple de police de
caractère). Ces définitions doivent être faites de façon globale pour
assurer l’homogénéité. **Il est important de ne pas définir la taille de
la figure, ça risque de produire des images avec des caractères trop
petits**.

Pour changer les dimensions d’un graphique, il faut utiliser[^1]
`#| fig-asp : x` ou `x` est le ratio entre la hauteur et la longueur.
0.61 est la valeur par défaut et correspond au nombre d’or soit entre
16/9 et 16/10. Pour des graphiques particuliers (par exemple deux
graphiques empilés ou une carte) on peut mettre 1 (format carré) ou 1.4
quand on veut prendre toute la page A4.

Le code d’un graphique [ggplot2](https://ggplot2.tidyverse.org) :

``` r
#| label: fig-tauxapp
#| fig-cap: Taux de taxation apparent sur le patrimoine des ménages
#| fig-asp: 0.61
# pas besoin d'en mettre plus, echo, message, warning sont déjà définis

data <- readxl::read_xlsx(
  "analyses/Tables/patrimoine menages.v2.xlsx",
1  sheet = "tapp")

names(data) <- c("date", "vn", "pib")
data <- data |> mutate(date = lubridate::ym(str_c(date, "-01"))) |> 
  pivot_longer(cols  = c(vn, pib)) |> 
  mutate(name = factor(name, c("vn", "pib"),
                       c("En % de la valeur nette", "En % du PIB")))
                       
# un ggplot et ses différentes couches
ggplot(data) + 
  aes(x = date, y = value, group = name, col = name, fill = name) +
  geom_line(linewidth = 1) +
  geom_point(shape = 21, col = "white", size = 2) +
2  theme_ofce(legend.position = "bottom") +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y", 
3               date_minor_breaks = "year") +
4  PrettyCols::scale_color_pretty_d(name = NULL, palette = "Summer") +
  PrettyCols::scale_fill_pretty_d(name = NULL, palette = "Summer") +
  ylab("Taux apparent") + xlab(NULL) +
  scae_y_continuous(labels = \(x) str_c(x, "%")) +
  labs(caption =
         "La fiscalité sur le patrimoine est composée ici de la taxe foncière payée par les ménages, <br>
       des droits d'enregistrement sur les transactions immobilières, des droits de mutation sur les successions et les donations et de l'Impôt sur la Fortune Immobilière (ex-ISF)<br>
5       *Sources* : Insee, calculs OFCE")
```

- 1:

  Les données sont dans excel – elles pourraient venir de R ou
  d’ailleurs. La feuille `tapp` est formattée simplement

- 2:

  Utilisez le `theme_ofce` pour uniformiser l’aspect des graphiques

- 3:

  `scale_date` est important lorsqu’on présente des données temporelles,
  il faut penser à convertir les dates en dates (as.Date() ou
  lubridate::ymd() et consorts), même si les dates ne sont que des
  années.

- 4:

  Le choix des couleurs est tjrs délicat, Paul Malliet est un maître en
  la matière, uniformiser ses choix de couleurs le long d’un document
  c’est bien, donner une signification à ses couleurs c’est mieux, quand
  en plus c’est harmonieux, c’est PM (plus que mieux ou Paul Malliet)

- 5:

  Les sources – notez qu’on ne met pas de titre au graphique (voir la
  section références croisées)

## Copier-coller

On peut copier coller un graphique (de word, d’excel, d’ailleurs) dans
le mode visuel de RStudio. Ça marche mais c’est pas le mieux. Quand on
copie colle, on fait quelque chose qui ressemble à l’option qui suit.

## Image au format png/jpeg/jpg/svg

On peut enregistrer une image (au format que l’on veut, `quarto` accepte
pas mal d’options, dont les plus courantes) et l’insérer dans le texte.
Il y a deux façon de faire soit en `markdown` (dans le qmd, comme un
lien ou autre chose), soit en utilisant `include_graphics`. L’intérêt
par rapport au copier-coller est que si on change le fichier qui
contient l’image, à chaque *render* du document, la bonne (la dernière
version) image sera utilisée. Si on utilise des images venant de
`eviews` 💀 ou `stata` 😵, c’est la meilleure méthode.

``` md
[Titre de la figure](rep/fig.png)
```

Le **répertoire est toujours relatif**.

*Jamais de chemin absolu* comme
“`c:/user/machin/montravail/monrepo/monimage.png`” parce que ça ne
marchera pas sur un autre ordinateur et en plus `github` ne copiera pas
l’image) et par celui qui contient le `.qmd`. Il est toujours possible
de mettre les images dans un sous dossier.

Plus c’est simple et clair, mieux c’est (i.e. gardez les noms courts,
explicites, pas de majuscules, bien rangés, conservateurs dans
l’utilisation des caractères (**pas d’accents, pas de blancs, pas de
symboles spéciaux**). Donc `donnees/img.png` ou
`donnees/graphique 1a5.png` ne sont pas des bons noms. Mais
`figures/revenu.png` ou `figures/pib_par_tete.png` sont mieux.

``` r
#| label fig-pib2008_2024
#| fig-cap: PIB entre 2008 et 2024

knitr::include_graphics("pib2008_2024.png")
```

Notez la cohérence des id, nom et titre.

## Les autres packages

On peut faire des graphiques avec d’autres packages dans R, voire même
utiliser base R. Nous ne recommandons pas cette voie, parce qu’elle rend
très difficile l’harmonisation des graphiques et les fonctionnalités
avancées. Parfois, cependant, il n’y a pas d’autres solutions.

[^1]: donc on n’utilise pas `#| fig-width` ou `fig-height`.
