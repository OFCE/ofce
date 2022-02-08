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
#'
sna_eurostat <- function(dataset, ..., pivot="auto", name="values",
                         cache="./data/eurostat", select_time=NULL) {
  fn <- stringr::str_c(cache,"/", dataset,".qs")
  if(file.exists(fn))
    data.raw <- qs::qread(fn, nthreads = 4)
  else {
    data.raw <- eurostat::get_eurostat(
      id=dataset,
      compress_file = FALSE,
      select_time=select_time)
    dir.create(
      cache,
      showWarnings = FALSE)
    qs::qsave(
      data.raw,
      fn,
      preset="fast",
      nthreads = 4)
  }
  filters <- list(...)
  filters <- purrr::compact(filters)
  filters <- filters[intersect(names(data.raw), names(filters))]
  le_filtre <- purrr::reduce(purrr::map(names(filters), ~data.raw[[.x]]%in%filters[[.x]]), `&`)
  data.raw <- data.raw |> dplyr::filter(le_filtre) |>
    as_tsibble(index=time, key = c(-time, -values))

  data.raw <- switch(
    pivot,
    "geo" = data.raw |> pivot_wider(names_from = geo, values_from = values),
    "auto" = {
      pp <- keep(filters, ~length(.x)>1)
      pp <- pp[intersect(names(pp), setdiff(names(data.raw), "geo"))]
      if(length(pp)>0)
        data.raw |> pivot_wider(names_from = all_of(names(pp)), values_from = values)
      else
      {
        data.raw |> rename("{name}" := values)
      }
    },
    "no" = data.raw |> rename("{name}" := values))
  return(data.raw |> dplyr::select(where(~length(unique(.x))>1)))
}
