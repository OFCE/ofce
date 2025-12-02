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
#' \dontrun{
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
#' }
#'
#' @seealso [gt::tab_options()], [ofce_caption_gt()]
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
    data_row.padding = 2,
    footnotes.multiline = FALSE,
    footnotes.padding = 5,
    source_notes.padding =  2,
    table.border.bottom.style = "none",
    row_group.padding = 2),
    !!!dots)
  do.call(\(...) gt::tab_options(data, ...), dots) |>
    gt::opt_footnote_marks("letters")
}
