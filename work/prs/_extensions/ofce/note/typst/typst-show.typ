#show: doc => note_ofce(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(wp)$
  number: [$wp$],
$endif$
$if(institut)$
  institut: "$institut$",
$endif$
$if(by-author)$
  authors: (
    $for(by-author)$
      $if(it.name.literal)$(
        name: [$it.name.literal$],
        affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
      ),
      $endif$
    $endfor$
  ),
$endif$
$if(date)$
  first_publish: [$date$],
$endif$
$if(date-modified)$
  modified: "$date-modified$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$else$
$if(description)$
  abstract: [$description$],
$endif$
$endif$
$if(stable-url)$
  stable-url: "$stable-url$",
$else$
$if(citation.url)$
  stable-url: "$citation.url$",
$endif$
$endif$
$if(lang)$
  language: "$lang$",
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
$if(bibliography-style)$
  bibliography-style: [$bibliography-style$],
$endif$
$if(bibliography-title)$
  bibliography-title: [$bibliography-title$],
$endif$
$if(cols)$
  cols: $cols$,
$endif$
  doc,
)
