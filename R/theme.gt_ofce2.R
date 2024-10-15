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

theme.gt_ofce_2 <- function(data,
                            largeur_colonne = NULL,
                            col_highlight = NULL,
                            row_highlight = NULL,
                            ...){

  stopifnot("'data' must be a 'gt_tbl', have you accidentally passed raw $data?" = "gt_tbl" %in% class(data))
  rlang::check_installed("gt", reason = "pour utiliser theme.gt_ofce")

  if (is.null(largeur_colonne)){largeur_colonne = 100}

  # col_highlight <-  c("T1_2025", "T2_2025", "T3_2025")

  data |>
    # Défini la largeur des colonnes (sauf la première)
    gt::cols_width(-1 ~ gt::px(largeur_colonne)) |>
    # General options
    gt::opt_table_lines("default") |>
    gt::opt_table_font(font = gt::google_font("Nunito")) |>
    gt::opt_footnote_marks(marks = "letters") |>
    # Spanners
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = c("top"), "transparent", "solid", gt::px(0.5)),
        gt::cell_borders(sides = c("bottom"), "#b30000", "solid", gt::px(3.5)),
        gt::cell_fill(color = "#FFFFFF"),
        gt::cell_text(color = "#b30000", weight = "normal")
      ),
      locations = gt::cells_column_spanners()
    ) |>
    # Column_labels
    gt::tab_style(
      style = list(

        gt::cell_borders(sides = "top", color = "#b30000", "solid", gt::px(1)),
        gt::cell_borders(sides = "bottom", color ="transparent", "solid", gt::px(1.5)),
        gt::cell_text(color = "#b30000", weight = "normal", style = "italic")
      ),

      locations =  gt::cells_column_labels()
    ) |>
    ## Surlignage
    gt::tab_style(
      style = list( gt::cell_text(weight = "normal", color = "gray45")),
      locations =  gt::cells_body(
        columns = tidyselect::everything(),
        rows = tidyselect::everything())) |>
    # Labels
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = "bottom" , color =  "#b30000", "solid", gt::px(1))
      ),
      locations = gt::cells_row_groups()
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_fill(color = "#ffe6e6"),
        #cell_borders(color = "gray80"),
        gt::cell_text(style = "normal", color = "darkred",weight = "bold")),
      locations =  gt::cells_body(
        columns = col_highlight
      )) |>
    # gt::tab_style(
    #   style = list(
    #     # cell_fill(color = "gray80"),
    #     cell_text(style = "normal", color = "darkred",weight = "bolder")),
    #   locations = cells_body(
    #     rows = (row_highlight[[1]] %in% row_highlight[-1])
    #   )) |>
    gt::fmt_number(
      decimals = 0
    ) |>
    # gt::fmt_number(
    #   columns = everything(),
    #   decimals = 2,
    #   rows = row_highlight[[1]] %in% row_highlight[-1])     |>
    # Formater les autres lignes sans décimale
    # tab_style(
    #   style = list(
    #     cell_borders(sides = "top",style = "solid",weight = px(0.7), color = "darkred")
    #   ),
    #   locations = cells_body(
    #     rows = "Emploi total"))
    # Other tab options
    gt::tab_options(
      table.border.top.color = "transparent",
      ## Heading
      heading.align = "center",
      heading.title.font.size = gt::px(18),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = gt::px(16),
      # heading.border.bottom.style = "hidden",
      heading.border.bottom.width = gt::px(1),
      heading.border.bottom.color = "#b30000",

      ## Labels
      # column_labels.border.top.style = "solid",
      # column_labels.background.color = "transparent",
      column_labels.font.weight = "bolder",
      column_labels.border.bottom.style = 'solid',
      column_labels.border.bottom.width = gt::px(1.5),
      column_labels.border.bottom.color = "#b30000",
      row_group.font.weight = "bold",
      row_group.border.top.color = "#000000",
      # row_group.border.top.width = gt::px(1),
      # row_group.border.bottom.width = gt::px(1),
      # row_group.border.bottom.color = "#000000" ,
      # column_labels.border.top.color = "transparent",


      ## Body
      table_body.border.top.style = "solid",
      table_body.border.top.color = "#b30000",
      table_body.border.top.width = gt::px(2),
      table_body.border.bottom.style = "solid",
      table_body.border.bottom.width = gt::px(1),
      table_body.border.bottom.color = "#b30000",
      stub_row_group.border.color = "transparent",
      stub.border.color = "#000000",
      stub.border.width = gt::px(1),
      stub.font.size = "bold",
      stub.font.weight = "bold",
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
      table.border.bottom.color = "transparent",
      ## Source
      source_notes.font.size = gt::px(12),
      source_notes.padding = NULL,
      source_notes.padding.horizontal = NULL,
      source_notes.border.bottom.style = NULL,
      source_notes.border.bottom.color = "#FFFFFF",
      source_notes.border.lr.style = "none",
  ...
  )
}
