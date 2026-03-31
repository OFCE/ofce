#' Bouton de téléchargement
#'
#' Cette fonction peremt d'ajouter un bouton de télchargement dans la marge d'un document quarto.
#' Elle repose sur `downloadthis` et prépare le div pour son affichage correct.
#' Elle doit être appelée dans un chunk `r` avec `results="asis"` impérativement.
#'
#' @param data les données à téélcharger (un tibble donc)
#' @param output_name ("données" par défaut) le nom du fichier de sortie
#' @param label ("données") le nom du bouton qui apparaît dans le rendu du quarto
#' @param margin (TRUE) si FALSE le bouton est inline (non implémenté pour le moment)
#' @param format format du ficher à télécharger, mis en option du package ( `ofce.output_extension` par défaut), peut être ".csv", ".xlsx"
#' @param prefix préfixe pour les fichiers téléchargés (`ofce.output_prefix` par défaut)
#'
#' @returns NULL (side effect : du markdown)
#' @export

margin_download <- function(
    data, output_name = "donnees", label = "donn\u00e9es",
    margin = TRUE, output_extension = getOption("ofce.output_extension"),
    prefix = getOption("ofce.output_prefix")) {

  if(knitr::is_html_output()) {
    if(lobstr::obj_size(data)> 1e+5)
      cli::cli_alert("la taille de l'objet est sup\u00e9rieure à 100kB")

    if(! output_extension %in% c(".csv", ".xlsx"))
      output_extension <- ".csv"

    fn <- stringr::str_c(prefix, tolower(output_name))

    dwn <- downloadthis::download_this(
      data,
      output_extension = output_extension,
      icon = "fa fa-download",
      class = "dbtn",
      button_label  = label,
      output_name = fn)

    cat(stringr::str_c("::: {.column-margin} \n" ))
    dwn |> htmltools::tagList() |> print()
    cat("\n")
    cat(":::\n")

  } else
    return(invisible(NULL))
}

#' Bouton de téléchargement d'un fichier
#'
#' Cette fonction peremt d'ajouter un bouton de télchargement dans la marge d'un document quarto.
#' Elle repose sur `downloadthis::download_file` et prépare le div pour son affichage correct.
#' Elle doit être appelée dans un chunk `r` avec `results="asis"` impérativement.
#'
#' @param path les données à téélcharger (un tibble donc)
#' @param output_name (`fs::path_file(path)` par défaut) le nom du fichier de sortie
#' @param label ("données") le nom du bouton qui apparaît dans le rendu du quarto
#' @param margin (TRUE) si FALSE le bouton est inline (non implémenté pour le moment)
#' @param prefix préfixe pour les fichiers téléchargés (`ofce.output_prefix` par défaut)
#'
#' @returns NULL (side effect : du markdown)
#' @export

margin_download_file <- function(
    path,
    output_name = fs::path_file(path),
    label = "donn\u00e9es",
    margin = TRUE,
    prefix = getOption("ofce.output_prefix")) {

  if(knitr::is_html_output()) {

    fn <- stringr::str_c(prefix, tolower(output_name))

    dwn <- downloadthis::download_file(
      data,
      output_extension = output_extension,
      icon = "fa fa-download",
      class = "dbtn",
      button_label  = label,
      output_name = fn)

    cat(stringr::str_c("::: {.column-margin} \n" ))
    dwn |> htmltools::tagList() |> print()
    cat("\n")
    cat(":::\n")

  } else
    return(invisible(NULL))
}
