
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
  #let main_title_font = "Open sans"
  #let serif_font = "Open sans"

#let title-page(
  title:[],
  subtitle:[],
  authors: none, email:[],
  first_publish: none,
  abstract: none, year:[],
  number:[],
  language: "fr",
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



  let main_date = if first_publish != none {
  first_publish.text
  } else {
  none }


 let pretty_date =   if main_date != none {

    let date_decomp = main_date.split("-")
    let year_fp = int(date_decomp.at(0))
    let month_fp = int(date_decomp.at(1))
    let day_fp = int(date_decomp.at(2))
    let date_formatted = datetime(year: year_fp, month: month_fp, day: day_fp)

    fmt-date(date_formatted, length: "long", locale: language)

  }

    // Page formatting

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
  // #let main_title_font = "Open sans"
  // #let serif_font = "Open sans"


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
  let main_title_font = "Open sans"
  let serif_font = "Open sans"


  // Date formatting

    let main_date = if first_publish != none {
  first_publish.text
  } else {
  none }


 let pretty_date =   if main_date != none {

    let date_decomp = main_date.split("-")
    let year_fp = int(date_decomp.at(0))
    let month_fp = int(date_decomp.at(1))
    let day_fp = int(date_decomp.at(2))
    let date_formatted = datetime(year: year_fp, month: month_fp, day: day_fp)

    fmt-date(date_formatted, length: "long", locale: language)

  }



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
    header:

        // Page 3
              context if here().page() == 3 {

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
    ,
    footer-descent: 24pt,
    footer:

              context if here().page() == 3 {

        } else {

        }

  )

  // Paragraph settings
  set par(
    justify: true,
    leading: leading,
    first-line-indent: first-line-indent,
    spacing: spacing
  )


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
