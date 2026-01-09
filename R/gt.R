#' Options de tableau gt par défaut pour les standards OFCE
#'
#' Applique des options de style cohérentes aux tableaux gt selon les standards
#' graphiques de l'OFCE. Configure la taille des polices, les espacements,
#' les bordures et les marques de notes de bas de page.
#'
#' @param data Un objet gt table
#' @param ... Arguments supplémentaires passés à [gt::tab_options()] qui
#'   remplaceront les valeurs par défaut OFCE
#'
#' @return Un objet gt table avec les options de style appliquées
#'
#' @details
#' Les options par défaut appliquées sont :
#' * `footnotes.font.size = "90%"` - Taille réduite pour les notes
#' * `source_notes.font.size = "100%"` - Taille normale pour les sources
#' * `quarto.disable_processing = TRUE` - Désactive le traitement Quarto
#' * `table_body.hlines.style = "none"` - Pas de lignes horizontales dans le corps
#' * `column_labels.padding = 3` - Espacement des en-têtes de colonnes
#' * `data_row.padding = 2` - Espacement des lignes de données
#' * `footnotes.multiline = FALSE` - Notes sur une seule ligne
#' * `footnotes.padding = 5` - Espacement des notes
#' * `source_notes.padding = 2` - Espacement des sources
#' * `table.border.bottom.style = "none"` - Pas de bordure inférieure
#' * `row_group.padding = 2` - Espacement des groupes de lignes
#'
#' Les marques de notes de bas de page utilisent des lettres (a, b, c, etc.)
#' via [gt::opt_footnote_marks()].
#'
#' @examples
#' library(gt)
#' library(dplyr)
#'
#' # Tableau simple avec options OFCE
#' mtcars |>
#'   head() |>
#'   gt() |>
#'   ofce_tab_options()
#'
#' # Remplacer certaines options par défaut
#' mtcars |>
#'   head() |>
#'   gt() |>
#'   ofce_tab_options(
#'     table.font.size = "12px",
#'     data_row.padding = 4
#'   )
#'
#' @seealso [gt::tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_spanners_bold()], [ofce_row_italic()], [ofce_align_decimal()], [ofce_fmt_decimal()], [ofce_hide_col_pdf()]
#'
#' @export
ofce_tab_options <- function(data, ...) {
  browser
  dots <- list(...)
  dots <- purrr::list_modify(
    list(
    footnotes.font.size = "90%",
    source_notes.font.size = "100%",
    quarto.disable_processing= TRUE,
    table.font.size = getOption("ofce.tab.font.size"),
    table.font.name = "Open Sans",
    table_body.hlines.style = "none",
    column_labels.padding = 3,
    table.border.bottom.style = "none",
    data_row.padding = 3,
    footnotes.multiline = FALSE,
    footnotes.padding = 5,
    source_notes.padding =  2,
    table.background.color = "transparent",
    row_group.padding = 3),
    !!!dots)
  do.call(\(...) gt::tab_options(data, ...), dots) |>
    gt::opt_footnote_marks("letters")
}

#' Teinte les colonnes choisies en fond de couleur
#'
#' @param data le tableau gt passé en paramètre
#' @param columns les colonnes à teinter
#' @param fill la couleur (par défaut "#FFEDED")
#'
#' @returns tableau gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt::gt() |> ofce_cols_fill(disp)
ofce_cols_fill <- function(data, columns, fill = getOption("ofce.tab.fill")) {
  tab_style(data, style = cell_fill(color = fill),
            locations = cells_body(columns = {{columns}}))
}

#' Met en gras une ligne
#'
#' @param data le tableau gt passé en paramètre
#' @param row le sélecteur de la ligne
#'
#' @returns un tableau gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt() |> ofce_row_bold(gear == 4)
#'
#' @seealso [ofce_tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_spanners_bold()], [ofce_row_italic()], [ofce_align_decimal()], [ofce_fmt_decimal()], [ofce_hide_col_pdf()]

ofce_row_bold <- function(data, row = everything()) {
  tab_style(data, style = cell_text(weight = "bold"),  locations = cells_body(rows = {{ row }}))
}

#' Mets les spanners en gras
#'
#' @param data le tableau gt passé en paramètre
#'
#' @returns un tableau gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt::gt() |> gt::tab_spanner("spanner A", c(am, gear, carb)) |> ofce_spanners_bold()
#'
#' @seealso [ofce_tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_row_italic()], [ofce_align_decimal()], [ofce_fmt_decimal()], [ofce_hide_col_pdf()]
ofce_spanners_bold <- function(data) {
  tab_style(data, style = cell_text(weight = "bold"),  locations = gt::cells_column_spanners())
}

#' Mets une ligne en italique
#'
#' @param data le tableau gt passé en paramètre
#' @param row le sélecteur de ligne
#'
#' @returns un tableau gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt::gt() |> ofce_row_italic(gear == 4)
#'
#' @seealso [ofce_tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_spanners_bold()], [ofce_align_decimal()], [ofce_fmt_decimal()], [ofce_hide_col_pdf()]

ofce_row_italic <- function(data, row = everything()) {
  tab_style(data, style = cell_text(style = "italic"),  locations = cells_body(rows = {{row}}))
}

#' Aligne sur le séparateur décimal (,)
#'
#' Si aucune colonne n'est passée en paramètre, alors toutes les colonnes numériques sont alignées.
#'
#' @param data le tableau gt passé en paramètre
#' @param columns les colonnes sélectionnées
#'
#' @returns un tableau gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt::gt() |> ofce_align_decimals(qsec)
#'
#' @seealso [ofce_tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_spanners_bold()], [ofce_row_italic()], [ofce_fmt_decimal()], [ofce_hide_col_pdf()]
ofce_align_decimal <- function(data, columns = tidyselect::where(is.numeric)) {
    data <- data |> ofce_fmt_decimal({{columns}})
    cols_align_decimal(data, columns = {{columns}}, dec_mark = ",")
}

#' Formate en français les nombres
#'
#' @param data le tableau gt passé en paramètres
#' @param columns les colonnes sélectionnées (tout ce qui est numérique par défaut)
#' @param rows les lignes sélectionnées (tout par défaut)
#' @param decimals (le nombre de chiffres après la , 1 par défaut)
#'
#' @returns un tableau gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt::gt() |> ofce_fmt_decimals()
#'
#' @seealso [ofce_tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_spanners_bold()], [ofce_row_italic()], [ofce_align_decimal()], [ofce_hide_col_pdf()]
ofce_fmt_decimal <- function(data, columns = tidyselect::where(is.numeric), rows = tidyselect::everything(), decimals = 1) {
   fmt_number(data, columns = {{columns}}, rows = {{rows}}, dec_mark = ",", decimals = decimals, sep_mark = " ")
}

#' Masque des colonnes en pdf
#'
#' Lorsqu'on utilise des colonnes qui peuvent bloquer en pdf, comme les nanoplots,
#' cette fonction sert à les enlever sélectivement.
#'
#' Encore à tester avec typst
#'
#' @param tbl le gt passé en paramètre
#' @param col les colonnes sélectionnées
#'
#' @returns un gt
#' @export
#'
#' @examples
#' head(mtcars) |> gt::gt() |> cols_hide_pdf(disp)
#'
#' @seealso [ofce_tab_options()], [ofce_caption()], [ofce_cols_fill()], [ofce_spanners_bold()], [ofce_row_italic()], [ofce_align_decimal()], [ofce_fmt_decimal()]
ofce_hide_col_pdf <- function(tbl, col) {
  if(knitr::is_latex_output())
    return(gt::cols_hide(data = tbl, columns = {{ col }} ))
  return(tbl)
}
