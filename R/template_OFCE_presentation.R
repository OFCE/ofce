#' template_OFCE_presentation
#'
#' iconv(charge un mod\\U+00E8le de document quarto pour une presentation RevealJS, "UTF-8", "UTF-8")
#'
#' @param file_name Nom du nouveau fichier qmd et du sous-dossier dans lequel il est cr\\U+00E9\\U+00E9
#'
#' @return Un message de confirmation
#' @export

template_OFCE_presentation <- function(file_name = NULL) {
  ext_name <- "presentation"

  if (is.null(file_name)) {
    stop("Veuillez donner un nom de fichier valide")
  }

  if(is.null(ext_name)) {ext_name = "WorkingPaper"}

  out_dir <- file_name

  # check for available extensions
  stopifnot("Le nom du template est incorrect, veuillez en choisir un parmi la liste suivante: c(\"quartotemplate\", \"WorkingPaper\", \"blog\", \"presentation\") " = ext_name %in% c("quartotemplate", "WorkingPaper", "blog", "presentation"))


  # various reading of key-value pairs for reporting
  ext_yml <- readLines(system.file(paste0("extdata/templates/",ext_name,"/_quarto.yml"),
                                   package = "ofce"))

  ext_ver <- gsub(
    x = ext_yml[grepl(x = ext_yml, pattern = "version:")],
    pattern = "version: ",
    replacement = ""
  )

  ## Checks
  # logic check to make sure extension files were moved
  # n_files <- length(dir(paste0("temp/",ext_name)))
  #
  # if(n_files >= 2){
  #   message(paste("Le template\"",ext_name,"\" version", ext_ver, "a ete installe dans le dossier ",out_dir))
  # } else {
  #   message("C'est genant... les  du modele n'ont pas ete chargees correctement")
  # }
  #
  if(!file.exists(ext_name)) dir.create(ext_name)

  message(paste0("Le dossier `",ext_name,"' a \\U+00E9t\\U+00E9 cr\\U+00E9e \\U+00E0 la racine du projet"))

  # Unzip dans le dossier parent les diff\\U+00E9rents fichiers associ\\U+00E9 au document quarto
  file.copy(
    from = system.file(file.path("extdata","templates", ext_name), package = "ofce"),
    to = getwd(),
    overwrite = TRUE,
    recursive = TRUE,
    copy.mode = TRUE
  )

  #create new qmd report based on skeleton
  readLines(paste0(ext_name,"/template.qmd")) |>
    writeLines(text = _,
               con = paste0(ext_name,"/",file_name, ".qmd", collapse = ""))

  unlink(paste0(ext_name,"/template.qmd"))
  # open the new file in the editor
  file.edit(paste0(ext_name,"/",file_name, ".qmd", collapse = ""))

}
