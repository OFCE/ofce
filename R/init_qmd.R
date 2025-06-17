#' exécute le fichier rinit.R à la racine du projet, ou dans _utils,
#' ou en dessous.
#' s'il ne le trouve pas il utilise une version par défaut,
#' stockée dans le package et qui est copiée dans le répertoire du projet
#'
#' @param init nom du fichier à utiliser (`"rinit.r"` par défaut)
#' @param echo (défaut FALSE) passé aux chunks
#' @param message (défaut FALSE) passé aux chunks
#' @param warning (défaut FALSE) passé aux chunks
#'
#' @return NULL
#' @export
#'
init_qmd <- function(init = "rinit.r", echo = FALSE, message = FALSE, warning = FALSE, local = getOption("ofce.init_qmd.local")) {
  safe_find_root <- purrr::safely(rprojroot::find_root)
  root <- safe_find_root(rprojroot::is_quarto_project | rprojroot::is_r_package | rprojroot::is_rstudio_project)
  qmd_message <<- message
  qmd_warning <<- warning
  qmd_echo <<- echo
  spp_fn <- purrr::safely(~ fs::path_package("ofce", "rinit.r"))
  spp <- spp_fn()
  le_init <- NULL
  if(is.null(root$error)) {
    root <- root$result
    ofce.root <<- root

    pat <- stringr::str_c(init |> fs::path_ext_remove(), "\\.[rR]$")
    inits <- fs::dir_ls(root, all = TRUE, regexp = pat, recurse=TRUE)

    if(length(inits)>0) {
      if(local) {
        if(Sys.getenv("QUARTO_DOCUMENT_PATH") != "")
          doc_path <- Sys.getenv("QUARTO_DOCUMENT_PATH") |> fs::path_abs() |> fs::path_norm()
        else
          doc_path <- getwd()
        if(fs::file_exists(fs::path_join(c(doc_path, init))))
          le_init <- fs::path_join(c(doc_path, init))
        else
          local <- FALSE
      }
      if(!local) {
        le_init <- inits[which.min(purrr::map_dbl(inits, stringr::str_length))]
      }
      msg <- le_init
    }
    if(is.null(le_init)) {
      if(is.null(spp$error)) {
        if(fs::file_access(root, "write")) {
          le_init <- fs::file_copy(spp$result, root)
          msg <- "rinit copied from package"
        }
      }
    }
  }

  if(is.null(le_init) & is.null(spp$error)) {
    le_init <- spp$result
    msg <- "rinit from package"
  }

  if(!is.null(le_init)) {
    capture.output(
      source(le_init,
             echo = FALSE, verbose = FALSE, local = .GlobalEnv),
      file = nullfile(), type = c("output", "message") )
    return(invisible(msg))
  }

  cli::cli_alert_danger("{init} not found (nor in project, nor in package)")
  return(invisible(glue::glue("{init} not found (nor in project, nor in package)")))
}


#' déroule le chemin à partir du début du projet
#'
#' Lorsque le chemin commence par un "/", il est calculé à partir de la racine du projet
#'
#' @param path chemin
#' @param root racine (absolu), NULL par défaut
#'
#' @return chemin absolu (string)
#' @export
#'
pathify <- function(path, root = NULL) {
  if(!stringr::str_detect(path, "^/"))
    return(path)
  if(is.null(root)) {
    if(Sys.getenv("QUARTO_PROJECT_DIR") == "") {
      safe_find_root <- purrr::safely(rprojroot::find_root)
      root <- safe_find_root(
        rprojroot::is_quarto_project |
          rprojroot::is_r_package |
          rprojroot::is_rstudio_project)
      if(is.null(root$error))
        root <- root$result
    } else {
      root <- Sys.getenv("QUARTO_PROJECT_DIR")
    }
  }
  return(fs::path_join(c(root, path)))
}
