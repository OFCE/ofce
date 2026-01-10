#' fabricateur de source
#'
#' permet de construire un caption facilement avec un wrapping, le passage dans glue et la traduction marquee (pour ggplot)
#'
#' on commence par la source, une note, et une lecture
#'
#' @param source texte de la source (sans le mot source qui est rajouté)
#' @param note texte de la note (sans le mot note qui est rajouté)
#' @param lecture texte de la note de lecture (sans le mot lecture qui est rajouté)
#' @param champ texte du champ (sans le mot champ qui est rajouté)
#' @param code texte du code (sans le mot code qui est rajouté)
#' @param xlab inclu le label de l'axe des x (pour le traduire avec marquee/glue)
#' @param ylab inclu le label de l'axe des y (pour le traduire avec marquee/glue)
#' @param subtitle inclu le label du sous titre (pour le traduire avec marquee/glue)
#' @param title inclu le titre (traduit aussi)
#' @param dpt dernier point connu
#' @param dptf fréquence du dernier point connu (day, month, quarter, year)
#' @param wrap largeur du texte en charactères (120 charactères par défaut, 0 ou NULL si on utilise marquee)
#' @param ofce (bool) si TRUE ajoute calculs OFCE à source, sinon rien, TRUE par défaut
#' @param author (bool) si TRUE ajoute calculs des auteurs à source, sinon rien, FALSE par défaut
#' @param srcplus (string) chaine (comme calculs OFCE) à ajouter à source (à la fin)
#' @param lang langue des textes (fr par défaut)
#' @param marquee_translate transforme ^x^ en {.sup x} et ~x~ en {.sub x}
#' @param glue applique glue avant toute chose
#' @param ... autres paramètres
#'
#' @return un object de type variable
#' @examples
#' library(ggplot2)
#' ggplot(mtcars)+geom_point(aes(x=hp, y=disp)) + theme_ofce(marquee=TRUE) + ofce_caption(source="INSEE")
#' head(mtcars) |> gt::gt() |> ofce_caption(source="INSEE")
#' @export
ofce_caption <- function(object=NULL, ...) {
  UseMethod("ofce_caption", object)
}

#' @export
ofce_caption.default <- function(object=NULL, ...) {
  dots <- list(...)

  if(hasName(dots, "source"))
    ofce_caption_ggplot(...)
  else
    if(!is.null(object))
      ofce_caption_ggplot(source = object, ...) else
        ofce_caption_ggplot(...)
}

#' @export
ofce_caption.gt_tbl <- function(object=NULL, ...) {
  object |> ofce_caption_gt(...)
}

#' fabricateur de source pour les graphiques
#'
#' permet de construire un caption facilement avec un wrapping, le passage dans glue et la traduction marquee (pour ggplot)
#'
#' on commence par la source, une note, et une lecture
#'
#' @param source texte de la source (sans le mot source qui est rajouté)
#' @param note texte de la note (sans le mot note qui est rajouté)
#' @param lecture texte de la note de lecture (sans le mot lecture qui est rajouté)
#' @param champ texte du champ (sans le mot champ qui est rajouté)
#' @param code texte du code (sans le mot code qui est rajouté)
#' @param xlab inclu le label de l'axe des x (pour le traduire avec marquee/glue)
#' @param ylab inclu le label de l'axe des y (pour le traduire avec marquee/glue)
#' @param subtitle inclu le label du sous titre (pour le traduire avec marquee/glue)
#' @param title inclu le titre (traduit aussi)
#' @param dpt dernier point connu
#' @param dptf fréquence du dernier point connu (day, month, quarter, year)
#' @param wrap largeur du texte en charactères (120 charactères par défaut, 0 ou NULL si on utilise marquee)
#' @param ofce (bool) si TRUE ajoute calculs OFCE à source, sinon rien, TRUE par défaut
#' @param author (bool) si TRUE ajoute calculs des auteurs à source, sinon rien, FALSE par défaut
#' @param srcplus (string) chaine (comme calculs OFCE) à ajouter à source (à la fin)
#' @param lang langue des textes (fr par défaut)
#' @param marquee_translate transforme ^x^ en {.sup x} et ~x~ en {.sub x}
#' @param glue applique glue avant toute chose
#' @param ... autres paramètres
#'
#' @return ggplot2 caption (ggplot() + ofce_caption("INSEE"))

ofce_caption_ggplot <- function(
    source = "",
    note = "",
    lecture = "",
    champ = "",
    code = "",
    dpt = "",
    xlab = "",
    ylab = "",
    subtitle = "",
    title = "",
    dptf = "month",
    wrap = ifelse(getOption("ofce.marquee"), 0, getOption("ofce.caption.wrap")),
    lang = getOption("ofce.caption.lang"),
    ofce = getOption("ofce.caption.ofce"),
    author = getOption("ofce.caption.author"),
    srcplus = getOption("ofce.caption.srcplus"),
    marquee_translate = ifelse(getOption("ofce.marquee"), TRUE, getOption("ofce.caption.marquee_translate")),
    glue = getOption("ofce.caption.glue"),
    ...) {
  md <- ofce_caption_md(
    source = source,
    note = note,
    lecture = lecture,
    champ = champ,
    code = code,
    dpt = dpt,
    xlab = xlab,
    ylab = ylab,
    subtitle = subtitle,
    title = title,
    dptf = dptf,
    wrap = wrap,
    lang = lang,
    ofce = ofce,
    author = author,
    srcplus = srcplus,
    marquee_translate = marquee_translate,
    glue = glue,
    env = parent.frame(n=2),
    ...)

  gplot <- list(ggplot2::labs(caption = md$caption))
  if(!is.null(md$xlab) && md$xlab!="")
    gplot <- rlist::list.append(gplot, ggplot2::xlab(label = md$xlab) )
  if(!is.null(md$ylab) && md$ylab!="")
    gplot <- rlist::list.append(gplot, ggplot2::ylab(label = md$ylab) )
  if(!is.null(md$subtitle) && md$subtitle!="")
    gplot <- rlist::list.append(gplot, ggplot2::labs(subtitle = md$subtitle ))
  if(!is.null(md$title) && md$title!="")
    gplot <- rlist::list.append(gplot, ggplot2::labs(title = md$title ))

  return(gplot)
}


#' fabricateur de source pour les tableaux
#'
#' permet de construire un caption facilement avec un wrapping,
#' le passage dans glue
#'
#' on commence par la source, une note, et une lecture
#' @param object l'objet gt
#' @param source texte de la source (sans le mot source qui est rajouté)
#' @param note texte de la note (sans le mot note qui est rajouté)
#' @param lecture texte de la note de lecture (sans le mot lecture qui est rajouté)
#' @param champ texte du champ (sans le mot champ qui est rajouté)
#' @param code texte du code (sans le mot code qui est rajouté)
#' @param subtitle inclu le label du sous titre (pour le traduire avec marquee/glue)
#' @param title inclu le titre (traduit aussi)
#' @param dpt dernier point connu
#' @param dptf fréquence du dernier point connu (day, month, quarter, year)
#' @param wrap largeur du texte en charactères (120 charactères par défaut, 0 ou NULL si on utilise marquee)
#' @param ofce (bool) si TRUE ajoute calculs OFCE à source, sinon rien, TRUE par défaut
#' @param author (bool) si TRUE ajoute calculs des auteurs à source, sinon rien, FALSE par défaut
#' @param srcplus (string) chaine (comme calculs OFCE) à ajouter à source (à la fin)
#' @param lang langue des textes (fr par défaut)
#' @param marquee_translate transforme ^x^ en {.sup x} et ~x~ en {.sub x}
#' @param glue applique glue avant toute chose
#' @param ... autres paramètres
#'
#' @return un objet gt (gt() |> ofce_caption_gt("INSEE"))

ofce_caption_gt <- function(
    object,
    source = "",
    note = "",
    lecture = "",
    champ = "",
    code = "",
    dpt = "",
    subtitle = "",
    title = "",
    dptf = "month",
    wrap = ifelse(getOption("ofce.marquee"), 0, getOption("ofce.caption.wrap")),
    lang = getOption("ofce.caption.lang"),
    ofce = getOption("ofce.caption.ofce"),
    author = getOption("ofce.caption.author"),
    srcplus = getOption("ofce.caption.srcplus"),
    marquee_translate = ifelse(getOption("ofce.marquee"),
                               TRUE,
                               getOption("ofce.caption.marquee_translate")),
    glue = getOption("ofce.caption.glue"),
    ...) {
  md <- ofce_caption_md(
    source = source,
    note = note,
    lecture = lecture,
    champ = champ,
    code = code,
    dpt = dpt,
    xlab = "",
    ylab = "",
    subtitle = subtitle,
    title = title,
    dptf = dptf,
    wrap = 0, # pas besoin pour les tables
    lang = lang,
    ofce = ofce,
    author = author,
    srcplus = srcplus,
    marquee_translate = FALSE, # il faudrait plutôt l'inverse...
    glue = glue,
    env = parent.frame(n=2),
    ...)

  if(!is.null(md$champ) && md$champ!="")
    object <- object |>
      gt::tab_source_note(gt::md(md$champ))
  if(!is.null(md$lecture) && md$lecture!="")
    object <- object |>
      gt::tab_source_note(gt::md(md$lecture))
  if(!is.null(md$note) && md$note!="")
    object <- object |>
      gt::tab_source_note(gt::md(md$note))
  if(!is.null(md$code) && md$code!="")
    object <- object |>
      gt::tab_source_note(gt::md(md$code))
  if(!is.null(md$source) && md$source!="")
    object <- object |>
      gt::tab_source_note(gt::md(md$source))
  if(!is.null(md$dpt) && md$dpt!="")
    object <- object |>
      gt::tab_source_note(gt::md(md$dpt))

  title <- subtitle <- NULL
  if(!is.null(md$title) && md$title!="")
    title <- gt::md(md$title)
  if(!is.null(md$subtitle) && md$subtitle!="")
    subtitle <- gt::md(md$subtitle)
  if(!is.null(subtitle)|is.null(title))
    object <- object |>
    gt::tab_header(title = title, subtitle = subtitle)

  return(object)
}


#' fabricateur de dernier point pour les sources de graphiques
#'
#' @param date liste de date
#' @param freq soit day, month, quarter, year
#' @param lang langue de retour
#' @return chaine de charactères

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

# coeur de la fonction, renvoie la caption calculée

ofce_caption_md <- function(
    source = "",
    note = "",
    lecture = "",
    champ = "",
    code = "",
    dpt = "",
    xlab = "",
    ylab = "",
    subtitle = "",
    title = "",
    dptf = "month",
    wrap = ifelse(getOption("ofce.marquee"), 0, getOption("ofce.caption.wrap")),
    lang = getOption("ofce.caption.lang"),
    ofce = getOption("ofce.caption.ofce"),
    author = getOption("ofce.caption.author"),
    srcplus = getOption("ofce.caption.srcplus"),
    marquee_translate = ifelse(getOption("ofce.marquee"), TRUE, getOption("ofce.caption.marquee_translate")),
    glue = getOption("ofce.caption.glue"),
    env = parent.frame()) {

  if(is.null(author)) author <- FALSE
  if(is.null(source)) source <- ""
  if(is.null(champ)) champ <- ""
  if(is.null(code)) code <- ""
  if(is.null(lecture)) lecture <- ""
  if(is.null(note)) note <- ""
  if(is.null(dpt)) dpt <- ""

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
  if(!is.null(title))
    title <- transforme(title)

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
    liner <- function(x) stringr::str_replace_all(x, "\\n", linebr)
  }
  if(champ!="") {
    champ <- stringr::str_c(chp, champ)  |>
      check_point() |>
      wrapper() |>
      liner()
  } else
    champ <- NULL

  if(lecture!="") {
    lecture <- stringr::str_c(lec, lecture)  |>
      check_point() |>
      wrapper() |>
      liner()
  } else
    lecture <- NULL

  if(note!="") {
    note <- stringr::str_c(not, note) |>
      check_point() |>
      wrapper() |>
      liner()
  } else
    note <- NULL

  if(!is.null(srcplus)&ofce) {
    if(source=="")
      source <- Srcp else
        source <- stringr::str_c(source , srcp)
  }

  if(code!="") {
    code <- stringr::str_c(cod, code) |>
      wrapper() |>
      liner()
  } else
    code <- NULL

  if(source!="") {
    if(stringr::str_detect(source, ",|;"))
      src <- src |> stringr::str_replace("ce", "ces")
    source <- stringr::str_c(src, source) |>
      check_point() |>
      wrapper() |>
      liner()
  } else
    source <- NULL

  if(length(dpt)>1 || (length(dpt==1) && dpt!="")) {
    dpt <- stringr::str_c(Der, dernier_point(dpt, dptf, lang)) |>
      check_point()
  } else
    dpt <- NULL

  caption <- stringr::str_c(champ, lecture, note, code, source, dpt, sep = linebr)
  if(length(caption)==0)
    caption <- NULL
  return(list(caption = caption,
              xlab = xlab, ylab = ylab, subtitle = subtitle, title = title,
              champ = champ, lecture = lecture, note = note, code = code, source = source, dpt = dpt))
}
