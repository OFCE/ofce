# source_data ------------------------------

# source_data est un outil qui permet d'exécuter un code, d'en cacher le résultat dans un dossier spécial (_data) en gardant des métadonnées
# sauf modifications ou écart de temps (à configuer), les appels suivant au code ne sont pas exécutés mais le ficheir de data est relu
# quelques fonctions permettent de diagnostiquer le cache et de suivre les mises à jour.


#' source_data : exécute le code et cache les données
#'
#' Cette fonction s'utilise presque comme source et permet d'en accélérer l'exécution par le cache des données.
#'
#' Le code est exécuté (dans un environnement local) et le résultat est mis en cache. Il est important que le code se termine par un return(les_données).
#' Si return() n'est pas présent dans le code, il n'est pas exécuté et un message d'erreur est envoyé ("NULL" est retourné).
#' le code est exécuté avec un contrôle d'erreur, donc si il bloque, "NULL" est renvoyé, mais sans erreur ni arrêt.
#' les appels suivants seront plus rapides et sans erreur.
#'
#' Une modification du code est détectée et déclenche l'éxécution
#'
#' Suivant le paramètre lapse on peut déclencher une exécution péridique. Par exemple, pour ne pas rater une MAJ, on peut mettre lapse = "1 day" ou "day" et une fois par jour le code sera exécuté.
#' Cela permet d'éviter une exécution à chaque rendu.
#'
#' On peut bloquer l'exécution en renseignant la variable d'environnement "PREVENT_EXEC" pas Sys.setenv(PREVENT_EXEC = "TRUE") ou dans .Renviron.
#' Ce blocage est prioritaire sur tous les autres critères (sauf en cas d'absence de cache).
#'
#' Des métadonnées peuvent être renvoyées (paramètre metadata) avec la date d'exécution ($date), le temps d'exécution ($timing),
#' la taille des données ($size), le chemin de la source ($where), le hash du source ($hash) et bine sûr les données ($data)
#'
#' Les valeurs par défaut peuvent être modifiées simplement par options(ofce.source_data.hash = FALSE) par exemple et persiste pendant une session.
#' Typiquement cela peut être mis dans rinit.r (et donc être exécuté par ofce::init_qmd())
#'
#' @param name (character) le chemin vers le code à exécuter (sans extension .r ou .R), ce chemin doit être relatif au projet (voir relative), bien que une recherche sera effectuée
#' @param relative (character) Si "projet" le chemin est supposé relatif au projet, sinon le chemin sera dans le répertoire de travail (attention il peut changer)
#' @param cache_rep (character) Le chemin du dossier dans lequel sont enregistré les caches (défaut _data)
#' @param hash (boléen) Si TRUE (défaut) un changement dans le code déclenche son exécution
#' @param lapse (character) peut être "never" (défaut) "x hours", "x days", "x weeks", "x months", "x quarters", "x years"
#' @param force_exec (boléen) Si TRUE alors le code est exécuté ($FORCE_EXEC par défaut)
#' @param prevent_exec (boléen) Si TRUE alors le code n'est pas exécuté ($PREVENT_EXEC par défaut), ce flag est prioritaire sur les autres, sauf si il n'y a pas de données en cache
#' @param metadata (boléen) Si TRUE (FALSE par défaut) la fonction retourne une liste avec des métadonnées et le champ data qui contient les données elles même
#'
#' @return data (list ou ce que le code retourne)
#' @export
#'
source_data <- function(name,
                        relative = getOption("ofce.source_data.relative"),
                        cache_rep = getOption("ofce.source_data.cache_rep"),
                        hash = getOption("ofce.source_data.hash"),
                        lapse = getOption("ofce.source_data.lapse"),
                        force_exec = getOption("ofce.source_data.force_exec"),
                        prevent_exec = getOption("ofce.source_data.prevent_exec"),
                        metadata = getOption("ofce.source_data.metadata")) {
  # on trouve le fichier
  # si c'est project on utilise here, sinon, on utilise le wd courant

  name <- remove_ext(name)
  safe_find_root <- purrr::safely(rprojroot::find_root)
  root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)

  if(is.null(root$error))
    root <- root$result
  else {
    cli::cli_alert_warning("{root$error}")
    return(NULL)
  }
  root <- fs::path_norm(root)
  cache_rep <- fs::path_join(c(root, cache_rep)) |> fs::path_norm()

  if(relative=="project") {
    src <- find_src(root, name)
    if(is.null(src)) {
      src <- try_find_src(root, name)
      if(length(src)==0) {
        cli::cli_alert_warning("Le fichier n'existe pas en .r ou .R, vérifier le chemin")
        return(NULL)
      }
      if(length(src)>1) {
        cli::cli_alert_warning("Plusieurs fichiers sont possibles")
        l_src <- purrr::map(src, length)
        src <- src[[which.max(l_src)]]
      }
    }
  }

  if(relative!="project") {
    wd <- getwd()
    src <- fs::path_join(ws, src) |> fs::path_ext_set(".R")
    if(!fs::file_exists(src)) {
      src <- fs::path_join(ws, src) |> fs::path_ext_set(".r")
      if(!fs::file_exists(src)) {
        return(NULL)
      }
    }
  }

  cli::cli_alert_info("{src} comme source")

  if(length(check_return(src))==0) {
    cli::cli_alert_danger("Pas de return() dans le fichier {src}")
    return(NULL)
  }

  if(length(check_return(src))>1) {
    cli::cli_alert_info("Plusieurs return() dans le fichier {src}, attention !")
  }

  basename <- fs::path_file(name)
  relname <- fs::path_rel(src, root)
  reldirname <- fs::path_dir(relname)
  full_cache_rep <- fs::path_join(c(cache_rep, reldirname))

  if(is.null(force_exec)) force <- FALSE else if(force_exec=="TRUE") force <- TRUE else force <- FALSE
  if(is.null(prevent_exec)) prevent <- FALSE else if(prevent_exec=="TRUE") prevent <- TRUE else prevent <- FALSE

  if(force&!prevent) {
    our_data <- exec_source(src, lapse, relname)
    if(our_data$ok) {
      cache_data(our_data, cache_rep = full_cache_rep, name = basename)
      if(metadata) {
        return(our_data)
      } else {
        return(our_data$data)
      }
    } else {
      cli::cli_alert_warning("le fichier {src} retourne une erreur, on cherche dans le cache")
    }
  }

  src_hash <- tools::md5sum(src)

  good_datas <- get_datas(basename, full_cache_rep)

  if(hash&!prevent)
    good_datas <- purrr::keep(good_datas, ~.x[["hash"]]==src_hash)

  if(lapse != "never"&!prevent) {
    lapse <- what_lapse(check_lapse)
    good_datas <- purrr::keep(good_datas, ~lubridate::now() - .x[["date"]] <= lapse)
  }

  if(length(good_datas)==0) {
    if(prevent) {
      cli::cli_alert_warning("Pas de données en cache, pas d'exécution")
      return(NULL)
    }
    our_data <- exec_source(src, lapse, relname)
    if(our_data$ok) {
      cache_data(our_data, cache_rep = full_cache_rep, name = basename)
      if(metadata) {
        return(our_data)
      } else {
        return(our_data$data)
      }
    } else {
      cli::cli_alert_warning("le fichier {src} retourne une erreur et rien dans le cache")
      return(NULL)
    }
  }

  dates <- purrr::map(good_datas, "date")
  good_good_data <- good_datas[[which.max(dates)]]

  if(metadata) {
    return(good_good_data)
  } else {
    return(good_good_data$data)
  }

}

check_return <- function(src) {
  src.txt <- readLines(src, warn=FALSE)
  ret <- stringr::str_extract(src.txt, "^return\\((.+)\\)", group=1)
  purrr::keep(ret, ~!is.na(.x))
}

get_datas <- function(name, data_rep, ext = "qs") {
  pat <- glue::glue("{name}_[0-9]+\\.{ext}$")
  files <- fs::dir_ls(path = data_rep, regexp = pat)
  purrr::map(files, ~ qs::qread(.x))
}

exec_source <- function(src, lapse, relname) {
  safe_source <- purrr::safely(source)

  start <- Sys.time()
  res <- safe_source(src, local=TRUE)
  timing <- as.numeric(Sys.time() - start)

  if(!is.null(res$error))
    return(list(ok=FALSE))

  list(
    data = res$result$value,
    timing = timing,
    date = lubridate::now(),
    size = lobstr::obj_size(res$result$value),
    hash = tools::md5sum(src),
    url = "",
    src = relname,
    lapse = lapse,
    ok = TRUE
  )
}

cache_data <- function(data, cache_rep, name, ext = "qs") {
  pat <- glue::glue("{name}_([0-9]+)\\.{ext}")
  files <- fs::dir_ls(path = cache_rep, regexp = pat)
  cc <- 1
  data_hash <- digest::digest(data$data)
  if(length(files)>0) {
    cc <- stringr::str_extract(files, pat, group = 1) |> as.numeric() |> max()
    fn <- fs::path_join(c(cache_rep, stringr::str_c(name, "_", cc))) |> fs::path_ext_set(ext)
    last_data <- qs::qread(fn)
    last_data_hash <- last_data$data_hash
    if(!is.null(last_data_hash)) {
      if(data_hash == last_data_hash)
        cc <- cc
    } else
      cc <- cc +1
  }
  fs::dir_create(cache_rep, recurse=TRUE)
  data$ok <- NULL
  data$data_hash <- data_hash
  fn <- fs::path_join(c(cache_rep, stringr::str_c(name, "_", cc))) |> fs::path_ext_set(ext)
  qs::qsave(data, file = fn)
}

what_lapse <- function(check) {
  ext <- function(e) {
    num <- stringr::str_extract(e, "^([0-9]+)")
    if(is.na(num))
      num <- 1

    num <- as.numeric(num)
  }
  if(stringr::str_detect(check, "month"))
    return(lubridate::months(ext(check)))
  if(stringr::str_detect(check, "week"))
    return(lubridate::weeks(ext(check)))
  if(stringr::str_detect(check, "quarter"))
    return(lubridate::quarters(ext(check)))
  if(stringr::str_detect(check, "day"))
    return(lubridate::days(ext(check)))
  if(stringr::str_detect(check, "hour"))
    return(lubridate::hours(ext(check)))
  if(stringr::str_detect(check, "year"))
    return(lubridate::years(ext(check)))
}

remove_ext <- function(name) {
  stringr::str_remove(name, "\\.[r|R]$")
}

find_src <- function(root, name) {
  path <- fs::path_join(c(root, name)) |> fs::path_norm()
  fn <- stringr::str_c(path, ".r")
  if(fs::file_exists(fn)) return(fn)
  fn <- stringr::str_c(path, ".R")
  if(fs::file_exists(fn)) return(fn)
  return(NULL)
}

try_find_src <- function(root, name) {
  pat <- glue::glue("{name}\\.[R|r]$")
  ff <- fs::dir_ls(path = root, regexp=pat, recurse=TRUE)
  ff |> purrr::discard(~ stringr::str_detect(.x, "/_"))
}

#' Etat du cache de source_data
#'
#' Donne des informations sur le cache de source_data sous la forme d'un tibble
#'
#' @param data_rep le chemin vers le cache (défaut "_cache")
#'
#' @return tibble
#' @export
#'

source_data_status <- function(data_rep = "_data") {
  safe_find_root <- purrr::safely(rprojroot::find_root)
  root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
  if(is.null(root$error))
    root <- root$result
  else {
    cli::cli_alert_warning("{root$error}")
    return(NULL)
  }
  data_rep <- stringr::str_c(root, "/", data_rep) # absolu maintenant

  caches <- list.files(path = data_rep, pattern = "*.qs", recursive = TRUE, full.names = TRUE)

  purrr::map_dfr(caches, ~{
    dd <- qs::qread(.x)

    tibble::tibble(
      src = dd$src,
      date = dd$date,
      timing = dd$timing,
      size = dd$size,
      lapse = dd$lapse,
      where = .x,
      hash = dd$hash,
      data_hash = dd$data_hash,
    ) |>
      arrange(src, desc(date))
  }
  )
}
