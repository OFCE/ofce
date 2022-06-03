#' Thème OFCE pour les tableaux pour {gt}
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#'
#' @param data un objet gt
#' @param base_family character(1) string, police de charactère du thème (Stone sans par défaut)
#'
#' @return un objet gt, décoré
#' @export

table_ofce <- function(data, ...){

  stopifnot("'data' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(data))
  rlang::check_installed("gt", reason = "pour utiliser table_ofce")

  data |>
    gt::opt_table_lines("none") |>
    gt::opt_table_font(font = gt::google_font("Nunito")) |>
    gt::opt_footnote_marks(marks = "letters") |>
    gt::tab_style(
      style=gt::cell_borders("bottom", "#000000", "solid", gt::px(1)),
      location = gt::cells_column_spanners()) |>
    gt::tab_style(
      style=gt::cell_borders("left", "#FFFFFF", "solid", gt::px(5)),
      location = gt::cells_column_spanners()) |>
    gt::tab_style(
      style=gt::cell_borders("bottom", "#000000", "solid", gt::px(1)),
      location = gt::cells_column_labels()) |>
    gt::tab_style(
      style= gt::cell_borders(c("bottom", "top"), "#000000", "solid", gt::px(1)),
      location = gt::cells_row_groups()) |>
    gt::tab_style(
      style = gt::cell_borders("left", "#e8142c", "solid", px(5)),
      location = gt::cells_title()) |>
    gt::tab_options(
      column_labels.background.color = "#FFFFFF",
      column_labels.font.weight = "normal",
      row_group.border.top.color = "#000000",
      row_group.border.top.width = px(1),
      row_group.border.bottom.width = px(1),
      row_group.border.bottom.color = "#000000",
      table_body.border.top.style = "solid",
      table_body.border.top.color = "#000000",
      table_body.border.bottom.style = "solid",
      table_body.border.bottom.width = px(1),
      table_body.border.top.width = px(1),
      table_body.border.bottom.color = "#000000",
      heading.border.bottom.style = "solid",
      heading.border.bottom.width = px(1),
      heading.border.bottom.color = "#000000",
      stub_row_group.border.width = px(1),
      stub_row_group.border.color = "#000000",
      summary_row.border.width = px(1),
      summary_row.border.color = "#000000",
      stub.border.color = "#000000",
      stub.border.width = px(1),
      data_row.padding = px(2),
      row_group.padding = px(3),
      column_labels.padding = px(3),
      summary_row.padding = px(3),
      grand_summary_row.padding = px(3),
      source_notes.border.lr.style = "none",
      heading.align = "left",
      row.striping.background_color = "#ffe6e8",
      ...
    )
}
