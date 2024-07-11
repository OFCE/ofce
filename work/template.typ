#let conf(title, doc) = {
  set page(
    paper: "a5",
    header: align(
      right + horizon,
      title
    ),

  )
  set par(justify: true)
  set text(
    font: "Arial",
    size: 24pt,
  )



  columns(2, doc)
}

#show: doc => conf(
  [Paper title],
  doc,)