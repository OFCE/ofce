
data_set <- tibble::tibble( name = c(stringr::str_c("name_",1:10)),
                    `2022` = round(c(rnorm(10,.9,.1)),2),
                    `2023` = round(c(rnorm(10,.9,.1)),2),
                    `2024` = round(c(rnorm(10,.9,.1)),2) ,

                    `2022_1` = round(c(rnorm(10,.9,.1)),2),
                    `2023_2` = round(c(rnorm(10,.9,.1)),2),
                    `2024_3` = round(c(rnorm(10,.9,.1)),2)
) |>
  gt::gt(rowname_col = "name") |>
  gt::rm_stubhead() |>
  gt::cols_label(starts_with("2022") ~ "2022",
             starts_with("2023") ~ "2023",
             starts_with("2024") ~ "2024") |>
  gt::tab_spanner(
    label = md('**Variation annuelle (en %)**'),
    columns = 2:4
  ) |>
  gt::tab_spanner(
    label = md('**Contribution à la variation annuelle de l\'IPC (en points de %)**'),
    columns = 5:7
  )  |> gt::cols_align(align = "center") |>
  ## Pour mettre une source
  gt::tab_source_note(
    source_note = "INSEE, calcul des auteurs"
  )
