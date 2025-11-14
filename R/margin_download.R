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
#' @param format format du ficher à télécharger, mis en option du package ( `ofce.download_format`)
#'
#' @returns NULL (side effect : du markdown)
#' @export

margin_download <- function(data, output_name = "donnees", label = "donn\u00e9es", margin = TRUE, format = getOption("ofce.download_format")) {

  if(knitr::is_html_output()) {
    if(lobstr::obj_size(data)> 1e+5)
      cli::cli_alert("la taille de l'objet est sup\u00e9rieure à 100kB")
    fn <- str_c("ofce-prev2503-", tolower(output_name))

    dwn <- downloadthis::download_this(
      data,
      icon = "fa fa-download",
      class = "dbtn",
      button_label  = label,
      output_name = fn)

    cat(str_c("::: {.column-margin} \n" ))
    dwn |> htmltools::tagList() |> print()
    cat("\n")
    cat(":::\n")

  } else
    return(invisible(NULL))
}
