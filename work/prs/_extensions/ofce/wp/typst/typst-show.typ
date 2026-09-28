
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
$endif$
$if(abstract)$
  abstract: [$abstract$],
$else$
$if(description)$
  abstract: [$description$],
$endif$
$endif$
$if(keywords)$
  keywords: [$for(keywords)$$it$$sep$, $endfor$],
$endif$
$if(jel)$
  jel: [$for(jel)$$it$$sep$, $endfor$],
$endif$
$if(citation)$
  citation: (
    type: "$citation.type$",
    container-title: "$citation.container-title$",
    doi: "$citation.doi$",
    url: "$citation.url$"
  ),
$endif$
$if(annee)$
  year: [$annee$],
$endif$
$if(thanks)$
  thanks: [$thanks$],
$endif$
$if(stable-url)$
  stable-url: "$stable-url$",
$else$
$if(citation.url)$
  stable-url: "$citation.url$",
$endif$
$endif$
$if(thanks-title-fr)$
  thanks-title-fr: "$thanks-title-fr$",
$endif$
$if(thanks-title-en)$
  thanks-title-en: "$thanks-title-en$",
$endif$
$if(institut)$
  institut: "$institut$",
$endif$
  number:[$wp$],
$if(draft)$
  draft: true,
$else$
  draft: false,
$endif$
$if(version)$
  doc_version: [$version$],
$endif$

$if(date)$
  first_publish: [$date$],
$endif$
$if(date-modified)$
  modified: "$date-modified$",
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
$if(institut)$
  institut: "$institut$",
$endif$
  number:[$wp$],
$if(draft)$
  draft: true,
$else$
  draft: false,
$endif$
$if(version)$
  doc_version: [$version$],
$endif$
$if(annee)$
  year: [$annee$],
$endif$
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
$if(date)$
  first_publish: [$date$],
$endif$
$if(date-modified)$
  modified: "$date-modified$",
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
