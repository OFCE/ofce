#' Enregistre un graphe en svg à la taille revue
#'
#' Enregistrement d'un graphique avec une taille par défaut de 18 cm de large et un ratio de 4/3
#' Les paramètres peuvent être facilement modifiés
#'
#' @param graph un objet graphique (grid, un ggplot plus communément, mais aussi un objet tmap)
#' @param file Le chemin vers le fichier résultat (string)
#' @param rep le répertoire dans lequel on met les graphiques
#' @param ratio le ratio entre largeur et hauteur
#' @param height la hauteur, si la hauteur est spécifiée la ratio est ignoré
#' @param width la largeur
#' @param units l'unité ("cm" par exemple)
#'
#' @return l'objet en entrée, invisible, enregistrfe un .jpg dan le répertoire avec le nom donné
#' @export
#'
graph2svg <- function(graph, file="", rep="svg", ratio = 4/3, height = width/ratio, width = 18, units="cm")
{
  if(file=="")
    file <- quo_name(enquo(graph))
  if(rep!="")
    dir.create(rep, recursive=TRUE, showWarnings = FALSE)
  fn <- make_filename(rlang::as_name(rlang::enquo(graph)), file, rep, parent.frame(), "svg")
  cl <- case_when(
    "gg" %in% class(graph) ~ "gg",
    "ggplot" %in% class(graph) ~ "gg",
    "tmap" %in% class(graph) ~ "tmap",
    TRUE ~ "err")
  switch(cl,
         gg =  ggplot2::ggsave(filename=fn, plot=graph, height = height, width = width, units=units),
         tmap = tmap::tmap_save(filename=fn, tm=graph, height = height, width = width, units=units),
         err = message("save not implemented"))
  invisible(graph)
}


#' Enregistre un graphe en jpg à la taille revue
#'
#' Enregistrement d'un graphique avec une taille par défaut de 18 cm de large et un ratio de 4/3
#' Les paramètres peuvent être facilement modifiés
#'
#' @param graph un objet graphique (grid, un ggplot plus communément mais aussi un objet tmap)
#' @param file Le chemin vers le fichier résultat (string)
#' @param rep le répertoire dans lequel on met les graphiques
#' @param ratio le ratio entre largeur et hauteur
#' @param height la hauteur, si la hauteur est spécifiée la ratio est ignoré
#' @param width la largeur
#' @param units l'unité ("cm" par exemple)
#'
#' @return l'objet en entrée, invisible, enregistrfe un .svg dan le répertoire avec le nom donné
#' @export
#'

graph2jpg <- function(graph, file="", rep="svg", ratio = 4/3, height = width/ratio, width = 18, units="cm")
{
  fn <- make_filename(rlang::as_name(rlang::enquo(graph)), file, rep="svg", ratio = 4/3, height = width/ratio, width = 18, units="cm")
  cl <- case_when(
    "gg" %in% class(graph) ~ "gg",
    "ggplot" %in% class(graph) ~ "gg",
    "tmap" %in% class(graph) ~ "tmap",
    TRUE ~ "err")
  switch(cl,
         gg = ggplot2::ggsave(filename=fn, plot=graph, height = height, width = width, units=units),
         tmap = tmap::tmap_save(filename=fn, tm=graph, height = height, width = width, units=units),
         err = message("save not implemented"))
  invisible(graph)
}

# fonction pour fabriquer le nom du fichier
make_filename <- function(x, file="", rep="", env, ext)
{
  if(file=="") {
    file <- x
  }
  else
    file <- glue::glue(file, .envir = env)
  if(rep!="")
    rep <- str_c(glue::glue(rep, .envir = env), "/")
  str_c(rep, file, ".", ext)
}

#' Utilisation mémoire par objet
#'
#' Permet de lister les plus gros objets en mémoire et de connaître leur empreinte
#'
#' @param envir l'environement dans lequel sont listé les objets. Mieux vaut ne pas le toucher si on ne sait pas à quoi ça sert.
#'
#' @return Une liste des objets en mémoire, invisible et affiche dan la console cette liste
#' @export
#'
#' @examples
#' showMemoryUse()
#'
showMemoryUse <- function(envir = parent.frame()) {
  objectList <- ls(envir = envir)

  oneKB <- 1024
  oneMB <- 1048576
  oneGB <- 1073741824

  memoryUse <- sapply(
    objectList,
    function(x) as.numeric(utils::object.size(eval(parse(text = x), envir = envir)))
  )

  memListing <- sapply(memoryUse, function(size) {
    if (size >= oneGB) {
      return(paste(round(size / oneGB, 2), "GB"))
    } else if (size >= oneMB) {
      return(paste(round(size / oneMB, 2), "MB"))
    } else if (size >= oneKB) {
      return(paste(round(size / oneKB, 2), "kB"))
    } else {
      return(paste(size, "bytes"))
    }
  })
  print(dim(memListing))
  memListing <- memListing[1:min(nrow(memListing), limit), ]

  print(memListing, row.names = FALSE)
  return(invisible(memListing))
}

#' Utilise le SI pour formatter les nombres en fonction des mulitples de 10^3
#'
#' @param number le nombre ou le vecteur à formatter (numérique)
#' @param rounding doit-on arrondir le chiffre ?
#' @param digits Combien de chiffres après la virgule
#' @param unit Arrondi soit à la "median" soit au "max"
#'
#' @return une chaine de caractère (character) formattée
#' @export
#' @seealso if2si2 (inverse la transformation)
#' @examples
#' f2si2(100000)
#'
  f2si2 <- function(number, rounding = TRUE, digits = 1, unit = "median") {
    lut <- c(
      1e-24, 1e-21, 1e-18, 1e-15, 1e-12, 1e-09, 1e-06,
      0.001, 1, 1000, 1e+06, 1e+09, 1e+12, 1e+15, 1e+18, 1e+21,
      1e+24
    )
    pre <- c(
      "y", "z", "a", "f", "p", "n", "u", "m", "", "k",
      "M", "G", "T", "P", "E", "Z", "Y"
    )
    ix <- ifelse(number!=0, findInterval(number, lut) , 9L)
    ix <- switch(unit,
                 median = median(ix, na.rm = TRUE),
                 max = max(ix, na.rm = TRUE),
                 multi = ix
    )
    if (rounding == TRUE)
      scaled_number <- round(number/lut[ix], digits)
    else
      scaled_number <- number/lut[ix]

    sistring <- paste0(scaled_number, pre[ix])
    sistring[scaled_number==0] <- "0"
    return(sistring)
  }

  f2si2df <- function(df, string = "", unit = "multi") {
    purrr::map(df, ~ stringr::str_c(f2si2(.x, unit = unit), string, sep = " "))
  }

  #' Transforme une chaîne formatté SI en nombre
  #'
  #' @param text le nombre ou le vecteur de nombres formattés à transformer
  #'
  #' @return un nombre
  #' @export
  #'
  #' @examples
  #' if2si2("100k")
  #'
  if2si2 <- function(text) {
    pre <- c(
      "y", "z", "a", "f", "p", "n", "u", "m", "1", "k",
      "M", "G", "T", "P", "E", "Z", "Y"
    )
    lut <- c(
      1e-24, 1e-21, 1e-18, 1e-15, 1e-12, 1e-09, 1e-06,
      0.001, 1, 1000, 1e+06, 1e+09, 1e+12, 1e+15, 1e+18, 1e+21,
      1e+24
    )
    names(lut) <- pre
    value <- stringr::str_extract(text, "[:digit:]+\\.?[:digit:]*") %>%
      as.numeric()
    unit <- stringr::str_extract(text, "(?<=[:digit:])[:alpha:]")
    unit[is.na(unit)] <- "1"
    value * lut[unit]
  }

#' Formatte un vecteur en produisant des éléments distincts
#'
#' Utilise f2si2 pour formatter un vecteur, et arrondi tant que les éléments formattés sont tous disctints.
#' Cela permet de les utiliser dans une échelle ou pour des noms.
#' Les nombres en entrée doivent être différents
#' @param number le nombre ou le vecteur de nombre
#' @param rounding doit-on arrondir ?
#' @param unit Arrondi soit à la "median" soit au "max"
#' @param digits_max le nombre maximal de chiffres après la virgule
#'
#' @return
#' @export
#'
#' @examples
#' uf2si2(c(1000,1100,2000,2100))
#'
  uf2si2 <- function(number, rounding = TRUE, unit = "median", digits_max=4) {
    n_number <- length(number)
    digits <- 1
    f2 <- f2si2(number, digits = digits, unit = unit)
    while (length(unique(f2)) < n_number & digits <= digits_max) {
      digits <- digits + 1
      f2 <- f2si2(number, digits = digits, unit = unit)
    }
    f2
  }
