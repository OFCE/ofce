///// GABARIT TYPST — BLOG DE L'OFCE
//
// Hiérarchie des commentaires : ///// une page du document, //// une section,
// /// une sous-section, // une remarque ponctuelle.
//
// Le fichier est traité comme un template pandoc : le signe dollar y est un
// caractère d'échappement et doit être doublé (voir la regex de `fmt_date_iso`).

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
// Mêmes polices que le document de travail : Arimo pour la couverture et le
// corps du texte (posé par `mainfont` dans le yaml), Merriweather pour les
// titres de niveau 1, la table des matières et les guillemets de citation.
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

//// Rédaction du blog

// Nom des rédacteurs en chef, imprimé au bas de la page 2.
#let redaction_fr = "Rédacteurs en chef : Elliot Aurissergues & Paul Malliet"
#let redaction_en = "Editors-in-chief: Elliot Aurissergues & Paul Malliet"

//// Instituts

// `institut` dans le yaml choisit le logo (couverture et entêtes de page) et
// le sigle qui précède le numéro du billet dans les entêtes. Valeur par
// défaut : « ofce », c'est-à-dire le comportement d'avant l'ajout de cet
// argument. Le logo Sciences Po du bas de couverture ne dépend pas de
// l'institut, et la mention « Blog » de la couverture non plus.
// `sigle` : forme courte, seule à tenir dans une entête de page.
// `nom` : forme développée, pour les usages où la place ne manque pas.
#let instituts = (
  "ofce": (
    logo: "ofce.png", logo_entete: "ofce.png",
    sigle: [OFCE], nom: [OFCE]),
  "ife": (
    logo: "IFE_Institut_logo_noir.png", logo_entete: "IFE_Institut_logo_noir.png",
    sigle: [IFE], nom: [Institut français d'économie]),
  "ife-ofce": (
    logo: "IFE-OFCE_logo_noir.png", logo_entete: "IFE-OFCE_logo_noir.png",
    sigle: [IFE|OFCE], nom: [IFE|OFCE]),
  "ife-cepii": (
    logo: "IFE-CEPII_logo_noir.png", logo_entete: "IFE-CEPII_logo_noir.png",
    sigle: [IFE|CEPII], nom: [IFE|CEPII]),
  "ife-ofce-cepii": (
    logo: "IFE-OFCE-CEPII_logo_noir.png", logo_entete: "IFE-OFCE-CEPII_logo_noir.png",
    sigle: [IFE|OFCE|CEPII], nom: [IFE|OFCE|CEPII]),
)

// Les logos n'ont pas le même format : ils sont dimensionnés en hauteur, pour
// un poids visuel identique d'un institut à l'autre. Ces hauteurs sont celles
// du logo OFCE tel qu'il était posé en largeur (4 cm et 1 cm).
#let hauteur_logo_couverture = 1.83cm
#let hauteur_logo_entete = 0.46cm

// Fiche de l'institut demandé ; erreur explicite si la valeur est inconnue.
#let fiche_institut(institut) = {
  let cle = if institut == none { "ofce" } else { lower(str(institut).trim()) }
  if cle not in instituts {
    panic("institut inconnu : « " + cle + " ». Valeurs possibles : " + instituts.keys().join(", ") + ".")
  }
  instituts.at(cle)
}

#let chemin_logo(fichier) = "/_extensions/ofce/ofce/img/" + fichier

// Mention du blog dans les entêtes de page : « Blog OFCE nº 12 » en français,
// « OFCE blog no. 12 » en anglais.
#let mention_blog(language, sigle, numero) = {
  if is_en(language) [#sigle blog no. #numero] else [Blog #sigle nº #numero]
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
      // de `preprint` s'en sert pour le passer en gras et le rendre `sticky`.
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

/// Année affichée sur la couverture et dans les entêtes
//
// `annee` dans le yaml si elle est renseignée ; à défaut, l'année de la date
// de publication ; `none` si l'on ne dispose ni de l'une ni de l'autre.
#let annee_doc(year, first_publish) = {
  if year != none and year != [] { return year }
  if first_publish == none { return none }
  let raw = if type(first_publish) == str { first_publish } else if first_publish.has("text") { first_publish.text } else { "" }
  let m = raw.trim().match(regex("^(\\d{4})-"))
  if m == none { none } else { m.captures.at(0) }
}

///// PAGES 1 ET 2 — COUVERTURE ET OURS

#let title-page(
  title: [],
  subtitle: [],
  authors: none,
  email: [],
  first_publish: none,
  modified: none,
  abstract: none,
  year: none,
  number: [],
  stable-url: none,
  institut: none,
  language: "fr",
  body,
) = {

  //// Valeurs dérivées des métadonnées

  let fiche = fiche_institut(institut)

  let pretty_date = fmt_date_iso(first_publish, language)
  let pretty_modified = fmt_date_iso(modified, language)
  let annee = annee_doc(year, first_publish)

  // Pandoc échappe « // » en « /\/ » à l'interpolation : on rétablit l'URL.
  let url_stable = if stable-url != none and stable-url != "" { stable-url.replace("/\\/", "//") } else { none }

  //// Géométrie de la couverture

  let marge = 3.5cm
  let ph = 29.7cm // hauteur de page A4
  let pw = 21.0cm // largeur de page A4
  let logo_column = 4cm
  let lc_space = 0.5cm
  let line_x = 0cm + (logo_column - marge) + lc_space * 2

  //// Bloc auteurs

  let authorblock() = {
    if authors != none {
      let nrows = calc.min(authors.len(), 3)
      grid(
        rows: nrows,
        row-gutter: 0.5em,
        ..authors.map(author => align(left)[
          #text(author.name, weight: "bold", size: 11pt), #text(author.affiliation, style: "italic", size: 11pt)
        ]),
      )
    }
  }

  //// Réglages de page communs aux pages 1 et 2

  // Quarto pose un `set page(numbering: "1")` global qui régit les pages 1 et 2
  // (celui de `preprint` ne prend effet qu'à partir de la page 3) : on le
  // neutralise ici pour la couverture et l'ours.
  set page(margin: (top: marge, rest: marge), numbering: none)
  set text(font: main_title_font, size: 14pt)
  set heading(numbering: "1.1.1")

  // place(top + right, text(blue, "+")) // repère de position

  ///// PAGE 1 — COUVERTURE

  //// Logos et filet vertical

  place(top + left, dx: -marge + lc_space, dy: -2cm,
    image(chemin_logo(fiche.logo), height: hauteur_logo_couverture))

  place(bottom + left, dx: -marge + lc_space, dy: 2cm,
    image(chemin_logo("sciencespo.png"), width: logo_column))

  place(left,
    line(start: (line_x, 0cm), end: (line_x, ph - 2 * marge), stroke: (thickness: 1.25pt, paint: grey1)))

  //// Titre, sous-titre, auteurs et lien

  place(dx: 2cm, dy: 4cm,
    box(width: 13cm,
      align(horizon + left)[
        #set par(justify: false)
        #text(size: 24pt, title, fill: ife2, weight: "bold", font: serif_font)
        #v(1em)
        #text(subtitle, fill: grey1)
        #v(2em)

        #authorblock()

        // Lien vers la version en ligne du billet, si `stable-url` (ou à
        // défaut `citation.url`) est renseignée dans le yaml.
        #if url_stable != none [
          #v(1.5em)
          #text(size: 10pt, fill: grey1)[
            #tr(language, [Version en ligne du billet :], [Online version of this post:])
            #link(url_stable)[#text(fill: ife2, url_stable)]
          ]
        ]
      ]))

  //// Numéro, année et mention « Blog »

  place(top + right, dy: -2cm, dx: marge,
    square(fill: ife1, size: 2cm, align(center + horizon, text(fill: white, size: 1cm, number))))

  // L'année n'est affichée que si elle est connue (`annee` dans le yaml, ou
  // déduite de la date de publication).
  if annee != none {
    place(top + right, dy: 0cm, dx: marge, text(fill: ife1, size: 0.9cm, annee))
  }

  place(top + right, dx: 1.25cm, dy: -1.5cm,
    align(horizon, text(fill: gray, size: 2cm, font: serif_font, style: "italic", "Blog")))

  //// Dates de publication et de dernière modification

  place(bottom + right, dx: 1.5cm, [
    #if pretty_date != none [
      #text(weight: "semibold", size: 10pt)[#tr(language, [Première publication : ], [First published: ])]
      #text(size: 10pt)[#pretty_date \ ]
    ]
    #if pretty_modified != none [
      #text(weight: "semibold", size: 10pt)[#tr(language, [Dernière modification : ], [Last modified: ])]
      #text(size: 10pt)[#pretty_modified \ ]
    ]
  ])

  //// Résumé, dans le bandeau gris du bas de couverture

  if abstract != none and abstract != [] {
    place(bottom, dx: 2 * lc_space + line_x, dy: -1 * line_x, clearance: 4cm,
      // Résumé justifié : c'est un bloc de texte suivi, pas un titre.
      box(fill: grey3, baseline: 100%, width: 13cm, inset: 1em, {
        set par(justify: true)
        text(style: "italic", abstract, size: 10pt)
      }))
  }

  ///// PAGE 2 — OURS

  pagebreak()
  set page(fill: none, margin: auto)

  // Ancre invisible : sans contenu, le `set page` de `preprint` s'appliquerait
  // à la page 2 elle-même et y ferait réapparaître le numéro.
  box()

  align(bottom, text(tr(language, redaction_fr, redaction_en)))

  //// Suite du document

  body
}

///// PAGES DE TEXTE — CORPS DU BILLET

#let preprint(
  title: none,
  subtitle: none,
  running-head: none,
  authors: none,
  affiliations: none,
  abstract: none,
  keywords: none,
  authornote: none,
  citation: none,
  first_publish: none,
  modified: none,
  number: none,
  year: none,
  institut: none,
  leading: 0.6em,
  spacing: 1em,
  first-line-indent: 0cm,
  linkcolor: rgb(0, 0, 0),
  paper: "a4",
  language: "fr",
  region: "US",
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  section-numbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  bibliography-title: none,
  bibliography-style: "apa",
  cols: 1,
  col-gutter: 4.2%,
  doc,
) = {

  //// Valeurs dérivées des métadonnées

  let pretty_date = fmt_date_iso(first_publish, language)
  let pretty_modified = fmt_date_iso(modified, language)

  let fiche = fiche_institut(institut)
  let logo_entete = chemin_logo(fiche.logo_entete)

  // Noms d'auteurs, réutilisés sous le titre et dans la note d'auteur.
  let author_strings = ()
  if authors != none {
    for a in authors {
      author_strings.push([#a.name])
    }
  }

  // Numéro du billet, « ?? » tant que `wp` n'est pas renseigné.
  let numero = if number != none and number != [] { number } else { [??] }

  // Année, « ???? » tant qu'elle n'est ni renseignée ni déductible.
  let annee = {
    let a = annee_doc(year, first_publish)
    if a != none { a } else { [????] }
  }

  // Titres transmis par quarto s'ils sont définis, sinon repli selon la langue.
  let titre_toc = if toc_title != none { toc_title } else { tr(language, "Table des matières", "Contents") }
  let titre_biblio = if bibliography-title != none { bibliography-title } else { tr(language, [Références], [References]) }

  //// Mise en page : entêtes et pieds de page

  set page(
    paper: paper,
    margin: (inside: 3.5cm, outside: 2.5cm, rest: 3cm),
    numbering: "1",
    header-ascent: 50%,
    header: context {
      let repere = query(<ofce-main-start>)
      let debut = if repere.len() > 0 { repere.first().location().page() } else { 3 }

      /// Première page du texte principal : numéro du billet et dates
      if here().page() == debut {
        grid(
          columns: (3fr, 1fr),
          align(left + bottom)[#text([
            #mention_blog(language, fiche.sigle, numero) \
            #tr(language, [Publié le], [Published]) #pretty_date#if pretty_modified != none [ \- #tr(language, [modifié le], [modified]) #pretty_modified]
          ], style: "italic")],
          align(right + bottom)[#image(logo_entete, height: hauteur_logo_entete)],
        )

      /// Page(s) de table des matières : entête sans numéro de page
      } else if here().page() < debut {
        grid(
          columns: (1fr, auto),
          align(left)[#text([#mention_blog(language, fiche.sigle, numero) - #annee], style: "italic")],
          align(right)[#image(logo_entete, height: hauteur_logo_entete)],
        )
        line(start: (0cm, -0.5em), end: (15cm, -0.5em), stroke: (thickness: 0.25pt, paint: grey1))

      /// Pages suivantes : numéro de page à l'extérieur
      } else {
        if calc.even(here().page()) {
          grid(
            columns: (1fr, 1fr),
            align(left + bottom)[#counter(page).display()],
            align(right + bottom)[#image(logo_entete, height: hauteur_logo_entete)],
          )
        } else {
          grid(
            columns: (1fr, auto),
            align(left)[#text([#mention_blog(language, fiche.sigle, numero) - #annee], style: "italic")],
            align(right)[#counter(page).display()],
          )
        }
        line(start: (0cm, -0.5em), end: (15cm, -0.5em), stroke: (thickness: 0.25pt, paint: grey1))
      }
    },
    footer-descent: 24pt,
    // Pied de page vide, conservé pour le `footer-descent`.
    footer: context if here().page() == 3 { } else { },
  )

  //// Réglages de texte

  set par(justify: true, leading: leading, first-line-indent: first-line-indent, spacing: spacing)
  set text(region: region, font: font, size: fontsize)
  set bibliography(title: titre_biblio, style: bibliography-style)

  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  //// Titres de section

  set heading(numbering: section-numbering)

  /// Niveaux 1 à 3 : titres en bloc, au fer à gauche (jamais justifiés)
  show heading.where(level: 1): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set par(justify: false)
    #set text(size: fontsize * 1.1, weight: "bold", font: serif_font)
    #it
  ]
  show heading.where(level: 2): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set par(justify: false)
    #set text(size: fontsize * 1.05)
    #it
  ]
  show heading.where(level: 3): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set par(justify: false)
    #set text(size: fontsize, style: "italic")
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
  // La règle est posée ici, et non dans la règle `show figure` ci-dessus,
  // afin de couvrir aussi les encadrés sans référence croisée, qui ne sont
  // pas enveloppés dans un `figure`. `sticky: false` dans le sélecteur évite
  // que la règle ne s'applique à son propre résultat (récursion infinie).
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

  ///// TABLE DES MATIÈRES — sur sa propre page, si `toc: true` dans le yaml

  pagebreak()

  if toc {
    v(2cm)
    text(titre_toc, size: 18pt, weight: "bold", font: serif_font, fill: ife2)
    v(1em)
    outline(title: none, depth: toc_depth, indent: toc_indent)
    pagebreak()
  }

  ///// TEXTE PRINCIPAL

  // Repère du début du texte principal : l'entête particulière (nº du billet
  // et date de publication) se pose sur cette page, quel que soit le nombre de
  // pages occupées par la table des matières.
  [#metadata("start") <ofce-main-start>]

  //// Titre, sous-titre et auteurs

  v(4cm)

  // Les titres ne se justifient pas : ils restent au fer à gauche.
  block(width: 100%)[
    #set par(justify: false)
    #text(title, size: 20pt, weight: "bold", font: serif_font)
    #if subtitle != none {
      v(1em)
      text(subtitle, size: 16pt, weight: "semibold")
    }
  ]

  v(1em)
  text(author_strings.join(", ", last: " & "))

  //// Corps du billet

  // Séparation avec les pages liminaires
  v(4em)

  if cols == 1 {
    doc
  } else {
    columns(cols, gutter: col-gutter, doc)
  }

  v(4cm)
}
