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
$if(date-modified)$
  modified: "$date-modified$",
$endif$
$if(lang)$
  language: "$lang$",
$endif$
$if(nb)$
  number: [$nb$],
$endif$
$if(institut)$
  institut: "$institut$",
$endif$
$if(annee)$
  year: [$annee$],
$endif$

$if(mainfont)$
  font: ("$mainfont$",),
$endif$

$if(fontsize)$
  fontsize: $fontsize$,
$endif$

$if(urlblog)$
  linky: [$urlblog$],
$endif$

$if(scalepic)$
  scalepic: $scalepic$,
$endif$


$if(extraref)$
  extrarefs: (
    $for(extraref)$
      $if(it.texte)$(
        texte: [$it.texte$],
        lien: "$it.lien$",
      ),
      $endif$
    $endfor$
  ),
$endif$

  doc,
)