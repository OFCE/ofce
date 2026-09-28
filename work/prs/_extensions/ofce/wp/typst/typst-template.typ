///// GABARIT TYPST — DOCUMENT DE TRAVAIL OFCE
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
#let ifeanthracite = rgb("#28252F")


/// Polices
#let main_title_font = "Arimo"
#let serif_font = "Merriweather"

/// Filets des tableaux
//
// Trois sources dessinaient des filets d'épaisseurs et de couleurs
// différentes dans un même tableau :
//   - pandoc pose un `table.hline()` sans argument sous l'en-tête et au-dessus
//     du pied de tableau ; sans stroke explicite, typst les trace en 1pt noir ;
//   - les bordures des groupes de lignes viennent de la CSS de gt, converties
//     en `stroke:` sur les cellules : gris clair (#d3d3d3) et 1,5pt ;
//   - le filet du haut n'était pas tracé du tout : gt le dessine en html, mais
//     ni `table.border.top` ni `column_labels.border.top` ne survivent à la
//     conversion html -> pandoc -> typst.
//
// Tout est ramené à `filet_tableau` ici, sans rien changer du côté R
#let filet_tableau = 0.4pt + ifeanthracite

// Les filets de pandoc (sous l'en-tête, au-dessus du pied).
#set table.hline(stroke: filet_tableau)

// Le filet du haut, que gt ne transmet pas : il est posé ici, sur le bord
// supérieur des cellules de la première ligne. Les autres bords restent nus —
// les filets intérieurs sont ceux de gt et de pandoc, pas ceux du `table`.
#set table(
  inset: 6pt,
  stroke: (x, y) => if y == 0 { (top: filet_tableau) },
)

/// Reprise des traits que gt pose lui-même
//
// Les bordures des groupes de lignes arrivent en argument explicite sur la
// cellule (`table.cell(stroke: (top: ..., bottom: ...))`), gris clair et en
// 1,5pt. Un argument explicite l'emporte sur toute règle `set`, et une règle
// `show table.cell` ne peut remplacer que le contenu d'une cellule, pas ses
// traits : il faut reconstruire les enfants du tableau.
//
// Chaque côté effectivement dessiné prend `filet_tableau` ; les côtés nus le
// restent. `auto` et `none` sont laissés tels quels : ils relèvent du `set
// table` ci-dessus, qui a déjà la bonne épaisseur.
//
// Le trait est lu par `fields()`, et non par `enfant.stroke` : une cellule qui
// n'en porte pas explicitement fait échouer l'accès direct au champ
// (« field "stroke" in cell is not known at this point »).
#let trait_cellule(enfant) = enfant.fields().at("stroke", default: auto)

#let filet_normalise(trait) = {
  if type(trait) == dictionary {
    let sortie = (:)
    for (cote, valeur) in trait {
      sortie.insert(cote, if valeur == none { none } else { filet_tableau })
    }
    sortie
  } else if trait == none or trait == auto {
    trait
  } else {
    filet_tableau
  }
}

#let cellule_a_reprendre(enfant) = {
  enfant.func() == table.cell and filet_normalise(trait_cellule(enfant)) != trait_cellule(enfant)
}

// Le filet sous un libellé de regroupement de colonnes (`tab_spanner`), que gt
// dessine en html et que la conversion perd, comme celui du haut. La cellule
// du libellé se reconnaît à son `colspan` : dans un en-tête gt, seul un
// spanner couvre plusieurs colonnes. Le trait ne court alors que sur les
// colonnes regroupées, puisqu'il est porté par cette cellule.
//
// La cellule du pied de tableau porte elle aussi un `colspan`, mais le pied
// n'est pas parcouru : seuls les enfants de `table.header` le sont.
// Les parenthèses sont nécessaires : typst ne poursuit pas une expression
// d'une ligne sur l'autre, que l'opérateur soit en fin ou en début de ligne.
#let spanner_a_reprendre(enfant) = (
  enfant.func() == table.cell
    and enfant.fields().at("colspan", default: 1) >= 2
    and trait_cellule(enfant) == auto
)

#let reprendre_cellule(enfant, trait) = {
  let cf = enfant.fields()
  let corps = cf.remove("body")
  // `default` est indispensable : une cellule de spanner n'a pas de champ
  // `stroke`, et `remove` sur une clé absente est une erreur.
  let _ = cf.remove("stroke", default: none)
  table.cell(..cf, stroke: trait, corps)
}

#let reprendre_entete(entete) = {
  if not entete.children.any(spanner_a_reprendre) { return entete }
  let champs = entete.fields()
  let _ = champs.remove("children")
  table.header(
    ..champs,
    ..entete.children.map(enfant => {
      if spanner_a_reprendre(enfant) {
        reprendre_cellule(enfant, (bottom: filet_tableau))
      } else {
        enfant
      }
    }),
  )
}

// La règle se rappelle sur le tableau qu'elle reconstruit ; elle s'arrête au
// second passage, où plus rien n'est à reprendre.
#show table: it => {
  let entete_a_faire = it.children.any(enfant => {
    enfant.func() == table.header and enfant.children.any(spanner_a_reprendre)
  })
  if not it.children.any(cellule_a_reprendre) and not entete_a_faire {
    return it
  }
  let champs = it.fields()
  let _ = champs.remove("children")
  table(
    ..champs,
    ..it.children.map(enfant => {
      if enfant.func() == table.header {
        reprendre_entete(enfant)
      } else if cellule_a_reprendre(enfant) {
        reprendre_cellule(enfant, filet_normalise(trait_cellule(enfant)))
      } else {
        enfant
      }
    }),
  )
}

/// Air entre la légende et le flottant
#set figure(gap: 1.1em)

/// Air au-dessus et en dessous des graphiques et des tableaux
#let espacement_flottant = 3em

//// Libellés du gabarit

// Le français est la langue par défaut ; `lang: en` dans le yaml bascule
// l'ensemble des textes inscrits en dur.

#let is_en(language) = language != none and lower(language).starts-with("en")

// Choisit entre deux libellés (chaîne ou contenu) selon la langue.
#let tr(language, fr, en) = if is_en(language) { en } else { fr }

//// Instituts

// `institut` dans le yaml choisit le logo (couverture et entêtes de page) et
// le nom du document de travail dans la citation suggérée. Valeur par défaut :
// « ofce », c'est-à-dire le comportement d'avant l'ajout de cet argument.
// Le logo Sciences Po du bas de couverture ne dépend pas de l'institut.
// `revue_fr` / `revue_en` : nom de la série tel qu'il paraît dans la citation.
#let instituts = (
  "ofce": (
    logo: "ofce_m.png", logo_entete: "ofce.png", nom: [OFCE],
    revue_fr: [Document de travail OFCE], revue_en: [OFCE working paper]),
  "ife": (
    logo: "IFE_Institut_logo_noir.png", logo_entete: "IFE_Institut_logo_noir.png", nom: [Institut français d'économie],
    revue_fr: [Document de travail de l'Institut français d'économie], revue_en: [Institut français d'économie working paper]),
  "ife-ofce": (
    logo: "IFE-OFCE_logo_noir.png", logo_entete: "IFE-OFCE_logo_noir.png", nom: [IFE|OFCE],
    revue_fr: [Document de travail IFE|OFCE], revue_en: [IFE|OFCE working paper]),
  "ife-cepii": (
    logo: "IFE-CEPII_logo_noir.png", logo_entete: "IFE-CEPII_logo_noir.png", nom: [IFE|CEPII],
    revue_fr: [Document de travail IFE|CEPII], revue_en: [IFE|CEPII working paper]),
  "ife-ofce-cepii": (
    logo: "IFE-OFCE-CEPII_logo_noir.png", logo_entete: "IFE-OFCE-CEPII_logo_noir.png", nom: [IFE|OFCE|CEPII],
    revue_fr: [Document de travail IFE|OFCE|CEPII], revue_en: [IFE|OFCE|CEPII working paper]),
)

// Les logos n'ont pas le même format : ils sont dimensionnés en hauteur, pour
// un poids visuel identique d'un institut à l'autre. Ces hauteurs sont celles
// du logo OFCE tel qu'il était posé en largeur (2,8 cm et 1 cm).
#let hauteur_logo_couverture = 1.28cm
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

//// Fonctions communes

/// Pseudo-notes des encadrés
//
// Quarto rend les blocs `::: aside` par la fonction `note()` du paquet
// marginalia, qui les renvoie dans la marge — donc hors de l'encadré.
// Comme ces blocs servent ici de notes de bas d'encadré (appels numérotés
// à la main dans le texte), on redéfinit `note` pour qu'elle compose son
// contenu sur place : sous un filet, en plus petit, à l'endroit où l'aside
// est écrit — c'est-à-dire à la fin de l'encadré qui le contient.
// Cette définition masque celle importée plus haut.
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

///// PAGES 1 ET 2 — COUVERTURE ET RÉSUMÉ

#let title-page(
  title: [],
  subtitle: [],
  authors: none,
  email: [],
  first_publish: none,
  modified: none,
  year: none,
  number: [],
  abstract: none,
  keywords: none,
  jel: none,
  citation: none,
  stable-url: none,
  thanks: none,
  thanks-title-fr: "Remerciements",
  thanks-title-en: "Acknowledgements",
  institut: none,
  draft: false,
  doc_version: none,
  language: "fr",
  body,
) = {

  //// Valeurs dérivées des métadonnées

  let fiche = fiche_institut(institut)

  // « (v0) » accolé à la mention de version préliminaire, si `version` est
  // renseignée dans le yaml ; rien sinon.
  let version_suffix = if doc_version != none and doc_version != [] { [ (#doc_version)] } else { [] }

  let pretty_date = fmt_date_iso(first_publish, language)
  let pretty_modified = fmt_date_iso(modified, language)

  // Pandoc échappe « // » en « /\/ » à l'interpolation : on rétablit l'URL.
  let url_stable = if stable-url != none and stable-url != "" { stable-url.replace("/\\/", "//") } else { none }

  //// Géométrie de la couverture

  let marge = 3.5cm
  let ph = 29.7cm // hauteur de page A4
  let pw = 21.0cm // largeur de page A4
  let logo_column = 4cm
  let lc_space = 0.75cm
  let line_x = -0.5cm + (logo_column - marge) + lc_space * 2

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
  // neutralise ici pour la couverture et la page de résumé.
  set page(margin: (top: marge, rest: marge), numbering: none)
  set text(font: main_title_font, size: 14pt)
  set heading(numbering: "1.1.1")

  // place(top + right, text(blue, "+")) // repère de position

  ///// PAGE 1 — COUVERTURE

  //// Logos et filet vertical

  place(top + left, dx: -marge + lc_space, dy: -2cm,
    image(chemin_logo(fiche.logo), height: hauteur_logo_couverture))

  place(bottom + left, dx: -marge + lc_space, dy: 2cm,
    image("/_extensions/ofce/ofce/img/sciencespo.png", width: logo_column * 0.7))

  place(left,
    line(start: (line_x, 0cm), end: (line_x, ph - 2 * marge), stroke: (thickness: 1.25pt, paint: grey1)))

  //// Titre, auteurs, lien et dates

  place(dx: 2cm, dy: 4cm,
    box(width: 13cm,
      align(horizon + left)[
        #set par(justify: false)
        #text(size: 24pt, title, fill: ife2, weight: "bold", font: serif_font)
        #v(1em)
        #text(subtitle, fill: grey1)
        #v(2em)

        #authorblock()

        // Lien vers la version en ligne du document, si `stable-url` (ou à
        // défaut `citation.url`) est renseignée dans le yaml.
        #if url_stable != none [
          #v(1.5em)
          #text(size: 10pt, fill: grey1)[
            #tr(language, [Version en ligne du document :], [Online version of this paper:])
            #link(url_stable)[#text(fill: ife2, url_stable)]
          ]
        ]

        // Date de première publication et, si `date-modified` est renseignée
        // dans le yaml, date de dernière modification juste en dessous.
        #v(1.5em)
        #if pretty_date != none [
          #text(weight: "semibold", size: 10pt)[#tr(language, [Première publication : ], [First published: ])]
          #text(size: 10pt)[#pretty_date \ ]
        ]
        #if pretty_modified != none [
          #text(weight: "semibold", size: 10pt)[#tr(language, [Dernière modification : ], [Last modified: ])]
          #text(size: 10pt)[#pretty_modified \ ]
        ]
      ]))

  //// Numéro et année, ou bandeau « version préliminaire »

  if not draft {
    place(top + right, dy: -2cm, dx: marge,
      square(fill: ife1, size: 2cm, align(center + horizon, text(fill: white, size: 1.5cm, number))))

    // L'année n'est affichée que si `annee` est renseignée dans le yaml ;
    // aucune déduction à partir de la date de publication.
    if year != none and year != [] {
      place(top + right, dy: 0cm, dx: marge, text(fill: ife1, size: 0.9cm, year))
    }
  } else {
    // Brouillon : bandeau rouge sous « Document de travail », à la place du
    // numéro et de l'année.
    place(top + right, dy: 0cm, dx: marge,
      box(fill: ife1, inset: 8pt, radius: 2pt,
        text(fill: white, size: 20pt, weight: "bold")[#tr(language, [Version préliminaire#version_suffix — non publiée], [Preliminary version#version_suffix — unpublished])]))

    place(top + right, dy: 1.2cm, dx: marge - 3cm,
      box(fill: white, inset: 8pt, radius: 2pt,
        text(fill: ife1, size: 14pt, weight: "bold", tr(language, "NE PAS DIFFUSER NE PAS CITER", "DO NOT CIRCULATE DO NOT CITE"))))
  }

  // Posé après le numéro pour rester au-dessus du bandeau de brouillon.
  place(top + right, dx: 1.25cm, dy: -1.5cm,
    align(horizon, text(fill: gray, size: 1cm, weight: "bold", font: serif_font, style: "italic", tr(language, "Document de travail", "Working paper"))))

  //// Coordonnées, en bas à droite

  place(bottom + right,
    text(size: 9pt, font: main_title_font, fill: black)[
      #text(weight: "bold", font: serif_font, fill: ife2)[Contact] \
      Institut Français d'économie \
      10 place de Catalogne \
      75014 Paris, FRANCE \
      #tr(language, [Tel : +33 1 44 18 54 24], [Tel: +33 1 44 18 54 24]) \
      #link("https://www.ofce.fr")
    ])

  ///// PAGE 2 — RÉSUMÉ

  pagebreak()
  set page(fill: none, margin: auto)

  // Ancre invisible : sans contenu, le `set page` de `preprint` s'appliquerait
  // à la page 2 elle-même et y ferait réapparaître le numéro.
  box()

  //// Résumé

  if abstract != none and abstract != [] {
    v(2cm)
    text(tr(language, "Résumé", "Abstract"), font: serif_font, size: 18pt, weight: "bold", fill: ife2)
    v(0.5em)
  // Résumé justifié : c'est un bloc de texte suivi, pas un titre.
    block(fill: white, width: 100%, inset: 0em, {
      set par(justify: true)
      text(abstract, size: 10pt)
    })
  }

  //// Mots-clés et codes JEL

  // Chacun seulement s'il est renseigné dans le yaml (`keywords` et `jel`).
  if keywords != none and keywords != [] {
    v(1em)
    block(width: 100%, text(size: 10pt)[
      #set par(justify: false)
      #text(weight: "bold", font: serif_font, fill: ife2)[#tr(language, [Mots-clés : ], [Keywords: ])]#keywords
    ])
  }

  if jel != none and jel != [] {
    v(0.5em)
    block(width: 100%, text(size: 10pt)[
      #set par(justify: false)
      #text(weight: "bold", font: serif_font, fill: ife2)[#tr(language, [Codes JEL : ], [JEL codes: ])]#jel
    ])
  }

  //// Citation suggérée

  // Reprise de la mention « Veuillez citer ce travail comme suit » de la
  // version html. Construite à partir des métadonnées (auteurs, année, titre,
  // `citation.container-title`, numéro de document), faute d'une référence
  // formatée par citeproc en typst.
  if authors != none and authors.len() > 0 and title != [] {
    let auteurs = authors.map(a => [#a.name]).join(", ", last: " & ")
    let revue = if institut != none {
      tr(language, fiche.revue_fr, fiche.revue_en)
    } else if citation != none and citation.container-title != "" {
      citation.container-title
    } else { none }
    let titre_cite = if url_stable != none { link(url_stable)[#title] } else { title }

    v(1em)
    text(weight: "bold", font: serif_font, size: 10pt, fill: ife2)[#tr(language, [Veuillez citer ce travail comme suit : ], [For attribution, please cite this work as: ])]
    block(width: 100%, fill: white, stroke: 0.5pt + grey2, radius: 2pt, inset: 0.75em,
      text(size: 9pt)[
        #set par(justify: false)
        #auteurs#if year != none and year != [] [ (#year)]. #tr(language, [«~#titre_cite~»], [“#titre_cite”])#if revue != none [, #emph(revue)]#if number != [] [#tr(language, [, nº #number], [, no. #number])].
      ])
  }

  //// Remerciements (facultatif)

  if thanks != none and thanks != [] {
    place(bottom + left,
      block(fill: white, inset: 0.5em, stroke: 0.5pt + grey2, radius: 2pt)[
        #set par(leading: 0.35em)
        #text(tr(language, thanks-title-fr, thanks-title-en), size: 9pt, fill: ife2, weight: "bold", font: serif_font)
        #linebreak()
        #text(thanks, size: 8pt, fill: grey1, style: "italic")
      ])
  }

  //// Suite du document

  body
}

///// PAGES DE TEXTE — CORPS DU DOCUMENT

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
  draft: false,
  doc_version: none,
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

  let logo_entete = chemin_logo(fiche_institut(institut).logo_entete)

  // Noms d'auteurs, réutilisés sous le titre et dans la note d'auteur.
  let author_strings = ()
  if authors != none {
    for a in authors {
      author_strings.push([#a.name])
    }
  }

  // « (v0) » accolé à la mention de version préliminaire, si `version` est
  // renseignée dans le yaml ; rien sinon.
  let version_suffix = if doc_version != none and doc_version != [] { [ (#doc_version)] } else { [] }

  // Numéro du document de travail, « ?? » tant que `wp` n'est pas renseigné.
  let numero = if number != none and number != [] { number } else { [??] }

  // Année, « ???? » tant que `annee` n'est pas renseignée.
  let annee = if year != none and year != [] { year } else { [????] }

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

      /// Première page du texte principal : numéro de document et dates
      if here().page() == debut {
        grid(
          columns: (3fr, 1fr),
          align(left + bottom)[#text(if draft [
            #tr(language, [Document de travail IFE], [IFE working paper]) \
            #text(fill: ife1, weight: "bold")[#tr(language, [Version préliminaire], [Preliminary version])#version_suffix  #if pretty_modified != none [#pretty_modified] else [#pretty_date]  #tr(language, [— non publiée ], [— unpublished ])]
          ] else [
            #tr(language, [Document de travail OFCE nº], [OFCE working paper no.]) #numero \
            #tr(language, [Publié le], [Published]) #pretty_date#if pretty_modified != none [ \- #tr(language, [modifié le], [modified]) #pretty_modified]
          ], style: "italic")],
          align(right + bottom)[#image(logo_entete, height: hauteur_logo_entete)],
        )

      /// Page(s) de table des matières : entête sans numéro de page
      } else if here().page() < debut {
        grid(
          columns: (1fr, auto),
          align(left)[#text(if draft [#tr(language, [Document de travail], [Working paper]) #text(fill: ife1, weight: "bold")[#tr(language, [Version préliminaire], [Preliminary version])#version_suffix]] else [#tr(language, [Document de travail nº], [Working paper no.]) #numero - #annee], style: "italic")],
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
            // `auto` pour le numéro : la mention de version garde toute la
            // largeur restante et tient sur une seule ligne.
            columns: (1fr, auto),
            align(left)[#text(if draft [#tr(language, [Document de travail], [Working paper]) #text(fill: ife1, weight: "bold")[#tr(language, [Version préliminaire], [Preliminary version])#version_suffix]] else [#tr(language, [Document de travail nº], [Working paper no.]) #numero - #annee], style: "italic")],
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
    #set text(size: fontsize * 1.3, weight: "bold", font: serif_font)
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
  //
  // Les graphiques et les tableaux, eux, sont entourés d'`espacement_flottant`.
  // L'espacement est posé par un bloc enveloppant, et non par un `set block`
  // sur la figure : celui-ci vaudrait aussi pour les blocs intérieurs, et
  // écarterait la légende de son contenu.
  show figure: it => {
    if type(it.kind) == str and it.kind.starts-with("quarto-callout") {
      set block(breakable: true)
      it
    } else {
      block(above: espacement_flottant, below: espacement_flottant, it)
    }
  }
  show figure.where(kind: table): set block(breakable: true)
  show figure.where(kind: "quarto-float-tbl"): set block(breakable: true)
  show figure.where(kind: "quarto-float-apptbl"): set block(breakable: true)

  // Légendes des graphiques et des tableaux
  //
  // Alignées à gauche (et non centrées, comme le veut le défaut de typst),
  // avec l'appel « Graphique 3 : » en gras et le libellé en romain.
  //
  // Le deux-points est précédé d'une espace fine insécable en français, et
  // d'aucune espace en anglais. L'espace est posée par `h()` plutôt que par le
  // caractère U+202F : elle ne dépend alors pas de la fonte, et n'offre aucune
  // occasion de retour à la ligne.
  //
  // Les légendes placées au-dessus du contenu sont `sticky`, pour ne pas
  // rester seules en bas de page. `cap-location: top` dans _extension.yml les
  // met toutes au-dessus, graphiques compris ; la condition sur `position`
  // n'est là que pour le jour où ce réglage changerait, `sticky` rattachant un
  // bloc à ce qui le suit et non à ce qui le précède.
  //
  // Seules les figures sécables en tirent parti — les tableaux, rendus tels
  // ci-dessus —, une figure insécable emportant déjà sa légende avec elle.
  show figure.caption: it => block(
    width: 100%,
    sticky: it.position == top,
    {
      set par(justify: false)
      set align(left)
      // Pas de numérotation (figure non référençable) : il n'y a pas d'appel
      // à composer, seul le libellé est rendu.
      if it.numbering != none {
        text(weight: "bold", {
          it.supplement
          [ ]
          context it.counter.display(it.numbering)
          tr(language, h(0.16em), none)
          [:]
        })
        [ ]
      }
      it.body
    },
  )

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

  // Repère du début du texte principal : l'entête particulière (nº de document
  // et date de publication) se pose sur cette page, quel que soit le nombre de
  // pages occupées par la table des matières.
  [#metadata("start") <ofce-main-start>]

  //// Titre, sous-titre et auteurs

  v(4cm)

  // Les titres ne se justifient pas : ils restent au fer à gauche.
  block(width: 100%)[
    #set par(justify: false)
    #text(title, size: 24pt, weight: "bold", font: serif_font)
    #if subtitle != none {
      v(1em)
      text(subtitle, size: 16pt, weight: "semibold")
    }
  ]

  v(1em)
  text(author_strings.join(", ", last: " & "))

  //// Corps du document

  // Séparation avec les pages liminaires
  v(4em)

  if cols == 1 {
    doc
  } else {
    columns(cols, gutter: col-gutter, doc)
  }

  v(4cm)
}
