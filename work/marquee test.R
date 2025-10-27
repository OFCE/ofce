library(tidyverse)
library(showtext)
p <- ggplot(cars)+aes(x=speed, y=dist, col=speed>15)+
  geom_point()+
  theme_ofce(base_size = 12,
             legend.position = "bottom",
             legend.justification = c(0.5, 0.5),
             legend.direction = "horizontal",
             marquee=TRUE) +
  facet_wrap(vars(speed>15)) +
  labs(title = NULL,
       x = NULL,
       subtitle = NULL)+
  ofce_caption(
    wrap=0,
    champ = "dans ton ... dans ton ... dans ton ... dans ton ... dans ton ... dans ton ... dans ton ...",
    source =  "une source longue, longue, longue, longue, longue, longue,longue, longue,
    longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
    longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
    longue, longue, longue, longue, longue, longue.

    -    avec un retour à la ligne"
  )

p + logo_ofce(1)

## pattern

pattern <- ofce_logo |>
  magick::image_read() |>
  grid::rasterGrob(
    x = 0.99, y = 0.01,
    width = unit(0.1, "snpc"),
    height = unit(0.1/142*65, "snpc"),
    just = c(1,0)) |>
  grid::pattern(extend = "none")

p+ theme(
  plot.background = element_rect(fill = pattern)
)
