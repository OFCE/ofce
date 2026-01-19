#show: doc => single-page-blog(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
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
$if(description)$
  abstract: [$description$],
$endif$
$if(date)$
  first_publish: [$date$],
$endif$
$if(lang)$
  language: "$lang$",
$endif$
$if(wp)$
  number: [$wp$],
$endif$
  year: [2024],
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(urly)$
  linky: [$urly$],
$endif$
  doc,
)