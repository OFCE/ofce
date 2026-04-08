#' Créer une version blog d'un article EcoGaphe
#'
#' Transforme un fichier .qmd du dossier `relecture/` en une version blog
#' prête à publier. La fonction extrait le YAML et le corps du document,
#' adapte les métadonnées pour le format blog (ajout du numéro, de l'URL,
#' du thumbnail), puis copie l'ensemble des fichiers nécessaires (images,
#' données) dans un nouveau répertoire au niveau parent.
#'
#' Le fichier source doit se trouver dans `relecture/` et suivre la convention
#' de nommage `{year}_{issue}_*.qmd`. Le thumbnail correspondant doit être dans
#' `relecture/thumbnails/` et les données éventuelles dans `relecture/data/`.
#'
#' @param issue Numéro du GOW (entier). Sera complété avec un zéro si un seul
#'   chiffre (par ex. 9 devient "09").
#' @param year Année de publication (entier, par défaut 2026).
#'
#' @return NULL (appelée pour ses effets de bord : création de fichiers).
#'
#' @importFrom stringr str_count str_c str_extract str_remove_all str_replace_all
#' @importFrom dplyr mutate filter group_by ungroup lag
#' @importFrom purrr map
#'
#' @export
create_blog_version <- function(issue = 9 , year = 2026){

  new_issue <- ifelse(stringr::str_count(as.character(issue)) != 1 ,
                      as.character(issue),
                      stringr::str_c("0",as.character(issue)) )

  pat_files <- stringr::str_c(year, "_", new_issue)

  qmd <- list.files(path = "relecture" , pattern = pat_files)

  text_analysis <- data.frame( content = readLines(file.path("relecture",qmd)) ,
                               unit = 1
                               ) |>
    dplyr::mutate(line = cumsum(unit)) |>
    dplyr::group_by(content) |>
    dplyr::mutate(tag_double = cumsum(unit)) |>
    dplyr::ungroup() |>
    dplyr::mutate(yaml_end = ifelse(tag_double == 2 & grepl("^---",content) , 1 , 0 ),
                  yaml = ifelse(line > line[yaml_end == 1], 0 , 1 )
                  )

  yaml_analysis <- text_analysis |> dplyr::filter(yaml == 1)
  body_analysis <- text_analysis |> dplyr::filter(yaml == 0)

  ## Infos extraites
  date <- yaml_analysis$content[grepl("^date",yaml_analysis$content)] |>
    stringr::str_extract("\\d{4}-\\d{2}-\\d{2}") |>
    stringr::str_remove_all("-")

  initiales <- stringr::str_extract(qmd , "_([a-zA-Z0-9]+)\\.qmd$", group = 1) |> toupper()

  blog_qmd_file <- stringr::str_c(date,'_',initiales,'_gow')

  #  yaml nouvelle version blog
  edited_yaml <- c(
    stringr::str_c('nb: ',issue),
    '',
    'image: "image.png"',
    '',
    stringr::str_c('urlblog: "https://www.ofce.sciences-po.fr/blog2024/fr/',year,'/',blog_qmd_file,'"'),
    '',
    'gow: true',
    '---'
  )

  yaml_blog <- yaml_analysis |>
    dplyr::filter(grepl("^format:", content) == FALSE) |>
    dplyr::filter(grepl("gow-html", content) == FALSE) |>
    dplyr::filter(grepl("gow-typst", content) == FALSE) |>
    dplyr::filter(grepl("^image:", content) == FALSE) |>
    dplyr::filter(grepl("^urlblog:", content) == FALSE) |>
    dplyr::filter(grepl("^gow:", content) == FALSE) |>
    dplyr::filter(grepl("^nb:", content) == FALSE) |>
    dplyr::filter(grepl("^---",content) == FALSE) |>
    dplyr::mutate(
      content = stringr::str_replace_all(content,"^\\s*$",""),
      empty = ifelse(content == "",1,0),
      empty_test = empty * dplyr::lag(empty) ,
      empty_test = ifelse(is.na(empty_test),0,empty_test)
      ) |>
    dplyr::filter(empty_test != 1)

  newLines <- c("---",yaml_blog$content, edited_yaml,body_analysis$content)

  ## Find if there are pictures called in the script
  called_pics <- body_analysis |>
    dplyr::mutate(pic = grepl( "pictures/.+" , content)) |>
    dplyr::filter(pic == TRUE) |>
    dplyr::mutate(picture_files = stringr::str_extract(content, 'pictures/.+\\.[A-Za-z0-9]+'))

  npics <- sum(called_pics$pic)

  # Making new directory
  new_dir <- paste0("../", date, "_", initiales,"_gow" )

  dir.create(new_dir)
  dir.create(file.path(new_dir,"data"))

  ## add qmd
  cat(newLines, file = file.path(new_dir, stringr::str_c(blog_qmd_file,".qmd")) , sep = "\n" )

  ## add thumbnail
  thumbnail <- list.files(path = "relecture/thumbnails" , pattern = pat_files)
  ext_tn <- thumbnail |> stringr::str_extract("\\.[a-zA-Z]+$")

  file.copy(from = file.path("relecture/thumbnails",thumbnail),
            to = file.path(new_dir, stringr::str_c("image",ext_tn)) ,
            overwrite = TRUE )

  ## add picture files
  if(npics > 0){
    dir.create(file.path(new_dir,"pictures"))
    called_pics$picture_files |> purrr::map(~file.copy(
      from = file.path("relecture",.x) ,
      to = file.path(new_dir,.x)  ,
      overwrite = TRUE )
    )
  }

  ## add other data files
  data_files <- list.files(path = "relecture/data" , pattern = pat_files)

  if(length(data_files) > 0){
    data_files |> purrr::map(~file.copy(
      from = file.path("relecture/data",.x) ,
      to = file.path(new_dir,"data",.x)  ,
      overwrite = TRUE )
    )
  }
}
