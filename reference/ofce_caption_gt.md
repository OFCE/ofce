# fabricateur de source pour les tableaux

permet de construire un caption facilement avec un wrapping, le passage
dans glue

## Usage

``` r
ofce_caption_gt(
  object,
  source = "",
  note = "",
  lecture = "",
  champ = "",
  code = "",
  dpt = "",
  subtitle = "",
  title = "",
  dptf = "month",
  wrap = ifelse(getOption("ofce.marquee"), 0, getOption("ofce.caption.wrap")),
  lang = getOption("ofce.caption.lang"),
  ofce = getOption("ofce.caption.ofce"),
  author = getOption("ofce.caption.author"),
  srcplus = getOption("ofce.caption.srcplus"),
  marquee_translate = ifelse(getOption("ofce.marquee"), TRUE,
    getOption("ofce.caption.marquee_translate")),
  glue = getOption("ofce.caption.glue"),
  ...
)
```

## Arguments

- object:

  l'objet gt

- source:

  texte de la source (sans le mot source qui est rajouté)

- note:

  texte de la note (sans le mot note qui est rajouté)

- lecture:

  texte de la note de lecture (sans le mot lecture qui est rajouté)

- champ:

  texte du champ (sans le mot champ qui est rajouté)

- code:

  texte du code (sans le mot code qui est rajouté)

- dpt:

  dernier point connu

- subtitle:

  inclu le label du sous titre (pour le traduire avec marquee/glue)

- title:

  inclu le titre (traduit aussi)

- dptf:

  fréquence du dernier point connu (day, month, quarter, year)

- wrap:

  largeur du texte en charactères (120 charactères par défaut, 0 ou NULL
  si on utilise marquee)

- lang:

  langue des textes (fr par défaut)

- ofce:

  (bool) si TRUE ajoute calculs OFCE à source, sinon rien, TRUE par
  défaut

- author:

  (bool) si TRUE ajoute calculs des auteurs à source, sinon rien, FALSE
  par défaut

- srcplus:

  (string) chaine (comme calculs OFCE) à ajouter à source (à la fin)

- marquee_translate:

  transforme ^x^ en .sup x et ~x~ en .sub x

- glue:

  applique glue avant toute chose

- ...:

  autres paramètres

## Value

un objet gt (gt() \|\> ofce_caption_gt("INSEE"))

## Details

on commence par la source, une note, et une lecture
