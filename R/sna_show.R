#' Infos sur une base sna Eurostat
#'
#' Affiche les principales informations sur une base téléchargée sur Eurostat.
#' Les informations sont en partie stockées dans les attributs du tibble.
#' Ils peuvent être perdus en route.
#'
#' @param sna le tibble téléchargé sur eurostat
#' @param lang langue
#' @param n nombre de lignes imprimées (par défaut n=100)
#'
#' @return le tibble, invisible plus un effet de bord sur la console
#' @export
#'
#' @examples
#' if(interactive()) {
#' data <- sna_get("nama_10_gdp")
#' sna_show(data)
#' }
sna_show <- function(sna, lang="fr", n=100) {
  rlang::check_installed("qs", reason = "pour utiliser sna_get`")
  rlang::check_installed("eurostat", reason = "pour utiliser sna_get`")

  print(sna)
  si <- attr(sna, "sna_info")
  if(is.null(si)) {
    print("Attributs perdus en route")
    return(invisible(sna))
  }
  print("dataset: {si$dataset} / {eurostat::label_eurostat_tables(si$dataset)}" |> glue::glue())
  id <- si$code
  if(is.null(id)||id!="")
    print("id:{id} / {si$label}" |> glue::glue())
  ff <- si$filtre
  ff_s <- stringr::str_c(purrr::imap_chr(ff, ~stringr::str_c(.y, "=", stringr::str_c(.x, collapse="&"))), collapse=", ")
  if(length(ff)>0)
    print("filtres: {ff_s}" |> glue::glue())

  purrr::iwalk(si$vu, ~ print("{.y} {.x} {eurostat::label_eurostat(.x, dic=.y, fix_duplicated=TRUE, lang=lang)}" |> glue::glue()))
  cats <- setdiff(setdiff(names(sna), si$pivot_col), c("geo", "time", "values", id))
  purrr::walk(
    rlang::set_names(cats),
    ~dplyr::distinct(sna, dplyr::across(.x)) |> dplyr::mutate(label = eurostat::label_eurostat(.data[[.x]], dic=.x, fix_duplicated=TRUE, lang=lang)) |> print(n=n))
  print("T\\U+00E0l\\U+00E0charg\\U+00E0 le {si$date}" |> glue::glue())
  invisible(sna)
}
