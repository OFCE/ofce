#' fabricateur de source pour les graphiques
#'
#' permet de construire un caption facilement avec un wrapping
#' on commence par la source, une note, et une lecture
#'
#' @param source texte de la source (sans source)
#' @param note texte de la note
#' @param lecture texte de la note de lecture
#' @param dpt dernier point connu
#' @param dptf fréquence du dernier point connu (day, month, quarter, year)
#' @param wrap largeur du texte
#' @param ofce (bool) si TRUE ajoute calculs OFCE
#' @param lang langue des textes
#' @return ggplot2 caption (ggplot() + ofce_caption())
#' @export

ofce_caption <- function(source = "Calculs OFCE",
                         note = NULL,
                         lecture = NULL,
                         dpt = NULL,
                         dptf = "monthly",
                         wrap = 120, lang = "fr", ofce=TRUE) {
  if(lang=="fr") {
    lec <- "*Lecture* : "
    src <- "*Source* : "
    not <- "*Note* : "
    ofc <- "Calculs OFCE"
    der <- "*Dernier point* "}
  else {
    lec <- "*Reading*: "
    src <- "*Source*: "
    not <- "*Note*: "
    ofc <- "Computation by OFCE"
    der <- "*Last point* "
  }
  caption <- ""

  if(!is.null(lecture)) {
    caption <- str_c(lec, lecture)  |>
      str_wrap(width = wrap) |>
      str_replace_all("\\n", "<br>")
  }

  if(!is.null(note)) {
    if(length(caption>0))
      caption <- caption |> str_c("<br>")
    addcaption <- str_c(not, note) |>
      str_wrap(width = wrap, exdent = 2) |>
      str_replace_all("\\n", "<br>")
    caption <- caption |>
      str_c(addcaption)
  }
  if(!is.null(source)) {
    if(length(caption>0))
      caption <- caption |> str_c("<br>")
    if(str_detect(source, ",|;"))
      src <- src |> str_replace("ce", "ces")
    addcaption <- str_c(src, source) |>
      str_wrap(width = wrap) |>
      str_replace_all("\\n", "<br>")
    caption <- caption |>
      str_c(addcaption)
  }

  if(ofce) {
    if(length(caption>0))
      caption <- caption |> str_c("<br>")
    caption <- caption |> str_c(ofc)
  }
  if(!is.null(dernierpt)) {
    if(ofce)
      caption <- caption |> str_c(", ", der, dernier_point(dernierpt, dptf, lang)) else
        caption <- caption |> str_c("<br>", der, dernier_point(dernierpt, dptf, lang))
  }

  labs(caption = caption)
}

#' fabricateur de dernier point pour les sources de graphiques
#'
#' @param date liste de date
#' @param freq soit day, month, quarter, year
#' @param lang langue de retour
#' @return chaine de charactères
#' @export

dernier_point <- function(date, freq = "month", lang = "fr") {
  date <- max(date)
  if(lang== "fr") {
    locale <- if(.Platform$OS.type=="windows")
      Sys.setlocale(locale = "fr_FR.utf8") else
        Sys.setlocale(locale = "fr_FR")
  } else {
    locale <- Sys.setlocale(locale = "en_UK")
  }

  if(freq == "day")
    return(str_c(lubridate::day(date),
                 lubridate::month(date, label = TRUE, abbr = false, locale = locale),
                 lubridate::year(date), sep = " "))

  if(freq == "month")
    return(str_c(lubridate::month(date, label = TRUE, abbr = false, locale = locale),
                 lubridate::year(date), sep = " "))

  if(freq == "quarter")
    return(str_c("T", lubridate::quarter(date), " ",
                 lubridate::year(date)))

  return(lubridate::year(date))
}
