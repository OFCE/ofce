///// GABARIT TYPST — L'ÉCOGRAPHE (GRAPHIQUE DE LA SEMAINE)
//
// Hiérarchie des commentaires : ///// une page du document, //// une section,
// /// une sous-section, // une remarque ponctuelle.
//
// Le fichier est traité comme un template pandoc : le signe dollar y est un
// caractère d'échappement et doit être doublé (voir la regex de `fmt_date_iso`).
//
// Le format tient sur une seule page à l'italienne : un bandeau de titre, puis
// deux colonnes — le graphique à gauche, le texte d'accompagnement à droite.

#import "@preview/icu-datetime:0.1.2": fmt-datetime, fmt-date

///// PRÉAMBULE — styles et fonctions communes

//// Constantes de style

/// Couleurs
#let grey0 = rgb("#030303")
#let grey1 = rgb("#6B6B6B")
#let grey2 = rgb("#A6A6A6")
#let grey3 = rgb("#E6E1D8")
#let scpored = rgb("#e6142d")
#let scpodarkred = rgb("#770C19")
#let colourtype = rgb("#DB2E43")
#let ife1 = rgb("#7D0000")
#let ife2 = rgb("#21606E")
#let ifegrey = rgb("#DDDBDB")

/// Polices
//
// Mêmes polices que les autres gabarits OFCE : Arimo pour le texte, posé par
// `mainfont` dans le yaml, Merriweather pour le titre et la mention du format.
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

// `institut` dans le yaml choisit le logo du bandeau de titre. Valeur par
// défaut : « ofce », c'est-à-dire le comportement d'avant l'ajout de cet
// argument. Le logo Sciences Po posé en dessous ne dépend pas de l'institut,
// et la mention « L'ÉcoGraphe » non plus.
#let instituts = (
  "ofce": (logo: "ofce.png", sigle: [OFCE], nom: [OFCE]),
  "ife": (logo: "IFE_Institut_logo_noir.png", sigle: [IFE], nom: [Institut français d'économie]),
  "ife-ofce": (logo: "IFE-OFCE_logo_noir.png", sigle: [IFE|OFCE], nom: [IFE|OFCE]),
  "ife-cepii": (logo: "IFE-CEPII_logo_noir.png", sigle: [IFE|CEPII], nom: [IFE|CEPII]),
  "ife-ofce-cepii": (logo: "IFE-OFCE-CEPII_logo_noir.png", sigle: [IFE|OFCE|CEPII], nom: [IFE|OFCE|CEPII]),
)

// Les logos n'ont pas le même format : ils sont dimensionnés en hauteur, pour
// un poids visuel identique d'un institut à l'autre. Cette hauteur est celle
// du logo OFCE tel qu'il était posé en largeur (2 cm).
#let hauteur_logo = 0.92cm

// Fiche de l'institut demandé ; erreur explicite si la valeur est inconnue.
#let fiche_institut(institut) = {
  let cle = if institut == none { "ife" } else { lower(str(institut).trim()) }
  if cle not in instituts {
    panic("institut inconnu : « " + cle + " ». Valeurs possibles : " + instituts.keys().join(", ") + ".")
  }
  instituts.at(cle)
}

#let chemin_logo(fichier) = "/_extensions/ofce/ofce/img/" + fichier

//// Fonctions communes

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

/// Année affichée sous le numéro
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

/// Texte brut d'une valeur transmise par pandoc
//
// `urlblog` arrive sous forme de contenu : on en extrait la chaîne pour
// pouvoir la passer à `link()`. Pandoc échappe « // » en « /\/ » : on rétablit
// l'URL au passage.
#let texte_brut(valeur) = {
  let extrait(c) = {
    if type(c) == str { c }
    else if c.has("text") { c.text }
    else if c.has("children") { c.children.map(extrait).join("") }
    else if c.has("body") { extrait(c.body) }
    else { "" }
  }
  let brut = if type(valeur) == str { valeur } else { extrait(valeur) }
  brut.replace("/\\/", "//")
}

///// LA PAGE — bandeau de titre, puis graphique et texte en regard

#let single-page-blog(
  title: [],
  subtitle: [],
  authors: none,
  extrarefs: none,
  abstract: none,
  first_publish: none,
  modified: none,
  year: none,
  number: none,
  institut: none,
  language: "fr",
  font: ("Arimo", "Arial"),
  fontsize: 11pt,
  linkcolor: rgb(0, 0, 0),
  linky: none,
  scalepic: 1,
  voir_aussi: none,
  doc,
) = {

  //// Valeurs dérivées des métadonnées

  let fiche = fiche_institut(institut)

  let pretty_date = fmt_date_iso(first_publish, language)
  let pretty_modified = fmt_date_iso(modified, language)
  let annee = annee_doc(year, first_publish)

  //// Géométrie

  let marge = 0.5cm

  //// Réglages de page et de texte

  set page(
    paper: "a4",
    flipped: true,
    margin: (left: 2cm, right: 2cm, top: 0.5cm, bottom: 0.5cm),
    numbering: none,
  )

  set text(font: font, size: fontsize, region: "FR")
  set par(justify: false, leading: 0.6em, spacing: 1em)

  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  /// Titres de section : la page est courte, deux niveaux suffisent
  show heading.where(level: 1): it => block(width: 100%, below: 0.8em, above: 1em)[
    #set text(size: fontsize * 1.1, weight: "bold")
    #it
  ]
  show heading.where(level: 2): it => block(width: 100%, below: 0.8em, above: 1em)[
    #set text(size: fontsize * 1.05)
    #it
  ]

  ///// BANDEAU DE TITRE

  //// Logos, numéro, année et mention du format

  place(top + left, dx: 0cm, dy: 0cm,
    image(chemin_logo(fiche.logo), height: hauteur_logo))

  // Posé juste sous le logo de l'institut, quelle que soit sa hauteur : à une
  // position fixe, les logos larges (IFE|OFCE, IFE|CEPII) le recouvraient.
  place(top + left, dx: 0cm, dy: hauteur_logo + 0.05cm,
    image(chemin_logo("sciencespo.png"), width: 2cm))

  place(top + right, dy: 0cm, dx: marge,
    square(fill: ife2, size: 1cm, align(center + horizon, text(fill: white, size: 0.8cm, number))))

  // L'année n'est affichée que si elle est connue (`annee` dans le yaml, ou
  // déduite de la date de publication).
  if annee != none {
    place(top + right, dy: 1.05cm, dx: marge,
      text(fill: ife2, size: 0.43cm, align(right + horizon, annee)))
  }

  place(top + right, dx: -0.5cm, dy: 0.25cm,
    align(horizon, text(fill: gray, size: 0.9cm, font: serif_font, style: "italic", "EcoGraph ")))

  v(5em)

  //// Titre

  block(text(size: 16pt, weight: "bold", fill: ife1, font: serif_font, title))

  v(1em)

  //// Auteurs

  if authors != none {
    for author in authors {
      text(author.name, weight: "bold", size: 11pt)
      if author.affiliation != none and author.affiliation != "" {
        text(", ", size: 11pt)
        text(author.affiliation, style: "italic", size: 11pt)
      }
      linebreak()
    }
  }

  ///// CORPS — graphique à gauche, texte d'accompagnement à droite

  // `scalepic` dans le yaml règle la part de la largeur occupée par le
  // graphique ; le texte occupe ce qui reste.
  let largeur_graphique = 70 * scalepic * 1%

  grid(
    columns: (largeur_graphique, 1fr),
    column-gutter: 0.5em,

    /// Colonne de gauche : le graphique
    [#doc],

    /// Colonne de droite : dates, résumé, liens
    [
      #if pretty_date != none {
        text(size: 10pt, fill: grey1, [#tr(language, [Publié le], [Published]) #pretty_date])
      }
      #if pretty_modified != none {
        linebreak()
        text(size: 10pt, fill: grey1, [#tr(language, [Modifié le], [Modified]) #pretty_modified])
      }

      #v(0.5em)

      #if abstract != none and abstract != [] {
        // Résumé justifié : c'est un bloc de texte suivi, pas un titre.
        block(fill: grey3, inset: 1em, radius: 3pt, width: 100%, {
          set par(justify: true)
          text(size: 10pt, abstract)
        })
      }

      // Lien vers le billet en ligne, si `urlblog` est renseignée dans le yaml.
      #if linky != none {
        v(0.5em)
        let url_str = texte_brut(linky)
        align(left, text(size: 10pt, fill: ife2)[#tr(language, [Lien vers le billet sur le site de l'OFCE :], [Read this post on the OFCE website:]) #link(url_str)[#url_str]])
      }

      // Renvois « Voir aussi », si `extraref` est renseignée dans le yaml.
      #if extrarefs != none {
        v(0.5em)
        text(size: 10pt, fill: ife2)[#tr(language, [Voir aussi :], [See also:])]
        v(0.3em)
        for ref in extrarefs {
          let lien = ref.at("lien", default: "")
          if lien != "" {
            text(size: 9pt)[• #link(texte_brut(lien))[#ref.texte]]
          } else {
            text(size: 9pt)[• #ref.texte]
          }
          linebreak()
        }
      }
    ],
  )
}
