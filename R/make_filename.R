
# fonction pour fabriquer le nom du fichier
#' make filename
#'
#' @param x nom de l'objet
#' @param file nom du fichier crée (par défaut nom de x)
#' @param rep stringr
#' @param env environnement
#' @param ext nom de l'extension du fichier (.png, .jpg,...)
#'
#' @return un nom de fichier
#' @export
#'

make_filename <- function(x, file="", rep="", env, ext)
{
  if(file == "") {
    file <- x
  }
  else
    file <- glue::glue(file, .envir = env)
  if(rep!="")
    rep <- stringr::str_c(glue::glue(rep, .envir = env), "/")
  stringr::str_c(rep, file, ".", ext)
}
