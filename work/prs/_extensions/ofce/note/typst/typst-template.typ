///// GABARIT TYPST — NOTE OFCE
//
// Hiérarchie des commentaires : ///// une page du document, //// une section,
// /// une sous-section, // une remarque ponctuelle.
//
// Le fichier est traité comme un template pandoc : le signe dollar y est un
// caractère d'échappement et doit être doublé (voir la regex de `fmt_date_iso`).
//
// À la différence des gabarits `wp` et `blog`, la note n'a pas de couverture
// séparée : le bloc de titre ouvre la première page du texte.

#import "@preview/icu-datetime:0.1.2": fmt-datetime, fmt-date

///// PRÉAMBULE — styles et fonctions communes

//// Constantes de style

/// Couleurs
#let grey0 = rgb("#030303")
#let grey1 = rgb("#6B6B6B")
#let grey2 = rgb("#A6A6A6")
#let grey3 = rgb("#D6D6D6")
#let scpored = rgb("#e6142d")
#let scpodarkred = rgb("#770C19")
#let colourtype = rgb("#EEC900")
#let ife1 = rgb("#7D0000")
#let ife2 = rgb("#21606E")
#let ifegrey = rgb("#DDDBDB")

/// Polices
//
// Mêmes polices que le document de travail et le blog : Arimo pour le bloc de
// titre et le corps du texte (posé par `mainfont` dans le yaml), Merriweather
// pour le titre, les titres de niveau 1 et les guillemets de citation.
#let main_title_font = "Arimo"
#let serif_font = "Merriweather"

/// Tableaux : pas de filets, ce sont les tableaux gt qui posent les leurs
#set table(inset: 6pt, stroke: none)

//// Libellés du gabarit

// Le français est la langue par défaut ; `lang: en` dans le yaml bascule
// l'ensemble des textes inscrits en dur. Les variantes régionales (en-GB,
// fr-BE, ...) sont ramenées à leur langue.
#let is_en(language) = language != none and lower(language).starts-with("en")

// Choisit entre deux libellés (chaîne ou contenu) selon la langue.
#let tr(language, fr, en) = if is_en(language) { en } else { fr }

//// Instituts

// `institut` dans le yaml choisit le logo du bloc de titre et le sigle qui
// précède le numéro de la note. Valeur par défaut : « ofce », c'est-à-dire le
// comportement d'avant l'ajout de cet argument.
// `sigle` : forme courte, seule à tenir sur la ligne du numéro.
// `nom` : forme développée, pour les usages où la place ne manque pas.
#let instituts = (
  "ofce": (
    logo: "ofce.png",
    sigle: [OFCE], nom: [OFCE]),
  "ife": (
    logo: "IFE_Institut_logo_noir.png",
    sigle: [IFE], nom: [Institut français d'économie]),
  "ife-ofce": (
    logo: "IFE-OFCE_logo_noir.png",
    sigle: [IFE|OFCE], nom: [IFE|OFCE]),
  "ife-cepii": (
    logo: "IFE-CEPII_logo_noir.png",
    sigle: [IFE|CEPII], nom: [IFE|CEPII]),
  "ife-ofce-cepii": (
    logo: "IFE-OFCE-CEPII_logo_noir.png",
    sigle: [IFE|OFCE|CEPII], nom: [IFE|OFCE|CEPII]),
)

// Les logos n'ont pas le même format : ils sont dimensionnés en hauteur, pour
// un poids visuel identique d'un institut à l'autre. Cette hauteur est celle
// du logo OFCE tel qu'il était posé en largeur (3 cm).
#let hauteur_logo = 1.37cm

// Fiche de l'institut demandé ; erreur explicite si la valeur est inconnue.
#let fiche_institut(institut) = {
  let cle = if institut == none { "ofce" } else { lower(str(institut).trim()) }
  if cle not in instituts {
    panic("institut inconnu : « " + cle + " ». Valeurs possibles : " + instituts.keys().join(", ") + ".")
  }
  instituts.at(cle)
}

#let chemin_logo(fichier) = "/_extensions/ofce/ofce/img/" + fichier

// Mention de la note sous la date : « Note OFCE nº 4 » en français,
// « OFCE note no. 4 » en anglais.
#let mention_note(language, sigle, numero) = {
  if is_en(language) [#sigle note no. #numero] else [Note #sigle nº #numero]
}

//// Fonctions communes

/// Pseudo-notes des encadrés
//
// Quarto rend les blocs `::: aside` par la fonction `note()` du paquet
// marginalia, qui les renvoie dans la marge — donc hors de l'encadré.
// Comme ces blocs servent ici de notes de bas d'encadré (appels numérotés
// à la main dans le texte), on redéfinit `note` pour qu'elle compose son
// contenu sur place : sous un filet, en plus petit, à l'endroit où l'aside
// est écrit — c'est-à-dire à la fin de l'encadré qui le contient.
// Cette définition masque celle importée par quarto.
//
// C'est aussi pourquoi la fonction principale de ce gabarit s'appelle
// `note_ofce` et non `note` : sous son ancien nom, elle masquait la fonction
// de marginalia et tout bloc `::: aside` faisait échouer la compilation.
#let note(..args) = {
  let body = args.pos().at(0, default: [])
  block(width: 100%, above: 1em, below: 0.2em, {
    line(length: 30%, stroke: (thickness: 0.4pt, paint: grey1))
    v(0.4em, weak: true)
    set text(size: 0.8em, fill: grey1)
    body
  })
}

/// Encadrés (callouts)
#let callout(
  body: [],
  title: "Callout",
  background_color: none,
  icon: none,
  icon_color: none,
  body_background_color: white,
) = {
  let _bg = rgb("#EDEAEA")
  let _ic = rgb("#EDEAEA")
  let _bbg = rgb("#EDEAEA")
  block(
    breakable: true,
    fill: _bg,
    stroke: (paint: _ic, thickness: 0.5pt, cap: "round"),
    width: 100%,
    radius: 2pt,
    block(
      breakable: true,
      // Le `below: 0pt` identifie ce bandeau de titre : la règle `show block`
      // de `note_ofce` s'en sert pour le passer en gras et le rendre `sticky`.
      inset: 1pt,
      width: 100%,
      below: 0pt,
      block(breakable: true, fill: _bg, width: 100%, inset: 8pt)[#if icon != none [#text(_ic, weight: 900)[#icon] ]#title],
    ) + if body != [] {
      block(
        breakable: true,
        inset: 1pt,
        width: 100%,
        block(breakable: true, fill: _bbg, width: 100%, inset: 8pt, align(left, body)),
      )
    },
  )
}

/// Mise en forme d'une date ISO (première publication, dernière modification)
//
// Renvoie `none` si aucune date n'est fournie, et "????" si la valeur fournie
// n'est pas une date ISO (AAAA-MM-JJ) valide — plutôt que de faire échouer la
// compilation.
#let fmt_date_iso(value, language) = {
  if value == none { return none }

  let raw = if type(value) == str { value } else if value.has("text") { value.text } else { "" }
  if raw.trim() == "" { return none }

  // `$$` : échappement pandoc, le fichier est traité comme un template.
  let m = raw.trim().match(regex("^(\\d{4})-(\\d{1,2})-(\\d{1,2})$$"))
  if m == none { return "????" }

  let y = int(m.captures.at(0))
  let mo = int(m.captures.at(1))
  let d = int(m.captures.at(2))
  if mo < 1 or mo > 12 { return "????" }

  let leap = calc.rem(y, 4) == 0 and (calc.rem(y, 100) != 0 or calc.rem(y, 400) == 0)
  let last_day = if mo == 2 and leap {
    29
  } else {
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31).at(mo - 1)
  }
  if d < 1 or d > last_day { return "????" }

  fmt-date(datetime(year: y, month: mo, day: d), length: "long", locale: language)
}

///// LA NOTE — bloc de titre puis corps du texte, d'un seul tenant

#let note_ofce(
  title: none,
  subtitle: none,
  authors: none,
  abstract: none,
  first_publish: none,
  modified: none,
  number: none,
  institut: none,
  stable-url: none,
  language: "fr",
  leading: 0.6em,
  spacing: 1em,
  first-line-indent: 0cm,
  linkcolor: rgb(0, 0, 0),
  paper: "a4",
  region: "FR",
  font: ("Arimo", "Arial"),
  fontsize: 10pt,
  section-numbering: none,
  bibliography-title: none,
  bibliography-style: "apa",
  cols: 1,
  col-gutter: 4.2%,
  doc,
) = {

  //// Valeurs dérivées des métadonnées

  let fiche = fiche_institut(institut)

  let pretty_date = fmt_date_iso(first_publish, language)
  let pretty_modified = fmt_date_iso(modified, language)

  // Pandoc échappe « // » en « /\/ » à l'interpolation : on rétablit l'URL.
  let url_stable = if stable-url != none and stable-url != "" { stable-url.replace("/\\/", "//") } else { none }

  // Titre de bibliographie transmis par quarto s'il est défini, sinon repli
  // selon la langue.
  let titre_biblio = if bibliography-title != none { bibliography-title } else { tr(language, [Références], [References]) }

  //// Mise en page : entêtes et pieds de page

  set page(
    paper: paper,
    margin: (inside: 2.5cm, outside: 2.5cm, top: 2.5cm, bottom: 2.5cm),
    numbering: none,
    footer: none,
    header-ascent: 40%,
    header: context if here().page() == 1 {
      // Pas d'entête sur la page de titre
    } else {
      let pn = counter(page).display()
      if calc.even(here().page()) {
        align(left)[#text(pn, size: 9pt, fill: grey1)]
      } else {
        align(right)[#text(pn, size: 9pt, fill: grey1)]
      }
      v(-0.4em)
      line(start: (0cm, 0cm), end: (100%, 0cm), stroke: (thickness: 0.5pt, paint: grey1))
    },
  )

  //// Réglages de texte

  set par(justify: true, leading: leading, first-line-indent: first-line-indent, spacing: spacing)
  set text(region: region, font: font, size: fontsize, lang: language)
  set bibliography(title: titre_biblio, style: bibliography-style)

  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  //// Titres de section

  set heading(numbering: section-numbering)

  /// Niveaux 1 à 3 : titres en bloc, au fer à gauche (jamais justifiés)
  show heading.where(level: 1): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set par(justify: false)
    #set text(size: fontsize * 1.3, weight: "bold", fill: ife2, font: serif_font)
    #it
  ]
  show heading.where(level: 2): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set par(justify: false)
    #set text(size: fontsize * 1.15, weight: "bold")
    #it
  ]
  show heading.where(level: 3): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set par(justify: false)
    #set text(size: fontsize * 1.05, style: "italic")
    #it
  ]

  /// Niveaux 4 et 5 : titres dans le paragraphe
  show heading.where(level: 4): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em),
    text(size: 1em, weight: "bold", it),
  )
  show heading.where(level: 5): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em),
    text(size: 1em, weight: "bold", style: "italic", it),
  )

  //// Encadrés, figures et citations

  // Les callouts référençables sont enveloppés dans un `figure`, dont le bloc
  // n'est pas sécable : un encadré long refusait alors de se répartir sur
  // deux pages. On rend sécables les figures de type callout.
  show figure: it => {
    if type(it.kind) == str and it.kind.starts-with("quarto-callout") {
      set block(breakable: true)
      it
    } else {
      it
    }
  }
  show figure.where(kind: table): set block(breakable: true)
  show figure.where(kind: "quarto-float-tbl"): set block(breakable: true)
  show figure.where(kind: "quarto-float-apptbl"): set block(breakable: true)

  // Bandeau de titre des encadrés (seuls blocs à porter `below: 0pt`) :
  // en gras, et `sticky` pour qu'il ne reste pas seul en bas de page.
  // La règle couvre aussi les encadrés sans référence croisée, qui ne sont pas
  // enveloppés dans un `figure`. `sticky: false` dans le sélecteur évite que
  // la règle ne s'applique à son propre résultat (récursion infinie).
  show block.where(below: 0pt, sticky: false): b => {
    let f = b.fields()
    let inner = f.remove("body")
    if f.at("below", default: none) != none { f.below = f.below.abs }
    block(..f, sticky: true, text(weight: "bold", inner))
  }

  // Citations en bloc : retrait des deux côtés, encadrées par de grands
  // guillemets. Ne concerne que les blocs `>` (`quote(block: true)`),
  // pas les citations en ligne.
  show quote.where(block: true): it => block(
    width: 100%,
    above: 1.4em,
    below: 1.4em,
    inset: (left: 1.5em, right: 1.5em),
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.5em,
      align: (left + top, left + top),
      // `top-edge`/`bottom-edge` sur la ligne de base : les guillemets ne
      // comptent pas dans la hauteur, ils ne déforment donc ni une citation
      // d'une seule ligne ni la dernière ligne d'une longue citation.
      text(size: 2.5em, fill: ife2, font: serif_font, top-edge: "baseline", bottom-edge: "baseline", baseline: 0.72em)[“],
      {
        set text(size: 0.95em, fill: grey1)
        // Le guillemet fermant est placé à la suite du texte, et non dans une
        // colonne de la grille : il suit ainsi le dernier mot et reste sur la
        // bonne page quand la citation se répartit sur plusieurs pages.
        it.body
        h(0.15em)
        text(size: 2.5em, fill: ife2, font: serif_font, top-edge: "baseline", bottom-edge: "baseline", baseline: 0.5em)[”]
      },
    ),
  )

  ///// BLOC DE TITRE — en tête de la première page

  //// Logo et, en regard, dates et numéro de la note

  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align(left + top)[
      #image(chemin_logo(fiche.logo), height: hauteur_logo)
    ],
    align(right + top)[
      #set par(justify: false)
      #if pretty_date != none {
        text(pretty_date, size: 10pt, fill: grey1)
      }
      // Date de dernière modification, si `date-modified` est renseignée
      // dans le yaml.
      #if pretty_modified != none {
        linebreak()
        text(tr(language, [modifiée le ], [modified ]) + pretty_modified, size: 9pt, fill: grey1)
      }
      #if number != none and number != [] {
        linebreak()
        text(mention_note(language, fiche.sigle, number), size: 10pt, fill: grey1, style: "italic")
      }
    ],
  )

  v(1.5cm)

  //// Titre et sous-titre

  // Les titres ne se justifient pas : ils restent au fer à gauche.
  block(width: 100%)[
    #set par(justify: false)
    #text(title, size: 22pt, weight: "bold", fill: ife2, font: serif_font)
    #if subtitle != none {
      v(0.5em)
      block(text(subtitle, size: 14pt, fill: grey1, font: main_title_font))
    }
  ]

  v(1.5em)

  //// Auteurs, au fer à droite

  if authors != none {
    align(right)[
      #grid(
        rows: authors.len(),
        row-gutter: 0.4em,
        // Nom et affiliation sur une seule ligne de source : un retour à la
        // ligne ici insérerait une espace avant la virgule.
        ..authors.map(author => align(right)[
          #text(author.name, weight: "bold", size: 10pt)#if author.affiliation != none and author.affiliation != [] [, #text(author.affiliation, style: "italic", size: 10pt)]
        ])
      )
    ]
  }

  v(1.5em)

  //// Résumé

  if abstract != none and abstract != [] {
    // Résumé justifié : c'est un bloc de texte suivi, pas un titre.
    block(
      fill: ifegrey,
      inset: 1em,
      width: 100%,
      {
        set par(justify: true)
        text(abstract, style: "italic", size: 9.5pt)
      },
    )
  }

  //// Lien vers la version en ligne (facultatif)

  if url_stable != none {
    v(0.75em)
    text(size: 9pt, fill: grey1)[
      #tr(language, [Version en ligne de la note :], [Online version of this note:])
      #link(url_stable)[#text(fill: ife2, url_stable)]
    ]
  }

  v(1em)
  line(start: (0cm, 0cm), end: (100%, 0cm), stroke: (thickness: 0.5pt, paint: grey1))
  v(1em)

  ///// CORPS DU TEXTE

  if cols == 1 {
    doc
  } else {
    columns(cols, gutter: col-gutter, doc)
  }
}
