// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}


/// TITLE PAGE template partial
#import "@preview/icu-datetime:0.1.2": fmt-datetime, fmt-date

///// STYLE ELEMENTS FOR TYPST TEMPLATES


  // Colour definition

  #let grey0 =  rgb("#030303")
  #let grey1 =  rgb("#6B6B6B")
  #let grey2 =  rgb("#A6A6A6")
  #let grey3 =  rgb("#D6D6D6")
  #let scpored = rgb("#e6142d")
  #let scpodarkred = rgb("#770C19")
  #let colourtype = rgb("#EEC900")

  // Font definition
  #let main_title_font = "Helvetica"
  #let serif_font = "Palatino"

#let title-page(title:[],subtitle:[], authors: none, email:[], first_publish: datetime.today(),
abstract: none, year:[],
number:[], language: "fr",
body) = {

  let marge = 3.5cm
  let ph = 29.7cm // page height for a4
  let pw = 21.0cm // page width for a4
  let logo_column = 4cm
  let lc_space = 0.5cm
  let line_x = 0cm + (logo_column - marge) + lc_space*2



// Author block

let nrows = calc.min(authors.len(), 3)

let authorblock()={
if authors != none {
    grid(
      rows: nrows,
      row-gutter: 0.5em,
      ..authors.map(author =>
          align(left)[
            #text(author.name, weight: "bold",size: 11pt), #text(author.affiliation,style:"italic",size: 11pt)
          ]
      )
    )

  }

}




  // Date formatting

  let main_date = first_publish.text
  let date_decomp = main_date.split("-")

  let year_fp = int(date_decomp.at(0))
  let month_fp = int(date_decomp.at(1))
  let day_fp = int(date_decomp.at(2))

  let date_formatted = datetime(year: year_fp, month: month_fp, day: day_fp)

  let pretty_date = fmt-date(date_formatted, length: "long", locale: language)



  set page(margin: (top: marge, rest: marge))

  set text(font: main_title_font, size: 14pt)
  set heading(numbering: "1.1.1")

  // place(top + right, text(blue,"+")) // position tester

  /////// 1. logo position and line

  place(top + left, dx: -marge+lc_space,dy:-2cm,
        image("/_extensions/ofce/blog/ofce_m.png", width: logo_column)
        )

  place(bottom + left, dx: -marge+lc_space,dy: 2cm,
        image("/_extensions/ofce/blog/sciencespo.png", width: logo_column)
      )
  place(left,
        line(start: (line_x, 0cm), end: (line_x,  ph - 2*marge),
  stroke: (thickness: 1.25pt, paint: grey1)))

  //// 2. Title Position



  place(dx: 2cm,dy: 4cm,
    box(width: 13cm,
      align(horizon + left)[
        #text(size: 24pt, title, fill:  scpored,weight: "bold" )
        #v(1em)
        #text(subtitle,fill: grey1)
        #v(2em)

        #authorblock()

        // #text(date_decomp, size: 14pt)


      ]/// end align
    ) /// end box,
  )





  //// 3. Publishing date And Issue number

  place(top+right ,dy:-2cm,dx: marge ,
        square(fill: colourtype, size: 2cm,align(center+horizon,text(fill: white,size: 1cm,number)))
      )

  place(top+right ,dy:0cm,dx: marge ,
        text(fill: colourtype, size: 0.9cm,text(year))
      )

  place(top + right, dx:+1.25cm,dy:-1.5cm, align(horizon,text(fill: gray ,size:2cm,font: serif_font,style:"italic","Blog")))


  place(bottom + right, dx: 1.5cm,

  [
    #text({
      if(first_publish != none){
        [Première publication : ]
        }
        }, weight: "semibold", size: 10pt

        )
    #text({
      if(first_publish != none){
        [ #pretty_date \ ]
        }
        }, size: 10pt

        )


  ]

  )
  //// 4. Abstract

  place(bottom, dx: 2*lc_space + line_x, dy: -1*line_x,
  clearance: 4cm,
    box(fill: grey3, baseline: 100%,width: 13cm,inset: 1em,
      text(style: "italic",abstract,size: 10pt)
      )
    )

  //// 5. Internal cover page
  pagebreak()
  set page(fill: none, margin: auto)

  align(bottom , text("Rédacteurs en chef : Elliot Aurissergues & Paul Malliet") )



  /// start
  //pagebreak()
  body
}


#import "@preview/icu-datetime:0.1.2": fmt-datetime, fmt-date


///// STYLE ELEMENTS FOR TYPST TEMPLATES

  // Colour definition

  // #let grey0 =  rgb("#030303")
  // #let grey1 =  rgb("#6B6B6B")
  // #let grey2 =  rgb("#A6A6A6")
  // #let grey3 =  rgb("#D6D6D6")
  // #let scpored = rgb("#e6142d")
  // #let scpodarkred = rgb("#770C19")
  // #let colourtype = rgb("#EEC900")

  // // Font definition
  // #let main_title_font = "Helvetica"
  // #let serif_font = "Palatino"


/// CORE TEXT


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
  leading: 0.6em,
  spacing: 1em,
  first-line-indent: 0cm,
  linkcolor: rgb(0, 0, 0),
  paper: "a4",
  language:"fr",
  region: "US",
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  section-numbering: none,
  toc: false,
  toc_title: "contents",
  toc_depth: none,
  toc_indent: 1.5em,
  number: none,
  bibliography-title: "Références",
  bibliography-style: "apa",
  cols: 1,
  col-gutter: 4.2%,
  doc,
) = {

  /* Document settings */

  let grey0 =  rgb("#030303")
  let grey1 =  rgb("#6B6B6B")
  let grey2 =  rgb("#A6A6A6")
  let grey3 =  rgb("#D6D6D6")
  let scpored = rgb("#e6142d")
  let scpodarkred = rgb("#770C19")
  let colourtype = rgb("#EEC900")

  // Font definition
  let main_title_font = "Helvetica"
  let serif_font = "Palatino"


  let main_date = first_publish.text
  let date_decomp = main_date.split("-")

  let year_fp = int(date_decomp.at(0))
  let month_fp = int(date_decomp.at(1))
  let day_fp = int(date_decomp.at(2))

  let date_formatted = datetime(year: year_fp, month: month_fp, day: day_fp)

  let pretty_date = fmt-date(date_formatted, length: "long", locale: language)




  // Set link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  // Allow custom title for bibliography section

  set bibliography(title: bibliography-title, style: bibliography-style, )

  // Format author strings here, so can use in author note
  let author_strings = ()
  if authors != none {
    for a in authors{
      let author_string = [#a.name]
      author_strings.push(author_string)
    }

  }

  // Page settings (including headers & footers)
  set page(
    paper: paper,
    margin: (inside: 3.5cm, outside: 2.5cm, rest: 3cm),
    numbering: "1",
    header-ascent: 50%,
    header: locate(
        // Page 3
        loc => if [#loc.page()] == [3] {

          grid(
          columns: (1fr, 1fr),
          align(left+ bottom)[#text([Blog OFCE nº #number\ publié le #pretty_date], style: "italic")],
          align(right + bottom)[#image("/_extensions/ofce/blog/ofce_m.png", width: 1cm) ]

          )


        } else {

          if(calc.even(here().page())){

            grid(
            columns: (1fr, 1fr),
            align(left + bottom)[#counter(page).display()],
            align(right + bottom)[#image("/_extensions/ofce/blog/ofce_m.png", width: 1cm) ]

          )

          } else {
          grid(
            columns: (1fr, 1fr),
            align(left)[#image("/_extensions/ofce/blog/ofce_m.png", width: 1cm) ],
            align(right)[#counter(page).display()]
          )


          }

          // Page >1 header has running head and page number

        line(start: (0cm, -0.5em), end: (15cm,  -0.5em),
  stroke: (thickness: 0.25pt, paint: grey1))
        }
    ),
    footer-descent: 24pt,
    footer: locate(

        loc => if [#loc.page()] == [3] {

        } else {

        }
    )
  )

  // Paragraph settings
  set par(
    justify: true,
    leading: leading,
    first-line-indent: first-line-indent
  )
  // Set space between paragraphs
  show par: set block(spacing: spacing)

  // Text settings
  set text(
    region: region,
    font: font,
    size: fontsize
  )

  // Headers
  set heading(
    numbering: section-numbering
  )
  // Level 1 headers
  show heading.where(
    level: 1
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: fontsize*1.1, weight: "bold")
    #it
  ]
  // Level 2 headers
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: fontsize*1.05)
    #it
  ]
  // Level 3 headers
  show heading.where(
    level: 3
  ): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set text(size: fontsize, style: "italic")
    #it
  ]
  // Level 4 headers are in paragraph
  show heading.where(
    level: 4
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em),
    text(size: 1em, weight: "bold", it)
  )
  // Level 5 headers are in paragraph
  show heading.where(
    level: 5
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em),
    text(size: 1em, weight: "bold", style: "italic", it)
  )


pagebreak()


  /* Content */



v(4cm)



text(title, size: 20pt, weight: "bold")

if subtitle != none {
v(1em)
text(subtitle, size: 16pt, weight: "semibold")
}


v(1em)

text(author_strings.join(", ", last: " & "))

  // Separate content a bit from front matter
  v(4em)

  // Show document content with cols if specified
  if cols == 1 {
    doc
  } else {
    columns(
      cols,
      gutter: col-gutter,
      doc
    )
  }

v(4cm)


// text("Fin" , size: 14pt, weight: "bold")
}

// Remove gridlines from tables
#set table(
  inset: 6pt,
  stroke: none
)


#show: body => title-page(
  title: [Electricité, gaz: quel impact de la hausse de la fiscalité sur les ménages?],
  email: "mailto: student@youraddress.com",
  subtitle: [],  authors: (
          (
        name: [Pierre Madec],
        affiliation: [OFCE, Sciences Po.],
        email: [] ),
      
      ),
  abstract: [La fin du bouclier tarifaire (2,2~milliards d’euros), l’arrêt de la TVA à taux réduit sur les abonnements d’électricité et de gaz (0,9 Md d’euros) ou encore la hausse des accises sur l’énergie (1,1 Md d’euros) figurent parmi les hausses de prélèvements sur les ménages inscrites au projet de loi de finance pour 2025],
  year: [2024],
  number:[],
  first_publish:[2024-10-22],
  language: "fr",
  body
)

#show: doc => preprint(
  title: [Electricité, gaz: quel impact de la hausse de la fiscalité sur les ménages?],
  number:[],
  authors: (
          (
        name: [Pierre Madec],
        affiliation: [OFCE, Sciences Po.],
        email: [] ),
      
      ),
  first_publish: [2024-10-22],
  language: "fr",
  paper: "a4",
  font: ("Arial",),
  doc,
)

La fin du bouclier tarifaire (2,2~milliards d’euros), l’arrêt de la TVA à taux réduit sur les abonnements d’électricité et de gaz (0,9 Md d’euros) ou encore la hausse des accises sur l’énergie (1,1 Md d’euros) figurent parmi les hausses de prélèvements sur les ménages inscrites au #link("https://www.tresor.economie.gouv.fr/Articles/8f94bb55-ebfb-42b7-8ec3-eb1ff0f1ba0c/files/67689426-48b3-4600-9e7e-04071a1a137b")[projet de loi de finance pour 2025];#footnote[Les estimations budgétaires mobilisées ici sont issues du #link("https://www.tresor.economie.gouv.fr/Articles/8f94bb55-ebfb-42b7-8ec3-eb1ff0f1ba0c/files/67689426-48b3-4600-9e7e-04071a1a137b")[Projet de Loi de Finance pour 2025];.];. Si les factures d’électricité devraient baisser — de l’ordre de 9% en moyenne selon les prévisions du gouvernement — sous l’effet de la baisse prévue des prix de l’énergie, les prélèvements devraient croître, du fait de ces mesures discrétionnaires, de plus de 4~milliards d’euros.

Les effets redistributifs de ces hausses de prélèvements sont simulées à l’aide du modèle de #link("https://www.insee.fr/fr/information/2021951")[micro-simulation Ines];, développé conjointement par l’Insee, la Drees et la Cnaf et dont la dernière version reproduit la législation socio fiscale de 2022, et à partir des données de l’enquête #emph[Budget de famille] de 2017, ainsi que des données issues de la comptabilité nationale pour 2023.

En 2023, selon #link("https://www.insee.fr/fr/statistiques/series/127929900?PRIX_REF=2331835&CNA_PRODUIT=2331268+2331269")[l’Insee];, les dépenses d’électricité des ménages s’élevaient à 36~milliards d’euros et celles de gaz à 15~milliards d’euros, soit respectivement 2% et 0,8% du revenu disponible brut des ménages. Les dépenses énergétiques sont globalement croissantes avec le niveau de vie des ménages (@fig-comp1). Selon nos estimations#footnote[En calant nos estimations sur les chiffres de la comptabilité nationale pour 2023, nous prenons en compte les évolutions de comportements de consommation de façon homogène pour l’ensemble des ménages. Dans les faits, il est possible que les ménages les plus modestes aient plus fortement ajusté leurs comportements de consommation (notamment énergétiques) durant l’épisode inflationniste.];, les 5% des ménages les plus modestes consacraient en moyenne 480 euros à leurs dépenses d’électricité et de gaz en 2023 contre près de 1 800 euros pour les 5% des ménages les plus aisés. Les ménages proches du niveau de vie médian consommaient quant à eux entre 800 et 1 000 euros par an.

#figure([
== En euros par ménage
#box(image("fisca_elec_gaz_files/figure-typst/unnamed-chunk-2-1.png", width: 100%))

== En % du revenu disponible
#box(image("fisca_elec_gaz_files/figure-typst/unnamed-chunk-3-1.png", width: 100%))

], caption: figure.caption(
position: top, 
[
Dépense en électricité et en gaz des ménages par vingtième de niveau de vie
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-comp1>


#block[
]
#emph[A contrario];, rapportées au revenu disponible des ménages, les dépenses en électricité et en gaz diminuent quand le revenu augmente : plus les ménages sont modestes, plus leurs dépenses énergétiques occupent une place importante dans leur revenu. Alors que les 5% des ménages les plus modestes consacrent en moyenne 5,5% de leur revenu disponible aux dépenses d’électricité et de gaz, les 5% des ménages les plus aisés n’en consacrent que 1,9 %. Dès lors, si l’augmentation de la fiscalité énergétique devrait davantage impacter en euros les ménages les plus aisés, celle-ci pénaliserait plus durement les ménages les plus modestes en pourcentage de leur revenu disponible (@fig-comp2).

#figure([
== En euros par ménage
#box(image("fisca_elec_gaz_files/figure-typst/unnamed-chunk-5-1.png", width: 100%))

== En % du revenu disponible
#box(image("fisca_elec_gaz_files/figure-typst/unnamed-chunk-6-1.png", width: 100%))

], caption: figure.caption(
position: top, 
[
Impact de l’augmentation de la fiscalité par vingtième de niveau de vie
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-comp2>


#block[
]


 
  
#set bibliography(style: "../csl/revue-francaise-de-gestion.csl") 


