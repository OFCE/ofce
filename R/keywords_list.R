#' Title keywords_list
#'
#' @return a message with the list of the words used
#' @export
#'
keywords_list <- function(){

load("data/keywords.rda")


cat("Liste des mots-cles (3 maximum)\nderniere mise-a-jour: 20/10/2024\n")

  return(keywords)
}
