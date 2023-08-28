#' vide le cache sna
#'
#' @param cache le dossier du cache (par défaut /data/eurostat)
#'
#' @return rien
#' @export
#'
sna_clear_cache <- function(cache="./data/eurostat") {
  rlang::check_installed("fs", reason = "pour utiliser sna_get`")
  fs::file_delete(fs::dir_ls(path=cache))
}
