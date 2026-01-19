/// SINGLE PAGE BLOG template
#import "@preview/icu-datetime:0.1.2": fmt-datetime, fmt-date

// Colour definition
#let grey0 = rgb("#030303")
#let grey1 = rgb("#6B6B6B")
#let grey2 = rgb("#A6A6A6")
#let grey3 = rgb("#E6E1D8")
#let scpored = rgb("#e6142d")
#let scpodarkred = rgb("#770C19")
#let colourtype = rgb("#DB2E43")

// Font definition
#let main_title_font = "Open sans"
#let serif_font = "Open sans"

#let single-page-blog(
  title: [],
  subtitle: [],
  authors: none,
  abstract: none,
  first_publish: none,
  year: [],
  number: [],
  language: "fr",
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  linkcolor: rgb(0, 0, 0),
  linky: none,
  doc,
) = {




  // Date formatting
  let main_date = if first_publish != none {
    first_publish.text
  } else {
    none
  }

  let pretty_date = if main_date != none {
    let date_decomp = main_date.split("-")
    let year_fp = int(date_decomp.at(0))
    let month_fp = int(date_decomp.at(1))
    let day_fp = int(date_decomp.at(2))
    let date_formatted = datetime(year: year_fp, month: month_fp, day: day_fp)
    fmt-date(date_formatted, length: "long", locale: language)
  }

  // Page settings
  set page(
    paper: "a4",
    flipped: true,
    margin: (left: 2.5cm, right: 2.5cm, top: 0.5cm, bottom: 0.5cm),
    numbering: none,
  )

  // Text settings
  set text(
    font: font,
    size: fontsize
  )

  // Paragraph settings
  set par(
    justify: true,
    leading: 0.6em,
    spacing: 1em
  )

  // Set link colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  // Heading styles
  show heading.where(level: 1): it => block(width: 100%, below: 0.8em, above: 1em)[
    #set text(size: fontsize * 1.1, weight: "bold")
    #it
  ]
  
  show heading.where(level: 2): it => block(width: 100%, below: 0.8em, above: 1em)[
    #set text(size: fontsize * 1.05)
    #it
  ]

  // Header with logos
  grid(
    columns: (1fr, auto, auto),
    align: (left, center, right),
    
    image("/_extensions/ofce/blog/ofce_m.png", width: 2cm),
    text(fill: gray, size: 1.5em, font: serif_font, style: "italic", "Focus Graphique  ",top-edge: "ascender"),
    square(
      fill: colourtype, size: 1cm,  
      align(center + horizon, 
      text(fill: white, size: 0.8cm, number))
    )
    )

  // grid(
  //  columns: (1fr, auto, auto),
  //  align: (left, center, right),
  //  image("/_extensions/ofce/blog/sciencespo.png", width: 2cm)

  //  )
    

  
  

  v(1em)

  // Title section
  block(
    text(size: 16pt, weight: "bold", fill: scpored, title)
  )

  if subtitle != none and subtitle != [] {
    v(0.5em)
    block(
      text(size: 14pt, fill: grey1, subtitle)
    )
  }

  v(1em)

  // Authors
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


  

  

 // v(1em)

  // Horizontal line separator
  //line(length: 100%, stroke: (thickness: 0.5pt, paint: grey2))

  //v(1em)

  

  // Main document content
    grid(
    columns: (78%, 1fr),
    column-gutter: 0.5em,
    [
      // Main document content
      #doc
    ],
    [
    
      // Publication date
  #if pretty_date != none {
    v(0.5em)
    text(size: 10pt, fill: grey1, [Publié le #pretty_date])
  }
  
      // Abstract in colored box if provided
      #v(2em)
      #if abstract != none and abstract != [] {
        block(
          fill: grey3,
          inset: 1em,
          radius: 4pt,
          width: 100%,
          text(style: "italic", size: 10pt, abstract)
        )
      }
      
          // Website url 
    
  #if linky != none {
    v(0.5em)
    // Extract text content from linky if it's content type
    let url_str = if type(linky) == "content" {
      // Convert content to plain text by getting all text nodes
      let extract_text(content) = {
        if type(content) == "string" {
          content
        } else if content.has("text") {
          content.text
        } else if content.has("children") {
          content.children.map(extract_text).join("")
        } else if content.has("body") {
          extract_text(content.body)
        } else {
          ""
        }
      }
      extract_text(linky)
    } else {
      linky
    }
    text(size: 10pt, fill: grey1)[Lien vers le billet sur le site de l'OFCE : #link(url_str)[#url_str]]
  }
    ]
  )


}

// Table styling
#set table(
  inset: 6pt,
  stroke: none
)