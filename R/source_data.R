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
#' Suivant le paramètre lapse on peut déclencher une exécution périodique.
#' Par exemple, pour ne pas rater une MAJ, on peut mettre `lapse = "1 day"` ou `"day"` et une fois par jour le code sera exécuté.
#' Cela permet d'éviter une exécution à chaque rendu.
#'
#' On peut bloquer l'exécution en renseignant la variable d'environnement `PREVENT_EXEC` pas `Sys.setenv(PREVENT_EXEC = "TRUE")` ou dans `.Renviron`.
#' Ce blocage est prioritaire sur tous les autres critères (sauf en cas d'absence de cache).
#'
#' Des métadonnées peuvent être renvoyées (paramètre metadata) avec la date d'exécution ($date), le temps d'exécution ($timing),
#' la taille des données (`$size`), le chemin de la source (`$where`), le hash du source (`$hash_src`) et bien sûr les données ($data)
#'
#' Les valeurs par défaut peuvent être modifiées simplement par options(ofce.source_data.hash = FALSE) par exemple et persiste pendant une session.
#' Typiquement cela peut être mis dans rinit.r (et donc être exécuté par `ofce::init_qmd()`)
#'
#' Le paramètre `wd` perment de spécifier le répertoire d'exécution du source.
#' Si il est mis à `"file"`, les appels à l'intérieur du code source, comme par exemple un save ou un load seront compris dans le répertoire où se trouve le fichier source.
#' L'intérêt est que le code peut avoir des éléments persistants, locaux
#' L'alternative est d'utiliser `wd="project"` auquel cas, le répertoire d'exécution sera independant de l'endroit où est appelé le code source.
#' Les éléments persistants peuvent alors être dasn un endroit commun et le code peut appeler des éléments persistants d'autres codes sources.
#' En le mettant à `qmd`l'exécution part du fichier qmd, ce qui est le comportement standard de `quarto`.
#' Toute autre valeur pour wd laisse le working directory inchnagé et donc dépendant du contexte d'exécution. Pour ceux qui aiment l'incertitude.
#'
#' En donnant des fichers à suivre par `track`, on peut déclencher l'exécution du source.
#'
#' `unfreeze` permet d'invalider le cache de quarto et de déclencher l'exécution (expérimental)
#'
#' @param name (character) le chemin vers le code à exécuter (sans extension .r ou .R), ce chemin doit être relatif au projet (voir relative), bien que une recherche sera effectuée
#' @param args (list) une liste d'arguments que l'on peut utliser dans source (args$xxx)
#' @param hash (boléen) Si TRUE (défaut) un changement dans le code déclenche son exécution
#' @param track (list) une liste de fichiers (suivant la même règle que src pour les trouver) qui déclenchent l'exécution.
#' @param lapse (character) peut être "never" (défaut) "x hours", "x days", "x weeks", "x months", "x quarters", "x years"
#' @param force_exec (boléen) Si TRUE alors le code est exécuté ($FORCE_EXEC par défaut)
#' @param prevent_exec (boléen) Si TRUE alors le code n'est pas exécuté ($PREVENT_EXEC par défaut), ce flag est prioritaire sur les autres, sauf si il n'y a pas de données en cache
#' @param metadata (boléen) Si TRUE (FALSE par défaut) la fonction retourne une liste avec des métadonnées et le champ data qui contient les données elles même
#' @param wd (character) si 'project' assure que le wd est le root du project, si 'file' (défaut) c'est le fichier sourcé qui est le wd, si "qmd", c'est le qmd qui appelle
#' @param exec_wd (character) NULL par défaut sauf usage particulier
#' @param quiet (boléen) pas de messages
#' @param nocache (boléen) n'enregistre pas le cache même si nécessaire
#' @param cache_rep (character) défaut .data sauf usage particulier

#'
#' @family source_data
#' @return data (list ou ce que le code retourne)
#' @export
#'

# note il reste un petit problème : si lapse change il faut nl'neregistrer
# si wd change, on ne reset pas le cache
# si les arguments changent, il faut aussi reseter le cache (les mettre dans le hash)
# il faut ajouter un always
# et la possibilité de tracker un fichier
source_data <- function(name,
                        args = list(),
                        hash = getOption("ofce.source_data.hash"),
                        track = list(),
                        lapse = getOption("ofce.source_data.lapse"),
                        force_exec = getOption("ofce.source_data.force_exec"),
                        prevent_exec = getOption("ofce.source_data.prevent_exec"),
                        metadata = getOption("ofce.source_data.metadata"),
                        wd = getOption("ofce.source_data.wd"),
                        exec_wd = NULL,
                        cache_rep = NULL,
                        root = NULL,
                        quiet = TRUE, nocache = FALSE) {

  # on trouve le fichier
  # si c'est project on utilise here, sinon, on utilise le wd courant
  name <- remove_ext(name)

  if(is.null(root)) {
    root <- try_find_root()
  }
  root <- fs::path_norm(root)
  if(!quiet)
    cli::cli_alert_info("root: {root}")
  uid <- digest::digest(root, algo = "crc32")
  if(!quiet)
    cli::cli_alert_info("uid: {uid}")
  if(is.null(cache_rep))
    root_cache_rep <- fs::path_join(c(root, ".data")) |> fs::path_norm()
  else
    root_cache_rep <- fs::path_abs(cache_rep)
  if(!quiet)
    cli::cli_alert_info("cache: {root_cache_rep}")


  src <- find_src(root, name)
  cwd <- root
  if(is.null(src)) {
    src <- try_find_src(root, name)
    if(length(src)==0) {
      if(!quiet)
        cli::cli_alert_warning("Le fichier n'existe pas en .r ou .R, vérifier le chemin")
      return(NULL)
    }
    if(length(src)>1) {
      if(!quiet)
        cli::cli_alert_warning("Plusieurs fichiers src sont possibles")
      l_src <- purrr::map(src, length)
      src <- src[[which.max(l_src)]]
    }
  }

  if(!quiet)
    cli::cli_alert_info("{.file {src}} comme source")

  if(length(check_return(src))==0) {
    cli::cli_alert_danger("Pas de return() détécté dans le fichier {.file {src}}")
  }

  if(length(check_return(src))>1) {
    if(!quiet)
      cli::cli_alert_info("Plusieurs return() dans le fichier {src}, attention !")
  }

  basename <- fs::path_file(name)
  relname <- fs::path_rel(src, root)
  reldirname <- fs::path_dir(relname)
  full_cache_rep <- fs::path_join(c(root_cache_rep, reldirname)) |>
    fs::path_norm()
  if(Sys.getenv("QUARTO_DOCUMENT_PATH") != "") {
    qmd_path <- Sys.getenv("QUARTO_DOCUMENT_PATH") |>
      fs::path_norm()
    qmd_file <- fs::path_join(c(qmd_path, knitr::current_input())) |>
      fs::path_ext_set("qmd") |>
      fs::path_norm()
  } else {
    qmd_path <- NULL
    qmd_file <- NULL
  }

  if(is.null(exec_wd)) {
    exec_wd <- getwd()
    if(wd=="project")
      exec_wd <- root
    if(wd=="file")
      exec_wd <- fs::path_dir(src)
    if(wd=="qmd") {
      if(!is.null(qmd_path)) {
        exec_wd <- qmd_path
      } else {
        cli::cli_alert_warning("Pas de document identifié, probablement, non excétué de quarto")
        exec_wd <- fs::path_dir(src)
      }
    }
  }

  if(is.null(force_exec)) force <- FALSE else if(force_exec=="TRUE") force <- TRUE else force <- FALSE
  if(is.null(prevent_exec)) prevent <- FALSE else if(prevent_exec=="TRUE") prevent <- TRUE else prevent <- FALSE

  src_hash <- tools::md5sum(src)
  arg_hash <- digest::digest(args, "crc32")
  track_hash <- 0

  if(length(track) >0) {
    track_files <- map(track, ~fs::path_join(c(cwd, .x)))
    ok_files <- map_lgl(track_files, fs::file_exists)
    if(any(ok_files))
      track_hash <- tools::md5sum(as.character(track_files[ok_files]))
    else {
      cli::cli_alert_warning("Les fichiers de track sont invalides, vérifiez les chemins")
    }
  }
  good_datas <- get_datas(basename, full_cache_rep)
  qmds <- purrr::map(good_datas, "qmd_file") |>
    purrr::list_flatten() |>
    purrr::discard(is.null) |>
    unlist() |>
    unique()
  new_qmds <- unique(c(qmds, qmd_file))

  if(force&!prevent) {
    our_data <- exec_source(src, exec_wd, args)
    if(our_data$ok) {
      our_data$lapse <- lapse
      our_data$src <- relname
      our_data$src_hash <- src_hash
      our_data$arg_hash <- arg_hash
      our_data$track_hash <- track_hash
      our_data$track <- track
      our_data$wd <- wd
      our_data$qmd_file <- new_qmds
      our_data$root <- root
      our_data$ok <- "exec"
      cache_data(our_data, cache_rep = full_cache_rep, name = basename, uid = uid)
      if(!quiet)
        cli::cli_alert_warning("Exécution du source")

      if(metadata) {
        return(our_data)
      } else {
        return(our_data$data)
      }
    } else {
      if(!quiet)
        cli::cli_alert_warning("le fichier {src} retourne une erreur, on cherche dans le cache")
    }
  }

  meme_null <- function(x, n, def = 0) ifelse(is.null(x[[n]]), def, x[[n]])

  if(hash&!prevent)
    good_datas <- good_datas |>
    purrr::keep(~meme_null(.x,"src_hash")==src_hash) |>
    purrr::keep(~meme_null(.x,"arg_hash", digest::digest(list()))==arg_hash) |>
    purrr::keep(~setequal(.x$track_hash, track_hash))

  if(lapse != "never"&!prevent) {
    alapse <- what_lapse(lapse)
    good_datas <- purrr::keep(good_datas, ~lubridate::now() - .x[["date"]] <= alapse)
  }

  if(length(good_datas)==0) {
    if(prevent) {
      if(!quiet)
        cli::cli_alert_warning("Pas de données en cache et pas d'exécution")
      return(NULL)
    }
    our_data <- exec_source(src, exec_wd, args)
    if(our_data$ok) {
      our_data$lapse <- lapse
      our_data$src <- relname
      our_data$src_hash <- src_hash
      our_data$qmd_file <- new_qmds
      our_data$arg_hash <- arg_hash
      our_data$track_hash <- track_hash
      our_data$track <- track
      our_data$root <- root
      our_data$wd <- wd
      our_data$ok <- "exec"

      cache_data(our_data, cache_rep = full_cache_rep, name = basename, uid = uid)
      if(!quiet)
        cli::cli_alert_warning("Exécution du source")

      if(metadata) {
        return(our_data)
      } else {
        return(our_data$data)
      }
    } else {
      if(!quiet)
        cli::cli_alert_warning("le fichier {src} retourne une erreur et rien dans le cache")
      return(NULL)
    }
  }

  dates <- purrr::map(good_datas, "date")
  good_good_data <- good_datas[[which.max(dates)]]

  if(!quiet)
    cli::cli_alert_warning("Données lues dans {.file {names(good_datas)[[which.max(dates)]]}}")

  ggd_lapse <- good_good_data$lapse %||% "never"
  ggd_wd <- good_good_data$wd %||% "file"
  ggd_qmds <- setequal(good_good_data$qmd_file, new_qmds)
  ggd_track <- setequal(good_good_data$track, track)
  if(ggd_lapse != lapse | ggd_wd != wd | !ggd_qmds | !ggd_track) {
    good_good_data$lapse <- lapse
    good_good_data$wd <- wd
    good_good_data$qmd_file <- new_qmds
    good_good_data$tack <- track
    cache_data(good_good_data, cache_rep = full_cache_rep, name = basename, uid = uid)
  }
  if(!quiet)
    cli::cli_alert_warning("Données en cache")

  good_good_data$ok <- "cache"
  if(metadata) {
    return(good_good_data)
  } else {
    return(good_good_data$data)
  }
}

# fonctions --------------------

check_return <- function(src) {
  src.txt <- readLines(src, warn=FALSE)
  ret <- stringr::str_extract(src.txt, "^return\\((.*)", group=1)
  purrr::keep(ret, ~!is.na(.x))
}

get_datas <- function(name, data_rep, ext = "qs") {
  pat <- stringr::str_c(name, "_([a-f0-9]){8}-([0-9]+)\\.", ext)
  files <- list()
  if(fs::dir_exists(data_rep))
    files <- fs::dir_ls(path = data_rep, regexp = pat, fail=FALSE)
  res <- purrr::map(files, ~ qs::qread(.x))
  names(res) <- files
  res
}

exec_source <- function(src, wd, args = list()) {
  safe_source <- purrr::safely(\(src, args) {
    args <- args
    base::source(src, local=TRUE)
  })
  current_wd <- getwd()
  setwd(wd)
  start <- Sys.time()
  res <- safe_source(src, args = args)
  timing <- as.numeric(Sys.time() - start)
  setwd(current_wd)
  if(!is.null(res$error)) {
    cli::cli_alert_warning(as.character(res$error))
    return(list(ok=FALSE, error = res$error))
  }
  list(
    data = res$result$value,
    timing = timing,
    date = lubridate::now(),
    size = lobstr::obj_size(res$result$value),
    exec_wd = wd,
    args = args,
    ok = TRUE
  )
}

cache_data <- function(data, cache_rep, name, uid="00000000", nocache = FALSE, ext = "qs") {
  pat <- stringr::str_c(name, "_([a-f0-9]){8}-([0-9]+)\\.", ext)
  files <- tibble::tibble()
  if(fs::dir_exists(cache_rep)) {
    files <- fs::dir_info(path = cache_rep, regexp = pat) |>
      mutate(uid = stringr::str_extract(path, pat, group=1),
             cc = stringr::str_extract(path, pat, group=2) |> as.numeric())
  }
  cc <- 1
  data_hash <- digest::digest(data$data)
  if(nrow(files)>0) {
    uids <- stringr::str_extract(files, pat, group = 1)
    ccs <- stringr::str_extract(files, pat, group = 2) |> as.numeric()
    last_fn <- files |> arrange(desc(modification_time)) |> slice(1) |> pull(path)
    last_data <- qs::qread(last_fn)
    last_data_hash <- last_data$data_hash
    if(!is.null(last_data_hash)) {
      if(data_hash == last_data_hash)
        cc <- max(files$cc)
    } else
      cc <- cc +1
  }
  fs::dir_create(cache_rep, recurse=TRUE)
  data$data_hash <- data_hash
  data$id <- stringr::str_c(uid, "-", cc)
  data$uid <- uid
  data$cc <- cc
  fn <- fs::path_join(c(cache_rep, stringr::str_c(name, "_", data$id))) |> fs::path_ext_set(ext)
  if(!nocache)
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

find_cache_rep <- function() {
  if(exists("session.source_data.cache_rep"))
    session.source_data.cache_rep
  else
    getOption("ofce.source_data.cache_rep")
}

unfreeze <- function(qmd_file, root, quiet=TRUE) {
  if(is.null(qmd_file))
    return(NULL)
  qmd_folder <- qmd_file |> fs::path_ext_remove()
  rel_path <- fs::path_rel(qmd_folder, root)
  freeze_path <- fs::path_join(c(root, "_freeze", rel_path))
  if(fs::dir_exists(freeze_path)) {
    if(!quiet)
      cli::cli_alert_info("Unfreezing {.file {freeze_path}}")
    fs::dir_delete(freeze_path)
  }
  return(NULL)
}

uncache <- function(qmd_file, root, quiet=TRUE) {
  if(is.null(qmd_file))
    return(NULL)
  qmd_bn <- qmd_file |> fs::path_file() |> fs::path_ext_remove()
  rel_path <- fs::path_dir(qmd_file) |> fs::path_rel(root)
  cache_path <- fs::path_join(c(root, rel_path, stringr::str_c(qmd_bn, "_cache")))
  files_path <- fs::path_join(c(root, rel_path, stringr::str_c(qmd_bn, "_files")))
  if(fs::dir_exists(cache_path)) {
    if(!quiet)
      cli::cli_alert_info("Uncaching {.file {cache_path}}")
    fs::dir_delete(cache_path)
  }
  if(fs::dir_exists(files_path)) {
    if(!quiet)
      cli::cli_alert_info("Unfiles {.file {files_path}}")
    fs::dir_delete(files_path)
  }
  return(NULL)
}

try_find_root <- function() {
  if(Sys.getenv("QUARTO_PROJECT_DIR") == "") {
    safe_find_root <- purrr::safely(rprojroot::find_root)
    root <- safe_find_root(
      rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
    if(is.null(root$error))
      return(root$result |> fs::path_norm())
    else {
      if(!quiet)
        cli::cli_alert_warning("{root$error}")
      return(NULL)
    }
  }
  return(Sys.getenv("QUARTO_PROJECT_DIR") |> fs::path_norm())
}

# source data status ---------------------------

#' Etat du cache de source_data
#'
#' Donne des informations sur le cache de source_data sous la forme d'un tibble
#'
#' @param data_rep le chemin vers le cache (défaut "_cache")
#'
#' @family source_data
#'
#' @return tibble
#' @export
#'

source_data_status <- function(cache_rep = NULL) {

  if(is.null(cache_rep)) {
    root <- try_find_root()
    cache_rep <- fs::path_join(c(root, ".data"))
  }

  caches <- list.files(path = cache_rep, pattern = "*.qs", recursive = TRUE, full.names = TRUE)

  purrr::map_dfr(caches, ~{
    dd <- qs::qread(.x)

    tibble::tibble(
      src = dd$src,
      id = dd$id,
      uid = dd$uid,
      index = dd$cc |> as.numeric(),
      date = dd$date,
      timing = dd$timing,
      size = dd$size,
      lapse = dd$lapse |> as.character(),
      wd = dd$wd,
      exec_wd = dd$exec_wd,
      args = list(dd$args),
      where = .x,
      root = dd$root,
      qmd_file = list(dd$qmd_file),
      src_hash = dd$hash,
      track_hash = list(dd$track_hash),
      track = list(dd$track),
      args_hash = dd$args_hash,
      data_hash = dd$data_hash) |>
      arrange(src, desc(date))
  }
  )
}

# vide cache -----------------

#' Vide le cache
#'
#' @param what (--) un tibble issu de source_data, éventuellement filtré
#' @param data_rep le répertoire de cache
#'
#' @family source_data
#'
#' @return la liste des fichiers supprimés
#' @export
#'
#'
clear_source_cache <- function(
    what = source_data_status(find_cache_rep()),
    cache_rep = find_cache_rep(),
    ext = "qs") {

  safe_find_root <- purrr::safely(rprojroot::find_root)
  root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)

  if(is.null(root$error))
    root <- root$result
  else {
    cli::cli_alert_warning("{root$error}")
    return(NULL)
  }
  root <- fs::path_norm(root)
  abs_cache_rep <- fs::path_join(c(root, cache_rep)) |> fs::path_norm()

  purrr::pmap_chr(what, function(src, id, ...) {
    fn <- fs::path_join(c(abs_cache_rep, src)) |>
      fs::path_ext_remove() |>
      stringr::str_c("_", id, ".", ext)
    fs::file_delete(fn)
    fn
  })
}

# refresh -----------------------

#' Exécute les sources sélectionnés
#'
#' @param what un tibble issu de source_data (tout par défaut)
#' @param cache_rep le répertoire de cache
#' @param force_exec (boléen) Si TRUE alors le code est exécuté ($FORCE_EXEC par défaut)
#' @param relative
#'
#' @family source_data
#'
#' @return un tibble de status
#' @export
#'
source_data_refresh <- function(
    cache_rep = NULL,
    what = source_data_status(cache_rep),
    force_exec = FALSE,
    hash = TRUE,
    unfreeze = TRUE,
    quiet = TRUE) {

  purrr::pwalk(what, function(src, wd, lapse, args, root, track, qmd_file,...) {
    exec_wd <- getwd()
    if(wd=="project")
      exec_wd <- root
    if(wd=="file")
      exec_wd <- fs::path_dir(src)
    if(wd=="qmd")
      exec_wd <- fs::path_dir(qmd_file[[1]])
    src_data <- source_data(name = src,
                            force_exec = force_exec,
                            hash = hash,
                            track = track,
                            args = args,
                            wd = wd,
                            lapse = lapse,
                            metadata = TRUE,
                            quiet = quiet,
                            root = root)
    if(unfreeze)
      purrr::walk(src_data$qmd_file, ~{
        if(src_data$ok == "exec") {
          unfreeze(.x, src_data$root, quiet = quiet)
          uncache(.x, src_data$root, quiet = quiet)
        }
      })

    source_data_status(cache_rep)
  }
  )
}

# set cache rep ----------------------

#' répertoire de cache persistant
#'
#' @param cache_rep (character) le répertoire
#'
#' @family source_data
#'
#' @return rien
#' @export
#'
set_cache_rep <- function(cache_rep = find_cache_rep()) {
  session.source_data.cache_rep <<- cache_rep
}
