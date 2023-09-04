#' Utilisation mémoire par objet
#'
#' Permet de lister les plus gros objets en mémoire et de connaître leur empreinte.
#'
#' copié de https://rdrr.io/github/zlfccnu/econophysics/ (merci!).
#'
#' @param envir l'environement dans lequel sont listé les objets. Mieux vaut ne pas le toucher si on ne sait pas à quoi ça sert.
#'
#' @return Une liste des objets en mémoire, invisible et affiche dans la console cette liste
#' @export
#'
#' @examples
#' showMemoryUse()
#'
showMemoryUse <- function(sort = "size", decreasing = TRUE, limit = 10, envir = parent.frame()) {
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

  memListing <- data.frame(objectName = names(memListing), memorySize = memListing, row.names = NULL)

  if (sort == "alphabetical") {
    memListing <- memListing[order(memListing$objectName, decreasing = decreasing), ]
  } else {
    memListing <- memListing[order(memoryUse, decreasing = decreasing), ]
  } # will run if sort not specified or "size"
  if(length(memListing)==0)
    return("No objects")
  memListing <- memListing[1:min(nrow(memListing), limit), ]

  print(memListing, row.names = FALSE)
  return(invisible(memListing))
}
