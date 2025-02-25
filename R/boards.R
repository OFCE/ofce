# Fonctions pour le board


#' Board avec Azure
#'
#' Lit les dentifiants dans .Renviron et les utilise pour connecter avec Azure.
#' Les identifiants doivent être azure_url et un azure_jeton un jeton sas à obtenir sur le portail azure.
#'
#' Cette fonction permet d'utiliser les fonctions de `{pins}`.
#'
#' @returns un board (de `{pins}`)
#' @export
#'
board <- function() {
  url <- Sys.getenv("azure_url")
  if(length(url)==0)
    cli::cli_abort("Le container Azure n'est pas renseigné dans le .Renviron")
  jeton <- Sys.getenv("azure_jeton")
  pins::board_azure(
    AzureStor::storage_container(
      Sys.getenv("azure_url"),
      sas = Sys.getenv("azure_jeton")))
}


# A documenter plus tard
bd_hash <- function(obj) pins::pin_meta(board, obj)$pin_hash

#' Lit sur le board l'objet specifié
#'
#' @param obj (chaine de caractère) nom de l'objet sur le board
#'
#' @returns un objet R
#' @export
#'
bd_read <- function(obj) {
  pins::pin_read(ofce::board(), obj)
}

#' Ecrit sur le board
#'
#' Wrapper pour pins. la fonction suppose qu'il existe un blob Azure qui a été préalablement créé et
#' dont les éléments sont dans .Renviron (azure_url et azure_jeton) et dont les droits d'accès douvent être corrects.
#'
#' @param obj l'objet que l'on souhaite écrire
#' @param name le nom qu'il aura dans le pins::board, le nom de l'objet si ce n'est pas spécifié
#' @param title le titre du pins, optionel, mais aide à la compréhension de ce que l'objet contient
#' @param description une description, idem, pour faciliter l'usage
#' @param metadata des métadonnées utilisées par pins et stockées dans le board
#' @param tags idem, des tags
#' @param versioned verisoning du board (NULL par défaut, donc suit celui du board)
#'
#' @returns (invisible) le nom du pins
#' @export
#'
#'
bd_write <- function(obj, name=NULL, title=NULL, description=NULL, metadata = NULL, tags=NULL, versioned=NULL) {
  if(is.null(name))
    name <- rlang::as_name(rlang::enquo(obj))
  pins::pin_write(board = ofce::board(),
                  x = obj,
                  name = name,
                  title = title,
                  description = description,
                  metadata = metadata,
                  tags = tags,
                  versioned = versioned,
                  type = "qs")
}
