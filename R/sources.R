#' fabricateur de source pour les graphiques
#'
#' permet de construire un caption facilement avec un wrapping
#' on commence par la source, une note, et une lecture
#'
#' @param source texte de la source (sans source)
#' @param note texte de la note
#' @param lecture texte de la note de lecture
#' @param wrap largeur du texte
#' @param ofce (bool) si TRUE ajoute calculs OFCE
#' @param lang langue des textes
#' @return ggplot2 caption (ggplot() + ofce_caption())
#' @export
#'
#'

ofce_caption <- function(source = "Calculs OFCE",
                         note = NULL,
                         lecture = NULL, wrap = 120, lang = "fr", ofce=TRUE) {
  if(lang=="fr") {
    lec <- "*Lecture* : "
    src <- "*Source* : "
    not <- "*Note* : "
    ofc <- "Calculs OFCE"}
  else {
    lec <- "*Reading*: "
    src <- "*Source*: "
    not <- "*Note*: "
    ofc <- "Computation by OFCE"
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

  labs(caption = caption)
}
