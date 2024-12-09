# source_data ------------------------------

# source_data est un outil qui permet d'exécuter un code, d'en cacher le résultat dans un dossier spécial (_data) en gardant des métadonnées
# sauf modifications ou écart de temps (à configurer), les appels suivant au code ne sont pas exécutés mais le ficheir de data est relu
# quelques fonctions permettent de diagnostiquer le cache et de suivre les mises à jour.


#' source_data : exécute le code et cache les données
#'
#' Cette fonction s'utilise presque comme source et permet d'en accélérer l'exécution par le cache des données.
#'
#' Le fichier source est donné en entrée. Le chemin est relatif au projet, mais si il n'est pas trouvé dans le projet, il est cherché en partant de la racine.
#' Si le paramètre `src_in` est mis à `"file"`, alors le source est cherché à partir du qmd (ou du wd si il n'y pas encore de qmd) et les données sont stockées à ce niveau.
#' Ce cas correspond donc à des dossiers qui ne partagent pas de code (le blog de l'OFCE), alors que l'autre cas correspond à des codes pouvant être partagés (la prévision)
#'
#' Le code est exécuté (dans un environnement local) et le résultat est mis en cache. Il est important que le code se termine par un return(les_donnees).
#' Si return() n'est pas présent dans le code, il n'est pas exécuté et un message d'erreur est envoyé ("NULL" est retourné).
#' le code est exécuté avec un contrôle d'erreur, donc si il bloque, "NULL" est renvoyé, mais sans erreur ni arrêt.
#' les appels suivants seront plus rapides et sans erreur (sauf si l'erreur n'est pas corrigée).
#'
#' Une modification du code est détectée et déclenche l'éxécution automatiquement.
#'
#' Suivant le paramètre lapse on peut déclencher une exécution périodique.
#' Par exemple, pour ne pas rater une MAJ, on peut mettre `lapse = "1 day"` ou `"day"` et une fois par jour le code sera exécuté.
#' Cela permet d'éviter une exécution à chaque rendu, mais permet de vérifier fréquemment la MAJ.
#' On peut spécifier l'intervalle en heures (`hours`), en jours (`days`), en semaines (`weeks`), en mois (`months`) ou en trimestres (`quarters`).
#'
#' On peut bloquer l'exécution en renseignant la variable d'environnement `PREVENT_EXEC` par `Sys.setenv(PREVENT_EXEC = "TRUE")` ou dans `.Renviron`.
#' Ce blocage est prioritaire sur tous les autres critères (sauf en cas d'absence de cache ou l'exécution est essayée).
#'
#' Des métadonnées peuvent être renvoyées (paramètre `metadata`) avec la date de la dernière exécution (`$date`), le temps d'exécution (`$timing`),
#' la taille des données (`$size`), le chemin de la source (`$where`), le hash du source (`$hash_src`) et bien sûr les données (`$data`).
#' Cela peut servir pour renseigner un graphique.
#'
#' Les valeurs par défaut peuvent être modifiées simplement par `options(ofce.source_data.hash = FALSE)` par exemple et persistent pour une session.
#' Typiquement cela peut être mis dans rinit.r (et donc être exécuté par `ofce::init_qmd()`) et cela sera l'option par défaut du projet.
#'
#' Le paramètre `wd` perment de spécifier le répertoire d'exécution du source.
#' Si il est mis à `"file"`, les appels à l'intérieur du code source, comme par exemple un save ou un load seront compris dans le répertoire où se trouve le fichier source.
#' L'intérêt est que le code peut avoir des éléments persistants, locaux
#' L'alternative est d'utiliser `wd="project"` auquel cas, le répertoire d'exécution sera independant de l'endroit où est appelé le code source.
#' Les éléments persistants peuvent alors être dasn un endroit commun et le code peut appeler des éléments persistants d'autres codes sources.
#' En le mettant à `qmd`l'exécution part du fichier qmd, ce qui est le comportement standard de `quarto`.
#' Toute autre valeur pour wd laisse le working directory inchnagé et donc dépendant du contexte d'exécution. Pour ceux qui aiment l'incertitude.
#'
#' En donnant des fichers à suivre par `track`, on peut déclencher l'exécution du source lorsque ces fichiers sont modifiés, c'est utile pour des fichiers sources sous excel (ou csv).
#'
#' `unfreeze` permet d'invalider le cache de quarto et de déclencher l'exécution du qmd pour mettre à jour la publication (et pas seulement les données en cache).
#'
#' @param path (character) le chemin vers le code à exécuter (sans extension .r ou .R ou avec au choix), ce chemin doit être relatif au projet (voir détails)
#' @param args (list) une liste d'arguments que l'on peut utliser dans source (args$xxx)
#' @param hash (boléen) Si TRUE (défaut) un changement dans le code déclenche son exécution
#' @param track (list) une liste de fichiers (suivant la même règle que src pour les trouver) qui déclenchent l'exécution.
#' @param lapse (character) peut être "never" (défaut) "x hours", "x days", "x weeks", "x months", "x quarters", "x years"
#' @param force_exec (boléen) Si TRUE alors le code est exécuté ($FORCE_EXEC par défaut)
#' @param prevent_exec (boléen) Si TRUE alors le code n'est pas exécuté ($PREVENT_EXEC par défaut), ce flag est prioritaire sur les autres, sauf si il n'y a pas de données en cache
#' @param metadata (boléen) Si TRUE (FALSE par défaut) la fonction retourne une liste avec des métadonnées et le champ data qui contient les données elles même
#' @param wd (character) si 'project' assure que le wd est le root du project, si 'file' (défaut) c'est le fichier sourcé qui est le wd, si "qmd", c'est le qmd qui appelle
#' @param scr_in (character) si "project" cherche le source dans le projet puis les sous dossiers, si "file" cherche dans le dossier du qmd (ou le wd). Dans ce cas, les données sont stockées dans le dossier en question.
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
source_data <- function(path,
                        args = list(),
                        hash = getOption("ofce.source_data.hash"),
                        track = list(),
                        lapse = getOption("ofce.source_data.lapse"),
                        force_exec = getOption("ofce.source_data.force_exec"),
                        prevent_exec = getOption("ofce.source_data.prevent_exec"),
                        metadata = getOption("ofce.source_data.metadata"),
                        wd = getOption("ofce.source_data.wd"),
                        src_in = getOption("ofce.source_data.src_in"),
                        exec_wd = NULL,
                        cache_rep = NULL,
                        root = NULL,
                        quiet = TRUE, nocache = FALSE) {

  if(is.null(args))
    args <- list()

  if(is.null(track))
    track <- list()

  # on trouve le fichier
  name <- remove_ext(path)
  paths <- find_project_root()
  root <- try_find_root(root, src_in)

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
  qmd_path <- paths$doc_path
  if(Sys.getenv("QUARTO_DOCUMENT_PATH") != "") {
    qmd_file <- fs::path_join(c(qmd_path, knitr::current_input())) |>
      fs::path_ext_set("qmd") |>
      fs::path_norm()
  } else {
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

  src_hash <- hash_file(src)
  arg_hash <- digest::digest(args, "crc32")
  track_hash <- 0

  if(length(track) > 0) {
    track_files <- purrr::map(track, ~fs::path_join(c(root, .x)))
    ok_files <- purrr::map_lgl(track_files, fs::file_exists)
    if(any(ok_files))
      track_hash <- hash_file(as.character(track_files[ok_files]))
    else {
      cli::cli_alert_warning("Les fichiers de track sont invalides, vérifiez les chemins")
    }
  }
  meta_datas <- get_mdatas(basename, full_cache_rep)
  qmds <- purrr::map(meta_datas, "qmd_file") |>
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
      our_data$src_in <- src_in
      our_data$ok <- "exec"
      our_data$root <- fs::path_rel(root, paths$project_path)

      our_data <- cache_data(our_data, cache_rep = full_cache_rep, root = root, name = basename, uid = uid)
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

  meta_datas <- valid_metas(meta_datas, src_hash = src_hash, arg_hash = arg_hash,
                            track_hash = track_hash, lapse = lapse, root = root)


  good_datas <- meta_datas |> purrr::keep(~.x$valid)
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
      our_data$wd <- wd
      our_data$src_in <- src_in
      our_data$ok <- "exec"
      our_data$root <- fs::path_rel(root, paths$project_path)

      our_data <- cache_data(our_data, cache_rep = full_cache_rep, name = basename, uid = uid, root = root)
      if(!quiet)
        cli::cli_alert_warning("Exécution du source")

      if(metadata) {
        return(our_data)
      } else {
        return(our_data$data)
      }
    } else {
      return(NULL)
    }
  }

  dates <- purrr::map(good_datas, "date") |>
    unlist() |>
    lubridate::as_datetime()
  mdd <- which.max(dates)
  good_good_data <- good_datas[[mdd]]
  fnm <- names(good_datas)[[mdd]]
  fnd <- fs::path_join(c(root, good_good_data$data_file))

  if(!quiet)
    cli::cli_alert_warning("Métadonnées lues dans {.file {fnd}}")

  ggd_lapse <- good_good_data$lapse %||% "never"
  ggd_wd <- good_good_data$wd %||% "file"
  ggd_qmds <- setequal(good_good_data$qmd_file, new_qmds)
  ggd_track <- setequal(good_good_data$track, track)
  ggd_src_in <- src_in == good_good_data$src_in %||% "project"

  if(ggd_lapse != lapse | ggd_wd != wd | !ggd_qmds | !ggd_track | !ggd_src_in) {
    newmdata <- good_good_data
    newmdata$file <- NULL
    newmdata$lapse <- lapse
    newmdata$wd <- wd
    newmdata$qmd_file <- new_qmds
    newmdata$track <- track
    newmdata$src_in <- src_in
    jsonlite::write_json(newmdata, path = fnm)
  }
  if(!quiet)
    cli::cli_alert_warning("Données en cache")

  good_good_data$ok <- "cache"
  good_good_data$data <- qs::qread(fnd)
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

valid_meta4meta <- function(meta, root) {
  src_hash <- hash_file(fs::path_join(c(root, meta$src)))
  track_hash <- 0

  if(length(meta$track) >0) {
    track_files <- purrr::map(meta$track, ~fs::path_join(c(root, .x)))
    ok_files <- purrr::map_lgl(track_files, fs::file_exists)
    if(any(ok_files))
      track_hash <- hash_file(as.character(track_files[ok_files]))
    else {
      cli::cli_alert_warning("Les fichiers de track sont invalides, vérifiez les chemins")
    }
  }

  meme_null <- function(x, n, def = 0) ifelse(is.null(x[[n]]), def, x[[n]])
  meta$valid_src <- meme_null(meta,"src_hash")==src_hash
  meta$valid_track <- setequal(meta$track_hash, track_hash)
  meta$data_exists <- fs::file_exists(fs::path_join(c(root, meta$data_file)))
  if(meta$lapse != "never") {
    alapse <- what_lapse(meta$lapse)
    meta$valid_lapse <- lubridate::now() - lubridate::as_datetime(meta[["date"]]) <= alapse
  } else
    meta$valid_lapse <- TRUE
  meta$valid <- meta$valid_src & meta$valid_track & meta$valid_lapse & meta$data_exists
  return(meta)
}

valid_metas <- function(metas, src_hash, arg_hash, track_hash, lapse, root) {

  meme_null <- function(x, n, def = 0) ifelse(is.null(x[[n]]), def, x[[n]])

  metas <- map(metas, ~{
    .x$valid_src <- meme_null(.x,"src_hash")==src_hash
    .x$valid_arg <- meme_null(.x,"arg_hash", digest::digest(list()))==arg_hash
    .x$valid_track <- setequal(.x$track_hash, track_hash)
    .x$data_exists <- fs::file_exists(fs::path_join(c(root, .x$data_file)))
    if(lapse != "never") {
      alapse <- what_lapse(lapse)
      .x$valid_lapse <- lubridate::now() - lubridate::as_datetime(.x[["date"]]) <= alapse
    } else
      .x$valid_lapse <- TRUE
    .x$valid <- .x$valid_src & .x$valid_arg & .x$valid_track & .x$valid_lapse & .x$data_exists
    .x
  })
}

hash_file <- function(path) {
  purrr::map_chr(path, ~ {
    if(fs::file_exists(.x)) {
      if(fs::path_ext(.x) %in% c("R", "r", "txt", "csv"))
        digest::digest(readLines(.x, warn = FALSE), algo = "sha1")
      else
        digest::digest(.x, algo = "sha1", file = TRUE)
    }
    else
      glue::glue("no_{.x}_{round(100000000*runif(1))}")
  })
}

get_datas <- function(name, data_rep) {
  m <- get_mdatas(name, data_rep)
  dn <- names(m) |> stringr::str_replace(glue::glue(".json"), glue::glue(".qs")) |> set_names(names(m))
  d <- purrr::map(dn, ~qs::qread(.x))
  purrr::map(rlang::set_names(names(m)), ~{
    l <- m[[.x]]
    l$data <- d[[.x]]
    l})
}

get_mdatas <- function(name, data_rep) {
  pat <- stringr::str_c(name, "_([a-f0-9]){8}-([0-9]+).json")
  files <- list()
  if(fs::dir_exists(data_rep))
    files <- fs::dir_ls(path = data_rep, regexp = pat, fail=FALSE)
  purrr::map(files, read_mdata)
}

read_mdata <- function(path) {
  l <- jsonlite::read_json(path) |>
    map( ~if(length(.x)>1) list_flatten(.x) else unlist(.x) )
  l$file <- path
  l
}

get_ddatas <- function(name, data_rep) {
  pat <- stringr::str_c(name, "_([a-f0-9]){8}-([0-9]+).qs")
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
    res <- suppressMessages(
      suppressWarnings( base::source(src, local=TRUE) ) )
    res
  })
  current_wd <- getwd()
  setwd(wd)
  start <- Sys.time()
  res <- safe_source(src, args = args)
  timing <- as.numeric(Sys.time() - start)
  setwd(current_wd)
  if(!is.null(res$error)) {
    cli::cli_div(class = "err", theme = list(.err = list(color = "red")))
    cli::cli_alert_warning("Erreur dans {src}\n\n
                           {.err {res$error}}")
    return(list(ok=FALSE, error = res$error))
  }
  list(
    data = res$result$value,
    timing = timing,
    date = lubridate::now(),
    size = lobstr::obj_size(res$result$value) |> as.numeric(),
    args = args,
    ok = TRUE
  )
}

cache_data <- function(data, cache_rep, name, root, uid="00000000", nocache = FALSE) {
  pat <- stringr::str_c(name, "_([a-f0-9]{8})-([0-9]+)\\.json")
  files <- tibble::tibble()
  if(fs::dir_exists(cache_rep)) {
    files <- fs::dir_info(path = cache_rep, regexp = pat) |>
      mutate(uid = stringr::str_extract(path, pat, group=1),
             cc = stringr::str_extract(path, pat, group=2) |> as.numeric())
  }
  cc <- 1
  exists <- FALSE
  data_hash <- digest::digest(data$data)
  if(nrow(files)>0) {
    uids <- files$uid
    ccs <- files$cc
    last_fn <- files |> arrange(desc(modification_time)) |> slice(1)
    last_m_data <- read_mdata(last_fn$path)
    last_data_hash <- last_m_data$data_hash
    if(!is.null(last_data_hash)) {
      if(data_hash == last_data_hash) {
        cc <- last_fn$cc
        exists <- TRUE
      }
      else
        cc <- max(files$cc, na.rm = TRUE) + 1
    } else
      cc <- max(files$cc, na.rm = TRUE) + 1
  }
  if(!fs::dir_exists(cache_rep))
    fs::dir_create(cache_rep, recurse=TRUE)
  data$data_hash <- data_hash
  data$id <- stringr::str_c(uid, "-", cc)
  data$uid <- uid
  data$cc <- cc
  fnm <- fs::path_join(c(cache_rep, stringr::str_c(name, "_", data$id))) |> fs::path_ext_set("json")
  if(!nocache) {
    if(!exists) {
      fnd <- fs::path_join(c(cache_rep, stringr::str_c(name, "_", data$id))) |> fs::path_ext_set("qs")
      les_datas <- data$data
      qs::qsave(les_datas, file = fnd)
    } else
      fnd <- last_m_data$data_file
    les_metas <- data
    les_metas$data <- NULL
    les_metas$data_file <- fs::path_rel(fnd, root)
    les_metas$file <- NULL
    jsonlite::write_json(les_metas, path = fnm)
  }
  return(data)
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
    unlink(freeze_path, recursive=TRUE, force=TRUE)
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
    unlink(cache_path, recursive=TRUE, force=TRUE)
  }
  if(fs::dir_exists(files_path)) {
    if(!quiet)
      cli::cli_alert_info("Unfiles {.file {files_path}}")
    unlink(files_path, recursive=TRUE, force=TRUE)
  }
  return(NULL)
}

try_find_root <- function(root=NULL, src_in = getOption("ofce.source_data.src_in")) {
  if(!is.null(root))
    return(root)
  if(src_in == "wd")
    return( getwd() |> fs::path_abs() |> fs::path_norm() )
  if(src_in == "file") {
    if(Sys.getenv("QUARTO_DOCUMENT_PATH") != "")
      return(Sys.getenv("QUARTO_DOCUMENT_PATH") |> fs::path_abs() |> fs::path_norm() )
    return( getwd() |> fs::path_abs() |> fs::path_norm() )
  }

  if(src_in == "project") {
    if(Sys.getenv("QUARTO_PROJECT_DIR") == "") {
      safe_find_root <- purrr::safely(rprojroot::find_root)
      root <- safe_find_root(
        rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
      if(is.null(root$error))
        return(root$result |> fs::path_abs() |> fs::path_norm())
      else {
        if(!quiet)
          cli::cli_alert_warning("{root$error}")
        return(NULL)
      }
    }
    return(Sys.getenv("QUARTO_PROJECT_DIR") |> fs::path_abs() |> fs::path_norm())
  }
  root <- NULL
}


find_project_root <- function(project_path = NULL, doc_path = NULL) {
  if(is.null(doc_path)) {
    if(Sys.getenv("QUARTO_DOCUMENT_PATH") != "")
      doc_path <- Sys.getenv("QUARTO_DOCUMENT_PATH") |> fs::path_abs() |> fs::path_norm()
    else
      doc_path <- getwd() |> fs::path_abs() |> fs::path_norm()
  }
  if(is.null(project_path)) {
    project_path <- Sys.getenv("QUARTO_PROJECT_DIR")
    if(project_path == "") {
      safe_find_root <- purrr::safely(rprojroot::find_root)
      project_path <- safe_find_root(rprojroot::is_quarto_project)
      if(!is.null(project_path$error))
        project_path <- safe_find_root(rprojroot::is_rstudio_project)
      if(!is.null(project_path$error))
        project_path$result <- getwd()
      project_path <- project_path$result
    }
  }
  project_path <- project_path |> fs::path_norm() |> fs::path_abs()
  doc_path <- doc_path |> fs::path_norm() |> fs::path_abs() |> fs::path_rel(project_path)
  return(list(project_path = project_path, doc_path = doc_path))
}

# source data status ---------------------------

#' Etat du cache de source_data
#'
#' Donne des informations sur le cache de source_data sous la forme d'un tibble
#'
#' @param data_rep le chemin vers le cache (défaut "_cache")
#' @param src_in est ce que les données sont avec les qmd ?
#' @param root force le root -- à ne pas utiliser sauf expert
#' @family source_data
#'
#' @return tibble
#' @export
#'

source_data_status <- function(cache_rep = NULL, quiet = TRUE, root = NULL, src_in = getOption("ofce.source_data.src_in") %||% "project" ) {
  root <- try_find_root(root, src_in)
  caches <- list()
  if(src_in == "project") {
    if(is.null(cache_rep))
      cache_rep <- fs::path_join(c(root, ".data"))

    if(!quiet)
      cli::cli_alert_info("répertoire cache {.file {cache_rep}}")

    if(fs::dir_exists(cache_rep))
      caches <- fs::dir_ls(path = cache_rep, glob = "*.json", recurse = TRUE)

    if(length(caches)>0)
      caches <- rlang::set_names(list(caches), root)
  }

  if(src_in %in% c("wd","file")) {
    qmds <- fs::dir_ls(root, glob = "*.qmd", recurse = TRUE)
    qmds_folders <- unique(qmds |> fs::path_dir())
    caches <- list()

    folders <- qmds_folders |>
      purrr::discard(~stringr::str_detect(.x, "^_|/_")) |>
      purrr::keep(~fs::dir_exists(fs::path_join(c(.x, ".data"))))
    folders <- rlang::set_names(folders)

    if(length(folders)>0)
      caches <- purrr::imap(
        folders,
        ~fs::dir_ls(path = fs::path_join(c(.x, ".data")), glob = "*.json", recurse = TRUE))
  }

  if(length(caches)>0) {
    cached <- purrr::map_dfr(names(caches), \(root) {
      purrr::map_dfr(caches[[root]], ~{

        dd <- jsonlite::read_json(.x) |>
          purrr::map( ~if(length(.x)>1) purrr::list_flatten(.x) else unlist(.x))
        valid <- valid_meta4meta(dd, root = root)

        tibble::tibble(
          valid = valid$valid,
          src = dd$src,
          id = dd$id,
          uid = dd$uid,
          index = dd$cc |> as.numeric(),
          date = lubridate::as_datetime(dd$date),
          timing = dd$timing,
          size = dd$size,
          lapse = dd$lapse |> as.character(),
          wd = dd$wd,
          args = list(dd$args),
          where = .x,
          qmd_file = list(dd$qmd_file),
          src_in = dd$src_in,
          data_file = dd$data_file,
          root =  dd$root %||% ".",
          src_hash = dd$hash,
          track_hash = list(dd$track_hash),
          track = list(dd$track),
          args_hash = dd$args_hash,
          data_hash = dd$data_hash)
      })
    }) |>
      dplyr::arrange(src, dplyr::desc(date))
    return(cached)
  } else {
    if(!quiet)
      cli::cli_alert_danger("Pas de cache trouvé")
    return(tibble::tibble())
  }
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
    what = source_data_status(root=root),
    cache_rep = NULL,
    root = NULL) {

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
      stringr::str_c("_", id)
    fs::file_delete(fn |> fs::path_ext_set("json"))
    fs::file_delete(fn |> fs::path_ext_set("qs"))
    fn
  })
}

# refresh -----------------------

#' Exécute les sources sélectionnés
#'
#' @param what un tibble issu de source_data (tout par défaut)
#' @param cache_rep le répertoire de cache si il n'est pas évident
#' @param force_exec (boléen) Si `TRUE` alors le code est exécuté (FALSE par défaut)
#' @param hash (boléen) (`TRUE` par défaut) vérifie les hashs
#' @param unfreeze (boléen) (`TRUE` par défaut) essaye de unfreezé et uncaché les qmd dont les données ont été rafraichies
#' @param quiet reste silencieux
#' @param init_qmd (`TRUE` par défaut) exécute `ofce::init_qmd()`
#' @param root (`NULL` par défaut) essaye de trouver le root à partir du point d'exécution ou utilise celui fournit
#'
#' @family source_data
#'
#' @return la liste des sources exécutés
#' @export
#'
source_data_refresh <- function(
    what = NULL,
    cache_rep = NULL,
    force_exec = FALSE,
    hash = TRUE,
    unfreeze = TRUE,
    quiet = TRUE,
    init_qmd = TRUE,
    root = NULL) {

  start <- Sys.time()
  sroot <- root
  if(is.null(what))
    what <- source_data_status(cache_rep = cache_rep, root = sroot, quiet = quiet)

  if(!force_exec)
    what <- what |>
    dplyr::group_by(src) |>
    dplyr::filter(!any(valid)) |>
    dplyr::ungroup()

  if(nrow(what)==0)
    return(list())

  # on en garde qu'un
  what <- what |>
    dplyr::group_by(src) |>
    dplyr::arrange(dplyr::desc(date)) |>
    dplyr::slice(1) |>
    dplyr::ungroup()

  if(nrow(what)==0)
    return(list())
  sroot <- find_project_root(project_path = sroot)$project_path

  if(init_qmd)
    ofce::init_qmd()

  res <- purrr::pmap(what, function(src, wd, lapse, args, root, track, qmd_file, src_in, ...) {

    exec_wd <- getwd()
    if(wd=="project")
      exec_wd <- sroot |> fs::path_norm()
    if(wd=="file")
      exec_wd <- fs::path_join(c(sroot, root, fs::path_dir(src))) |> fs::path_norm()
    if(wd=="qmd")
      exec_wd <- fs::path_join(c(sroot, fs::path_dir(qmd_file[[1]]))) |> fs::path_norm()

    if(src_in %in% c("file", "qmd"))
      root <- fs::path_join(c(sroot, root)) |> fs::path_norm()
    if(src_in %in% c("project"))
      root <- sroot
    src_data <- source_data(path = src,
                            force_exec = force_exec,
                            hash = hash,
                            track = track,
                            args = args,
                            wd = wd,
                            lapse = lapse,
                            metadata = TRUE,
                            quiet = quiet,
                            src_in = src_in,
                            root = root)

    if(unfreeze)
      purrr::walk(src_data$qmd_file, ~{
        if(src_data$ok == "exec") {
          unfreeze(.x, root, quiet = quiet)
          uncache(.x, root, quiet = quiet)
        }
      })
    list(src = src_data$src, ok = src_data$ok)
  }
  )

  cli::cli_alert_success("Refresh en {round(as.numeric(Sys.time()-start))} s.")

  res <- purrr::transpose(res)
  res$src[res$ok == "exec"] |> purrr::list_c()
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
