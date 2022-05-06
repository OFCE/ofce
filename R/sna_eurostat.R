#' Extrait les données eurostat SNA
#'
#' Cette fonction permet d'extraire rapidement des données des comptes naitonaux sur eurostat.
#' Elle utilise la fonction \code{\link[eurostat:get_eurostat]{get_eurostat}} et effectue plusieurs opérations supplémentaires:
#' \itemize{
#'    \item Elle met en cache le fichier eurostat, dans un dossier dans le répertoire courant/ Le chache est accédé avec qs pour plus de rapidité
#'          \code{\link[eurostat:get_eurostat]{get_eurostat}} utilise un cachee, mais il est très lent. Cette fonction est utilisée la première fois.
#'    \item Elle sélectionne les données à partir des paramètres retourne un tibble avec uniquement ces colonnes.
#'          Les données sont retournées en formet long sauf si on défini une variable de pivot. Les dimensions ne prenant qu'une valeur sont éliminées.
#'    \item Elle documente les colonnes éliminées.
#' }
#'
#' @param dataset string, le code eurostat du dataset en minuscule
#' @param ... une série de paramètres du nom des champs présents dans le dataset, suivi des valeurs qui sont sélectionnées, soit une chaîne, sous un vecteur de chaînes
#' @param pivot un vecteur de variables qui seront utilisées pour le pivot
#' @param prefix un prefix ajouté à tous les noms de variables
#' @param cache string, le chemin d'accès au cache
#' @param select_time la période de temps téléchargée lors du chargement initial. N'est aps très utile sauf pour limiter l'empreinte disque.
#' @param force télécharge systématiquement
#'
#' @return un tibble, avec un attribut par colonne qui documente
#' @seealso sna_show qui affiche des informations sur la base
#' @export
#' @importFrom rlang .data
#' @examples
#'
#' # récupère toute la base des comptes annuels pour le pib et ses composantes
#' sna_get("nama_10_gdp")
#' # ne garde que certaines colonnes
#' sna_get("nama_10_gdp", unit='CLV05_MEUR', na_item = "B1G", geo=c("DE", "FR"))
#'
sna_get <- function(dataset, ..., pivot="auto", prefix="", name="",
                    cache="./data/eurostat", select_time=NULL, lang="en", force=FALSE) {
  # fichier en cache
  fn <- stringr::str_c(cache,"/", dataset,".qs")
  rlang::check_installed("qs", reason = "pour utiliser sna_get`")
  rlang::check_installed("eurostat", reason = "pour utiliser sna_get`")
  rlang::check_installed("fs", reason = "pour utiliser sna_get`")

  if(!force&&file.exists(fn))
  {
    data.raw <- qs::qread(fn, nthreads = 4)
    updated <- attr(data.raw,"lastupdate")
  }
  else {
    # si pas de chache, on télécharge, on crée le cache et on cache
    updated <- eurostat::search_eurostat("") |>
      dplyr::filter(code==dataset) |>
      dplyr::distinct() |>
      dplyr::mutate(update = lubridate::dmy(`last update of data`)) |>
      dplyr::pull()
    data.raw <- eurostat::get_eurostat(
      id=dataset,
      cache=FALSE,
      compress_file = FALSE,
      select_time=select_time)
    attr(data.raw, "lastupdate") <- updated
    fs::dir_create(
      cache,
      recurse = TRUE)
    qs::qsave(
      data.raw,
      fn,
      preset="fast",
      nthreads = 4)
  }

  filters <- list(...)
  # on enlève les NA et nulls
  filters <- purrr::compact(filters)
  # on garde les présents
  filters <- filters[intersect(names(data.raw), names(filters))]
  if(length(filters)>0) {
    # si un filtre on construit l'indicatrice
    le_filtre <- purrr::reduce(
      purrr::map(names(filters), ~data.raw[[.x]]%in%filters[[.x]]),
      `&`)
    # qu'on applique
    data.raw <- data.raw |> dplyr::filter(le_filtre)
  }
  else
    le_filtre <- NULL
  sna_info <- NULL
  sna_info$filtre <- filters
  sna_info$dataset <- dataset
  sna_info$pivot <- pivot
  sna_info$date <- file.info(fn)$mtime
  sna_info$lastupdate <- updated
  data.raw <- switch(
    pivot,
    "geo" = {
      sna_info$pivot_col <- dplyr::distinct(data.raw, geo) |> dplyr::pull(geo)
      data.raw |> tidyr::pivot_wider(names_from = geo, values_from = values)},
    "auto" = {
      vvv <- data.raw |>
        dplyr::distinct(dplyr::across(c(-values, -geo, -time)))
      # on donne un ordre a priori
      v_n <- rlang::set_names(intersect(
        unique(
          c("na_item", "indec_de", "asset10", "ppe_cat", "sector",
            names(vvv))), names(vvv)))
      # on récupére les labels
      vvv <- vvv |> dplyr::mutate(
        dplyr::across(
          tidyselect::all_of(v_n),
          ~eurostat::label_eurostat(.x, dic=dplyr::cur_column(), lang=lang, fix_duplicated = TRUE),
          .names = "{col}_label"))
      v_l <- purrr::map_dbl(v_n, ~length(unique(vvv[[.x]])))
      # construit un id à partir des colonnes à valeur unique
      id <- stringr::str_c(purrr::map_chr(names(v_l[v_l==1L]), ~unique(vvv[[.x]])), collapse="_")
      label <- stringr::str_c(
        purrr::map_chr(names(v_l[v_l==1L]), ~unique(vvv[[stringr::str_c(.x, "_label")]])),
        collapse="; ")
      pp <- purrr::keep(filters, ~length(.x)>1)
      pp <- pp[intersect(names(pp), setdiff(names(data.raw), "geo"))]

      if(length(pp)>0) {
        sna_info$pivot_col <- names(data.raw)
        data.raw <- data.raw |>
          tidyr::pivot_wider(names_from = dplyr::all_of(names(pp)), values_from = values)
        sna_info$pivot_col <- setdiff(names(data.raw), sna_info$pivot_col)
      }
      else
      {
        if(name=="")
          if(id=="") name <- "values" else name <- id
          sna_info$pivot_col <- NULL
          data.raw <- data.raw |> dplyr::rename("{name}" := values)
      }
      sna_info$code <- id
      sna_info$label <- label
      data.raw
    },
    "no" = {
      sna_info$pivot_cases <- NULL
      if(name=="") name <- "values"
      data.raw |> dplyr::rename("{name}" := values)})
  vu <- purrr::map(
    rlang::set_names(names(data.raw)),
    ~unique(data.raw[[.x]]))
  vu <- purrr::keep(vu, ~length(.x)==1)
  data.raw <- data.raw |>
    dplyr::select(-any_of(names(vu)))
  sna_info$vu <- vu
  data.raw <- data.raw |>
    dplyr::rename_with(~stringr::str_c(prefix, .x), .cols=-any_of(c("geo", "time")))
  attr(data.raw, "sna_info") <- sna_info
  return(data.raw)
}

#' Infos sur une base sna Eurostat
#'
#' Affiche les principales informations sur une base téléchargée sur Eurostat.
#' Les informations sont en partie stockées dans les attributs du tibble.
#' Ils peuvent être perdus en route.
#'
#' @param sna le tibble téléchargé sur eurostat
#'
#' @return le tibble, invisible plus un effet de bord sur la console
#' @export
#'
#' @examples
#' data <- sna_get("nama_10_gdp")
#' sna_show(data)
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
  print("Téléchargé le {si$date}" |> glue::glue())
  invisible(sna)
}

#' MAJ le cache sna
#'
#' @param cache le dossier du cache (par défaut /data/eurostat)
#'
#' @return la liste des bases mises à jour
#' @export
#'
#' @examples
#' sna_check_cache()
sna_check_cache <- function(cache="./data/eurostat") {
  rlang::check_installed("qs", reason = "pour utiliser sna_get`")
  rlang::check_installed("fs", reason = "pour utiliser sna_get`")
  rlang::check_installed("eurostat", reason = "pour utiliser sna_get`")

  datasets <- eurostat::search_eurostat("") |>
    dplyr::distinct() |>
    dplyr::mutate(update = lubridate::dmy(`last update of data`))
  if(!fs::dir_exists(cache))
  {
    message("cache vide")
    return(NULL)
  }
  cached <- fs::file_info(fs::dir_ls(cache)) |>
    dplyr::filter(type=="file") |>
    dplyr::mutate(code = path |> fs::path_file() |> fs::path_ext_remove()) |>
    dplyr::select(-type) |>
    dplyr::left_join(datasets, by = "code") |>
    tidyr::drop_na(update)
  updated <- purrr::map_chr(cached$path, ~{
    dd <- qs::qread(.x, nthreads = 4)
    cc <- as.character(attr(dd, "lastupdate"))
    if(length(cc)==0)
      NA_character_
    else
      cc})
  cached <- cached |>
    dplyr::mutate(previous_update = lubridate::ymd(updated),
           updated = previous_update<update|is.na(previous_update))
  unvalid <- cached |>
    dplyr::filter(updated)
  purrr::walk(unvalid$code, ~sna_get(dataset = .x, force=TRUE, cache=cache))
  if(length(unvalid$code)==0)
    message("pas de mises à jour")
  else
    message(stringr::str_c(stringr::str_c(unvalid$code,collapse=", "), " MAJ"))
  invisible(cached |> dplyr::select(updated, code, title, type, path, update, previous_update,
                             structure_change =`last table structure change`,
                             data_start = `data start`, data_end = `data end`))
}

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

