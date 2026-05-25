library(tidyverse)
library(ofce)
ggplot(mtcars) +
  aes(x=disp, y=mpg)+
  geom_point()+
  theme_ofce(marquee=TRUE)+
  ofce_caption(
    source = "source"
  )+
  labs(y = "**y** *rti*", x = "**ldq**", title = "*slkjf*")

gg +
  ofce_caption(
    source = NULL, ofce = FALSE, author = TRUE,
    code = NULL)


library(tidyverse)
library(countrycode)

data <- bind_rows(
  tibble::tibble( pays = "FRA", a  = runif(10), b=1:10, date = ymd("2010-01-01") + years(1:10)),
  tibble::tibble( pays = "ITA", a  = runif(10), b=1:10, date = ymd("2010-01-01") + years(1:10)),
  tibble::tibble( pays = "DEU", a  = runif(10), b=1:10, date = ymd("2010-01-01") + years(1:10)))

gg <- ggplot(data) +
  theme_ofce() +
  aes(color = pays, x=date, y=a, group=pays)+
  # scale_color_manual(values = c(FRA = "red",DEU = "orange", ITA= "yellow", EU ="blue"),
  #                    breaks = c("FRA", "DEU", "ITA", "EU"),
  #                    labels = c("FRA", "DEU", "ITA", "EU"),
  #                    name = NULL,
  #                   aesthetics = c("fill", "color")) +
  scale_color_pays("iso3c", aesthetics = "color")+
  ggiraph::geom_point_interactive(aes(data_id = date, fill = pays),
                                  size = 2, color = "white", shape = 21, stroke= 0.5,) +
  scale_ofce_date(
    date_breaks = "1 year",
    date_minor_breaks = "1 month",
    labels = ofce::date1,
    expand = expansion(c(0.03, 0.03))
  ) +
  geom_line()

girafy(gg, ggiraph::opts_hover(css = "fill:orange;"), biratio = TRUE)

