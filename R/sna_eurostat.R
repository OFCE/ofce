#' Extrait les données eurostat SNA
#'
#' Cette fonction permet d'extraire rapidement des données des comptes naitonaux sur eurostat.
#' Elle utilise la fonction \code{\link[eurostat:get_eurostat]{get_eurostat}} et effectue plusieurs opérations supplémentaires:
#' \itemize{
#'    \item Elle met en cache le fichier eurostat, dans un dossier dans le répertoire courant/ Le chache est accédé avec qs pour plus de rapidité
#'          \code{\link[eurostat:get_eurostat]{get_eurostat}} utilise un cahce, mais il est très lent. Cette fonction est utilisée la première fois.
#'    \item Elle sélectionne les données à partir des paramètres retourne un tibble avec uniquement ces colonnes.
#'          Les données sont retournées en formet long sauf si on défini une variable de pivot. Les dimensions ne prenant qu'une valeur sont éliminées.
#'    \item Elle doucmente les colonnes éliminées.
#' }
#'
#' @param dataset string, le code eurostat du dataset en minuscule
#' @param ... une série de paramètres du nom des champs présents dans le dataset, suivi des valeurs qui sont sélectionnées, soit une chaîne, sous un vecteur de chaînes
#' @param pivot un vecteur de variables qui seront utilisées pour le pivot
#' @param prefix un prefix ajouté à tous les noms de variables
#' @param cache string, le chemin d'accès au cache
#' @param select_time la période de temps téléchargée lors du chargement initial. N'est aps très utile sauf pour limiter l'empreinte disque.
#'
#' @return un tibble, avec un attribut par colonne qui documente
#' @export
#' @importFrom rlang .data
#' @examples
#' # récupère toute la base des comptes annuels pour le pib et ses composantes
#' sna_eurostat("nama_10_gdp")
#' # ne garde que
#' sna_eurostat("nama_10_gdp", unit='CLV05_MEUR', na_item = "B1G", geo=c("DE", "FR"))
#'
sna_eurostat <- function(dataset, ..., pivot="auto", prefix="", name="",
                         cache="./data/eurostat", select_time=NULL, lang="en") {
  # fichier en cache
  fn <- stringr::str_c(cache,"/", dataset,".qs")
  if(file.exists(fn))
    data.raw <- qs::qread(fn, nthreads = 4)
  else {
    # si pas de chache, on téélcharge, on crée le cache et on cache
    data.raw <- eurostat::get_eurostat(
      id=dataset,
      compress_file = FALSE,
      select_time=select_time)
    dir.create(
      cache,
      showWarnings = FALSE,
      recursive = TRUE)
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

  data.raw <- switch(
    pivot,
    "geo" = data.raw |> pivot_wider(names_from = geo, values_from = values),
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
          ~eurostat::label_eurostat(.x, dic=dplyr::cur_column(), lang=lang),
          .names = "{col}_label"))
      v_l <- purrr::map_dbl(v_n, ~length(unique(vvv[[.x]])))
      # construit un id à partir des colonnes à valeur unique
      id <- stringr::str_c(purrr::map_chr(names(v_l[v_l==1L]), ~unique(vvv[[.x]])), collapse="_")
      label <- stringr::str_c(
        purrr::map_chr(names(v_l[v_l==1L]), ~unique(vvv[[stringr::str_c(.x, "_label")]])),
        collapse="; ")
      pp <- purrr::keep(filters, ~length(.x)>1)
      pp <- pp[intersect(names(pp), setdiff(names(data.raw), "geo"))]

      if(length(pp)>0)
        data.raw <- data.raw |>
        tidyr::pivot_wider(names_from = all_of(names(pp)), values_from = values)
      else
      {
        if(name=="")
          if(id=="") name <- "values" else name <- id
        data.raw <- data.raw |> dplyr::rename("{name}" := values)
      }
      attr(data.raw, "code") <- id
      attr(data.raw, "label") <- label
      data.raw
    },
    "no" = data.raw |> dplyr::rename("{name}" := values))
  data.raw <- data.raw |>
    dplyr::select(tidyselect:::where(~length(unique(.x))>1)) |>
    dplyr::rename_with(~stringr::str_c(prefix, .x), .cols=-c(geo, time))
  return(data.raw)
}
