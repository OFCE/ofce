# fabricateur de source pour les graphiques

permet de construire un caption facilement avec un wrapping on commence
par la source, une note, et une lecture

## Usage

``` r
ofce_caption(
  source = NULL,
  note = NULL,
  lecture = NULL,
  champ = NULL,
  code = NULL,
  dpt = NULL,
  xlab = NULL,
  ylab = NULL,
  subtitle = NULL,
  dptf = "month",
  wrap = ifelse(getOption("ofce.marquee"), 0, getOption("ofce.caption.wrap")),
  lang = getOption("ofce.caption.lang"),
  ofce = getOption("ofce.caption.ofce"),
  author = getOption("ofce.caption.author"),
  srcplus = getOption("ofce.caption.srcplus"),
  marquee_translate = ifelse(getOption("ofce.marquee"), TRUE,
    getOption("ofce.caption.marquee_translate")),
  glue = getOption("ofce.caption.glue")
)
```

## Arguments

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

- xlab:

  inclu le label de l'axe des x (pour le traduire avec marquee)

- ylab:

  inclu le label de l'axe des y (pour le traduire avec marquee)

- subtitle:

  inclu le label du sous titre (pour le traduire avec marquee)

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

## Value

ggplot2 caption (ggplot() + ofce_caption("INSEE"))
