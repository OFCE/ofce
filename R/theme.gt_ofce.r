#' Thème OFCE pour les tableaux pour {gt}
#'
#' Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
#'
#' @param ... autres arguments à passer dans la fonction
#' @param data un objet gt
#' @param largeur_colonne largeur de colonne (en px)
#'
#' @return un objet gt, décoré
#' @export

theme.gt_ofce <- function(data,
                          largeur_colonne = NULL,
                          ...){

  stopifnot("'data' must be a 'gt_tbl', have you accidentally passed raw $data?" = "gt_tbl" %in% class(data))
  rlang::check_installed("gt", reason = "pour utiliser theme.gt_ofce")

  if (is.null(largeur_colonne)){largeur_colonne = 100}

  data |>
    # Défini la largeur des colonnes (sauf la première)
    # gt::cols_width(-1 ~ gt::px(largeur_colonne)) |>
    # General options
    gt::opt_table_lines("default") |>
    gt::opt_table_font(font = gt::google_font("Open Sans")) |>
    gt::opt_footnote_marks(marks = "letters") |>
    # Spanners
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = "all", "#275C9A", "solid", gt::px(1)),
        gt::cell_fill(color = "#275C9A"),
        gt::cell_text(color = "#FFFFFF", weight = "bold")
      ),
      locations = gt::cells_column_spanners()
    ) |>
    # Column_labels
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = "bottom", color = "#000000", "solid", gt::px(1)),
        gt::cell_borders(sides = "top", color = "#275C9A", "solid", gt::px(1)),
        gt::cell_text(color = "#1D3885", weight = "bold"),
        gt::cell_borders(sides = "bottom", color ="black", "solid", gt::px(1.5))
      ),
      locations =  gt::cells_column_labels()
    ) |>
    # stubhead (colonne de gauche)
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = c("bottom", "top"), color = "red", "solid", gt::px(1)),
        gt::cell_borders(sides = c("bottom", "top"), color = "black", "solid", gt::px(1.5))
      ),
      locations = gt::cells_stubhead()
    ) |>
    # Labels
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = "bottom" , color =  "transparent", "solid", gt::px(1)),
        gt::cell_borders(sides = "bottom", color = "transparent", "solid", gt::px(1))
      ),
      locations = gt::cells_row_groups()
    ) |>
    # title
    gt::tab_style(
      style = gt::cell_borders(sides = "left", color ="#e8142c", "solid", gt::px(5)),
      location = gt::cells_title(groups="title")) |>
    # Source note
    gt::tab_style(
      style=gt::cell_borders("bottom", "transparent", "solid", gt::px(5)),
      locations = gt::cells_source_notes()
    ) |>
    gt::tab_style(
      style = list(gt::cell_fill(color = "#EEF6FA"),
                   gt::cell_text(weight = "bold")),
      locations = gt::cells_stub()
    ) |>
    # Row_stripping (zébrage)
    gt::opt_row_striping(row_striping = TRUE) |>
    # Other tab options
    gt::tab_options(
      row.striping.background_color = "#EEF6FA",
      table.border.top.color = "transparent",
      ## Heading
      heading.align = "center",
      heading.title.font.size = gt::px(18),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = gt::px(16),
      heading.border.bottom.style = "hidden",
      heading.border.bottom.width = gt::px(1),
      heading.border.bottom.color = "#000000",
      ## Labels
      column_labels.border.top.style = "solid",
      column_labels.background.color = "transparent",
      column_labels.font.weight = "bold",
      column_labels.border.bottom.style = 'solid',
      column_labels.border.bottom.width = gt::px(1.5),
      column_labels.border.bottom.color = "transparent",
      row_group.font.weight = "bold",
      row_group.border.top.color = "#000000",
      row_group.border.top.width = gt::px(1),
      row_group.border.bottom.width = gt::px(1),
      row_group.border.bottom.color = "#000000" ,
      column_labels.border.top.color = "transparent",
      ## Body
      table_body.border.top.style = "solid",
      table_body.border.top.color = "red",
      table_body.border.top.width = gt::px(1),
      table_body.border.bottom.style = "solid",
      table_body.border.bottom.width = gt::px(1.5),
      table_body.border.bottom.color = "#000000",
      stub_row_group.border.color = "transparent",
      stub.border.color = "#000000",
      stub.border.width = gt::px(1),
      stub.font.size = "bold",
      stub.font.weight = NULL,
      ## Padding
      data_row.padding = gt::px(2),
      row_group.padding = gt::px(3),
      column_labels.padding = gt::px(3),
      summary_row.padding = gt::px(3),
      summary_row.border.width = gt::px(1),
      summary_row.border.color = "#000000",
      grand_summary_row.padding = gt::px(3),
      ## Footnote
      footnotes.background.color = NULL,
      footnotes.font.size = gt::px(12),
      footnotes.padding = NULL,
      ## Source
      source_notes.font.size = gt::px(12),
      source_notes.padding = NULL,
      source_notes.padding.horizontal = NULL,
      source_notes.border.bottom.style = NULL,
      source_notes.border.lr.style = "none",
      ...
    )
}
