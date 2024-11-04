library(tidyverse)
library(curl)
library(readxl)

curl::curl_download(
    url = "https://www.cgedd.fr/nombre-vente-maison-appartement-ancien.xls",
    destfile = "/tmp/nombre-vente-maison-appartement-ancien.xls")

transactions <- read_xls("/tmp/nombre-vente-maison-appartement-ancien.xls", sheet = 2, skip = 23) %>%
  select(1, 3) %>%
  setNames(c("date", "nombre_transactions")) %>%
  mutate(date = as.Date(date),
         nombre_transactions = as.numeric(nombre_transactions)) |>
  mutate(date = floor_date(date, "quarter")) |>
  group_by(date) |>
  summarize(t = mean(nombre_transactions, na.rm = TRUE)) |>
  drop_na() |>
  mutate(
    tooltip = str_c("<b>", year(date), " T", quarter(date), "</b><br>", round(t), "k transactions<br>",
                    "Ecart au max :", round(100*t/max(t, na.rm=TRUE)-100), "%<br>",
                    "Ecart au dernier :", round(-100*last(t)/t+100), "%")) |>
  filter(date>="1996-01-01")

csv <- vroom::vroom("data.csv")

return(list(transactions, csv))

#cc
