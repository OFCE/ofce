#' Title keywords_list
#'
#' @return a message with the list of the words used
#' @export
#'
keywords_list <- function(){

  load("data/keywords.rda")

  cli::cli_alert("Liste des mots-clés (3 maximum)\ndernière mise-à-jour: 20/10/2024\n")
  return(keywords)
}

