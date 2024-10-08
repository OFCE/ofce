#' fabricateur de source pour les graphiques
#'
#' permet de construire un caption facilement avec un wrapping
#' on commence par la source, une note, et une lecture
#'
#' @param source texte de la source (sans le mot source qui est rajouté)
#' @param note texte de la note (sans le mot note qui est rajouté)
#' @param lecture texte de la note de lecture (sans le mot lecture qui est rajouté)
#' @param dpt dernier point connu
#' @param dptf fréquence du dernier point connu (day, month, quarter, year)
#' @param wrap largeur du texte en charactères (120 charactères par défaut)
#' @param ofce (bool) si TRUE ajoute calculs OFCE à source, sinon rien, TRUE par défaut
#' @param lang langue des textes (fr par défaut)
#' @return ggplot2 caption (ggplot() + ofce_caption("INSEE"))
#' @export

ofce_caption <- function(source = NULL,
                         note = NULL,
                         lecture = NULL,
                         dpt = NULL,
                         dptf = "month",
                         wrap = 110, lang = "fr", ofce=TRUE) {
  if(lang=="fr") {
    lec <- "*Lecture* : "
    src <- "*Source* : "
    not <- "*Note* : "
    Ofc <- "Calculs OFCE"
    ofc <- ", calculs OFCE"
    der <- ", dernier point connu : "
    Der <- "*Dernier point connu* : "}
  else {
    lec <- "*Reading*: "
    src <- "*Source*: "
    not <- "*Note*: "
    ofc <- "OFCE' computation"
    Ofc <- ofc
    der <- ", last known point: "
    Der <- "*Last known point*: "
  }
  caption <- ""

  if(length(lecture)>0) {
    caption <- str_c(lec, lecture)  |>
      str_c(".") |>
      str_wrap(width = wrap) |>
      str_replace_all("\\n", "<br>")
  }

  if(length(note)>0) {
    if(length(caption>0))
      caption <- caption |> str_c("<br>")
    addcaption <- str_c(not, note) |>
      str_c(".") |>
      str_wrap(width = wrap) |>
      str_replace_all("\\n", "<br>")
    caption <- caption |>
      str_c(addcaption)
  }
  if(ofce) {
    if(length(source)==0)
      source <- Ofc else
        source <- str_c(source , ofc)
  }

  if(length(source)>0) {
    if(length(caption>0))
      caption <- caption |> str_c("<br>")
    if(str_detect(source, ",|;"))
      src <- src |> str_replace("ce", "ces")
    addcaption <- str_c(src, source) |>
      str_c(".") |>
      str_wrap(width = wrap) |>
      str_replace_all("\\n", "<br>")
    caption <- caption |>
      str_c(addcaption)
  }

  if(length(dpt)>0) {
    if(length(caption>0))
        caption <- caption |> str_c("<br>", Der, dernier_point(dpt, dptf, lang)) else
          caption <- caption |> str_c(Der, dernier_point(dpt, dptf, lang))
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
    locale <- if(.Platform$OS.type=="windows") "fr_FR.utf8" else "fr_FR"
  } else {
    locale <-  "en_UK"
  }

  if(freq == "day")
    return(str_c(lubridate::day(date),
                 lubridate::month(date, label = TRUE, abbr = FALSE, locale = locale),
                 lubridate::year(date), sep = " "))

  if(freq == "month")
    return(str_c(lubridate::month(date, label = TRUE, abbr = FALSE, locale = locale),
                 lubridate::year(date), sep = " "))

  if(freq == "quarter")
    return(str_c("T", lubridate::quarter(date), " ",
                 lubridate::year(date)))

  return(lubridate::year(date))
}
