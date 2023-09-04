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
#' @param name nom de la base
#' @param lang langue
#'
#' @return un tibble, avec un attribut par colonne qui documente
#' @seealso sna_show qui affiche des informations sur la base
#' @export
#' @importFrom rlang .data :=
#' @importFrom dplyr all_of any_of
#' @examples
#'
#' # récupère toute la base des comptes annuels pour le pib et ses composantes
#' if(interactive()) sna_get("nama_10_gdp")
#' # ne garde que certaines colonnes
#' if(interactive()) sna_get("nama_10_gdp", unit='CLV05_MEUR', na_item = "B1G", geo=c("DE", "FR"))
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
      dplyr::filter(.data[["code"]]==dataset) |>
      dplyr::distinct() |>
      dplyr::mutate(update = lubridate::dmy(.data[["last update of data"]])) |>
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
      sna_info$pivot_col <- dplyr::distinct(data.raw, all_of("geo")) |> dplyr::pull(all_of("geo"))
      data.raw |> tidyr::pivot_wider(names_from = all_of(c("geo")), values_from = all_of("values"))},
    "auto" = {
      vvv <- data.raw |>
        dplyr::distinct(dplyr::across(-dplyr::any_of(c("values", "geo", "time"))))
      # on donne un ordre a priori
      v_n <- rlang::set_names(intersect(
        unique(
          c("na_item", "indec_de", "asset10", "ppe_cat", "sector",
            names(vvv))), names(vvv)))
      # on récupére les labels
      # vvv <- vvv |> dplyr::mutate(
      #   dplyr::across(
      #     tidyselect::all_of(v_n),
      #     ~eurostat::label_eurostat(.x, dic=dplyr::cur_column(), lang=lang, fix_duplicated = TRUE),
      #     .names = "{col}_label"))
      v_l <- purrr::map_dbl(v_n, ~length(unique(vvv[[.x]])))
      # construit un id à partir des colonnes à valeur unique
      id <- stringr::str_c(purrr::map_chr(names(v_l[v_l==1L]), ~unique(vvv[[.x]])), collapse="_")
      # label <- stringr::str_c(
      #   purrr::map_chr(names(v_l[v_l==1L]), ~unique(vvv[[stringr::str_c(.x, "_label")]])),
      #   collapse="; ")
      pp <- purrr::keep(filters, ~length(.x)>1)
      pp <- pp[intersect(names(pp), setdiff(names(data.raw), "geo"))]

      if(length(pp)>0) {
        sna_info$pivot_col <- names(data.raw)
        data.raw <- data.raw |>
          tidyr::pivot_wider(names_from = dplyr::all_of(names(pp)), values_from = all_of("values"))
        sna_info$pivot_col <- setdiff(names(data.raw), sna_info$pivot_col)
      }
      else
      {
        if(name=="")
          if(id=="") name <- "values" else name <- id
          sna_info$pivot_col <- NULL
          data.raw <- data.raw |> dplyr::rename("{name}" := .data[["values"]])
      }
      sna_info$code <- id
      # sna_info$label <- label
      data.raw
    },
    "no" = {
      sna_info$pivot_cases <- NULL
      if(name=="") name <- "values"
      data.raw |> dplyr::rename("{name}" := .data[["values"]])})
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
