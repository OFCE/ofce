
#show: body => title-page(
  title: [$title$],
  email: "mailto: student@youraddress.com",
  subtitle: [$subtitle$],$if(by-author)$
  authors: (
    $for(by-author)$
      $if(it.name.literal)$(
        name: [$it.name.literal$],
        affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
        email: [$it.email$] ),
      $endif$
    $endfor$
  ),
  abstract: [$description$],
  year: [2024],
  number:[$wp$],

$if(date)$
  first_publish: [$date$],
$endif$

$if(lang)$
  language: "$lang$",
$endif$
  body
)

#show: doc => preprint(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
  number:[$wp$],
$if(running-head)$
  running-head: [$running-head$],
$endif$
  authors: (
    $for(by-author)$
      $if(it.name.literal)$(
        name: [$it.name.literal$],
        affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
        email: [$it.email$] ),
      $endif$
    $endfor$
  ),
$endif$
$if(date)$
  first_publish: [$date$],
$endif$
$if(leading)$
  leading: $leading$,
$endif$
$if(branding)$
  branding: "$branding$",
$endif$
$if(spacing)$
  spacing: $spacing$,
$endif$
$if(linkcolor)$
  linkcolor: $linkcolor$,
$endif$
$if(citation)$
  citation: (
    type: "$citation.type$",
    container-title: "$citation.container-title$",
    doi: "$citation.doi$",
    url: "$citation.url$"
  ),
$endif$
$if(authornote)$
  authornote: [$authornote$],
$endif$
$if(lang)$
  language: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(keywords)$
  keywords: [$for(keywords)$$it$$sep$, $endfor$],
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(section-numbering)$
  section-numbering: "$section-numbering$",
$endif$
$if(toc)$
  toc: $toc$,
$endif$
$if(toc_depth)$
  toc_depth: $toc_depth$,
$endif$
$if(toc_title)$
  toc_title: "$toc_title$",
$endif$
$if(toc_indent)$
  toc_indent: "$toc_indent$",
$endif$
$if(cols)$
  cols: $cols$,
$endif$
$if(col-gutter)$
  col-gutter: $col-gutter$,
$endif$
$if(bibliography-style)$
  bibliography-style: [$bibliography-style$],
$endif$
$if(bibliography-title)$
  bibliography-title: [$bibliography-title$],
$endif$
  doc,
)
