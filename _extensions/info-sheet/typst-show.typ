#show: info-sheet.with(
$if(title)$
  title: "$title$",
$endif$
$if(edition)$
  edition: [$edition$],
$endif$
$if(publication-info)$
  publication-info: [$publication-info$],
$endif$
)

