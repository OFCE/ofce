#' MAJ le cache sna
#'
#' @param cache le dossier du cache (par défaut /data/eurostat)
#'
#' @return la liste des bases mises \\U+E00E0 jour
#' @export
#'
#' @examples
#' if(interactive()) sna_check_cache()
sna_check_cache <- function(cache="./data/eurostat") {
  rlang::check_installed("qs", reason = "pour utiliser sna_get`")
  rlang::check_installed("fs", reason = "pour utiliser sna_get`")
  rlang::check_installed("eurostat", reason = "pour utiliser sna_get`")

  datasets <- eurostat::search_eurostat("") |>
    dplyr::distinct() |>
    dplyr::mutate(update = lubridate::dmy(.data[["last update of data"]]))
  if(!fs::dir_exists(cache))
  {
    message("cache vide")
    return(NULL)
  }
  cached <- fs::file_info(fs::dir_ls(cache)) |>
    dplyr::filter(.data[["type"]]=="file") |>
    dplyr::mutate(code = .data[["path"]] |> fs::path_file() |> fs::path_ext_remove()) |>
    dplyr::select(-c("type")) |>
    dplyr::left_join(datasets, by = "code") |>
    tidyr::drop_na(.data[["update"]])
  updated <- purrr::map_chr(cached$path, ~{
    dd <- qs::qread(.x, nthreads = 4)
    cc <- as.character(attr(dd, "lastupdate"))
    if(length(cc)==0)
      NA_character_
    else
      cc})
  cached <- cached |>
    dplyr::mutate(
      previous_update = lubridate::ymd(updated),
      updated = .data[["previous_update"]]<.data[["update"]]|is.na(.data[["previous_update"]]))
  unvalid <- cached |>
    dplyr::filter(updated)
  purrr::walk(unvalid$code, ~sna_get(dataset = .x, force=TRUE, cache=cache))
  if(length(unvalid$code)==0)
    message("pas de mises \u00e0 jour")
  else
    message(stringr::str_c(stringr::str_c(unvalid$code,collapse=", "), " MAJ"))
  invisible(cached |> dplyr::select(
    dplyr::all_of(c("updated", "code", "title", "type", "path", "update", "previous_update")),
    structure_change =.data[["last table structure change"]],
    data_start = .data[["data start"]],
    data_end = .data[["data end"]]))
}
