library(tidyverse)
library(gt)
# Charger le package gt
data <- data.frame(
  Variable = c("Emploi salarié", "Marchand", "Non marchand", "Emploi non salarié", "Emploi total", "Variation en %", "Taux de chômage", "Population active (en %)"),
  T1_2024 = c(-30 , -40 , 10, 5  , -24, -0.1, 7.7, 0.1),
  T2_2024 = c(-22 , -32 , 10, 5  , -17, -0.1, 7.8, 0.1),
  T3_2024 = c(8   , -5  , 3 , 5  , -13, -0.1, 7.9, 0.1),
  T4_2024 = c(-71 , -74 , 3 , 5  , -64, -0.4, 8.2, 0.1),
  T1_2025 = c(-30 , -40 , 10, 5  , -24, -0.1, 7.7, 0.1),
  T2_2025 = c(-22 , -32 , 10, 5  , -17, -0.1, 7.8, 0.1),
  T3_2025 = c(8   , -5  , 3 , 5  , -13, -0.1, 7.9, 0.1),
  T4_2025 = c(-71 , -74 , 3 , 5  , -64, -0.4, 8.2, 0.1),
  Y_2023  = c(157 , 99  , 47, 131, 208, 0.8 , 7.5, 0.8),
  Y_2024  = c(-115, -138, 26, 20 , -92, -0.3, 8.2, 0.3),
  Y_2025  = c(69  , 55  , 13, 36 , 104, 0.3 , 8.1, 0.3) ) |>
  gt::gt() |>
  gt::tab_header(
    title = "Évolution du marché du travail",   ) |>
  gt::cols_label(
    Variable= "En milliers",
    T1_2024 = "T1",
    T2_2024 = "T2",
    T3_2024 = "T3",
    T4_2024 = "T4",
    T1_2025 = "T1",
    T2_2025 = "T2",
    T3_2025 = "T3",
    T4_2025 = "T4",
    Y_2023 = "",
    Y_2024 = "",
    Y_2025 = ""   ) |>
  ## PREMIER NIVEAU DE SPANNER
  # Spanner pour les trimestres de 2024
  gt::tab_spanner(
    label = "2024",
    columns = c(T1_2024, T2_2024, T3_2024, T4_2024)   ) |>
  # Spanner pour les trimestres de 2025
  gt::tab_spanner(
    label = "2025",
    columns = c(T1_2025, T2_2025, T3_2025, T4_2025)   ) |>
  # Spanner pour l'année 2023
  gt::tab_spanner(     label = "2023 ",
                   columns = Y_2023   ) |>
  # Spanner pour l'année 2024
  gt::tab_spanner(     label = "2024 ",
                   columns = Y_2024   ) |>
  # Spanner pour l'année 2025
  gt::tab_spanner(     label = "2025 ",
                   columns = Y_2025   ) |>
  ## DEUXIEME NIVEAU DE SPANNER
  # Spanner pour les chiffres trimesrtriels
  gt::tab_spanner(     label = "Variation (T/T-1)",
                   columns = c(T1_2024, T2_2024, T3_2024, T4_2024, T1_2025, T2_2025, T3_2025, T4_2025)   )  |>
  # Spanner pour les chiffres annuels
  gt::tab_spanner(     label = "Variation (T/T-4)",     columns = c(Y_2023, Y_2024, Y_2025)   )  |>
  # Centrer les colonnes des années 2023, 2024, 2025
  gt::cols_align(     align = "center",
                  columns = c(Y_2023, Y_2024, Y_2025)    )

