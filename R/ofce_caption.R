#' fabricateur de source pour les graphiques
#'
#' permet de construire un caption facilement avec un wrapping
#' on commence par la source, une note, et une lecture
#'
#' @param source texte de la source (sans le mot source qui est rajouté)
#' @param note texte de la note (sans le mot note qui est rajouté)
#' @param lecture texte de la note de lecture (sans le mot lecture qui est rajouté)
#' @param champ texte du champ (sans le mot champ qui est rajouté)
#' @param code texte du code (sans le mot code qui est rajouté)
#' @param xlab inclu le label de l'axe des x (pour le traduire avec marquee)
#' @param ylab inclu le label de l'axe des y (pour le traduire avec marquee)
#' @param subtitle inclu le label du sous titre (pour le traduire avec marquee)
#' @param dpt dernier point connu
#' @param dptf fréquence du dernier point connu (day, month, quarter, year)
#' @param wrap largeur du texte en charactères (120 charactères par défaut, 0 ou NULL si on utilise marquee)
#' @param ofce (bool) si TRUE ajoute calculs OFCE à source, sinon rien, TRUE par défaut
#' @param author (bool) si TRUE ajoute calculs des auteurs à source, sinon rien, FALSE par défaut
#' @param srcplus (string) chaine (comme calculs OFCE) à ajouter à source (à la fin)
#' @param lang langue des textes (fr par défaut)
#' @param marquee_translate transforme ^x^ en {.sup x} et ~x~ en {.sub x}
#' @param glue applique glue avant toute chose
#'
#' @return ggplot2 caption (ggplot() + ofce_caption("INSEE"))
#' @export

ofce_caption <- function(
    source = NULL,
    note = NULL,
    lecture = NULL,
    champ = NULL,
    code = NULL,
    dpt = NULL,
    xlab = NULL,
    ylab = NULL,
    subtitle = NULL,
    dptf = "month",
    wrap = ifelse(getOption("ofce.marquee"), 0, getOption("ofce.caption.wrap")),
    lang = getOption("ofce.caption.lang"),
    ofce = getOption("ofce.caption.ofce"),
    author = getOption("ofce.caption.author"),
    srcplus = getOption("ofce.caption.srcplus"),
    marquee_translate = ifelse(getOption("ofce.marquee"), TRUE, getOption("ofce.caption.marquee_translate")),
    glue = getOption("ofce.caption.glue")) {

  if(is.null(author)){author = FALSE}
  env <- parent.frame()

  protect_marquee <- function(x) {
    x |>
      stringr::str_replace_all("\\{\\.(\\w+) ([^{}]+)\\}","{{.\\1 \\2}}")
  }

  transforme <- function(x) {
    if(glue)
      x <- x |>
        protect_marquee() |>
        glue::glue(.envir = env)

    if(marquee_translate)
      x <- x |>
        stringr::str_replace_all("\\^(.+)\\^","{.sup \\1}" ) |>
        stringr::str_replace_all("~(.+)~","{.sub \\1}" )
    return(x)
  }

  if(!is.null(source))
    source <- transforme(source)
  if(!is.null(champ))
    champ <- transforme(champ)
  if(!is.null(note))
    note <- transforme(note)
  if(!is.null(lecture))
    lecture <- transforme(lecture)
  if(!is.null(code))
    code <- transforme(code)

  if(!is.null(xlab))
    xlab <- transforme(xlab)

  if(!is.null(ylab))
    ylab <- transforme(ylab)

  if(!is.null(subtitle))
    subtitle <- transforme(subtitle)

  if(lang=="fr") {
    lec <- "*Lecture* : "
    src <- "*Source* : "
    chp <- "*Champ* : "
    not <- "*Note* : "
    if(is.null(srcplus)) {
      if(ofce) srcplus <- "calculs OFCE"
      if(author) srcplus <- "calculs des auteurs"
    }
    der <- ", dernier point connu : "
    Der <- "*Dernier point connu* : "
    cod <- "*Code* : "}
  else {
    lec <- "*Reading*: "
    src <- "*Source*: "
    chp <- "*Scope*: "
    not <- "*Note*: "
    if(is.null(srcplus)) {
      if(ofce) srcplus <- "OFCE's computations"
      if(author) srcplus <- "authors' computation"
    }
    der <- ", last known data point: "
    Der <- "*Last known data point*: "
    cod <- "*Code*: "
  }
  if(!is.null(srcplus)) {
    Srcp <- stringr::str_to_sentence(srcplus)
    srcp <- stringr::str_c(", ", srcplus)
  }
  caption <- ""

  if(!is.null(wrap)&!wrap==0) {
    wrapper <- function(x) stringr::str_wrap(x, width = wrap)
    linebr <- "<br>"
    liner <- function(x) stringr::str_replace_all(x, "\\n", linebr)
  } else {
    wrapper <- function(x) x
    linebr <- "  \n"
    liner <- function(x) x
  }
  if(length(champ)>0) {
    caption <- stringr::str_c(chp, champ)  |>
      check_point() |>
      wrapper() |>
      liner()
  }

  if(length(lecture)>0) {
    if(length(caption>0))
      caption <- caption |> stringr::str_c(linebr)
    addcaption <- stringr::str_c(lec, lecture)  |>
      check_point() |>
      wrapper() |>
      liner()
    caption <- caption |>
      stringr::str_c(addcaption)
  }

  if(length(note)>0) {
    if(length(caption>0))
      caption <- caption |> stringr::str_c(linebr)
    addcaption <- stringr::str_c(not, note) |>
      check_point() |>
      wrapper() |>
      liner()
    caption <- caption |>
      stringr::str_c(addcaption)
  }

  if(!is.null(srcplus)&ofce) {
    if(length(source)==0)
      source <- Srcp else
        source <- stringr::str_c(source , srcp)
  }

  if(length(code)>0) {
    if(length(caption>0))
      caption <- caption |> stringr::str_c(linebr)
    addcaption <- stringr::str_c(cod, code) |>
      wrapper() |>
      liner()
    caption <- caption |>
      stringr::str_c(addcaption)
  }

  if(length(source)>0) {
    if(length(caption>0))
      caption <- caption |> stringr::str_c(linebr)
    if(stringr::str_detect(source, ",|;"))
      src <- src |> stringr::str_replace("ce", "ces")
    addcaption <- stringr::str_c(src, source) |>
      check_point() |>
      wrapper() |>
      liner()
    caption <- caption |>
      stringr::str_c(addcaption)
  }

  if(length(dpt)>0) {
    if(length(caption>0))
      caption <- caption |>
        stringr::str_c(linebr) |>
        stringr::str_c(Der, dernier_point(dpt, dptf, lang)) |>
        check_point()
    else
      caption <- caption |>
        stringr::str_c(Der, dernier_point(dpt, dptf, lang))  |>
        check_point()
  }

  gplot <- list(ggplot2::labs(caption = caption))

  if(!is.null(xlab))
    gplot <- rlist::list.append(gplot, ggplot2::xlab(label = xlab) )
  if(!is.null(ylab))
    gplot <- rlist::list.append(gplot, ggplot2::ylab(label = ylab) )
  if(!is.null(subtitle))
    gplot <- rlist::list.append(gplot, ggplot2::labs(subtitle = subtitle ))

  return(gplot)
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
    locale <- if(.Platform$OS.type=="windows") "en_US.utf8" else "en_US"
  }

  if(freq == "day")
    return(stringr::str_c(lubridate::day(date),
                          lubridate::month(date, label = TRUE, abbr = FALSE, locale = locale),
                          lubridate::year(date), sep = " "))

  if(freq == "month")
    return(stringr::str_c(lubridate::month(date, label = TRUE, abbr = FALSE, locale = locale),
                          lubridate::year(date), sep = " "))

  if(freq == "quarter")
    return(stringr::str_c("T", lubridate::quarter(date), " ",
                          lubridate::year(date)))

  return(lubridate::year(date))
}


check_point <- function(s) {
  if(stringr::str_detect(s, "\\.$"))
    return(s)
  s |> stringr::str_c(".")
}
