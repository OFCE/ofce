library(tidyverse)
library(showtext)
ggplot(cars)+aes(x=speed, y=dist, col=speed>15)+
  geom_point()+
  theme_ofce(base_size = 12,
             legend.position = "bottom",
             legend.justification = c(0.5, 0.5),
             legend.direction = "horizontal",
             marquee=TRUE) +
  labs(title = NULL,
       x = NULL,
       subtitle = NULL)+
  ofce_caption(
    wrap=0,
    champ = "dans ton cul",
    source =  "une source longue, longue, longue, longue, longue, longue,longue, longue,
    longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
    longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
    longue, longue, longue, longue, longue, longue.

    -    avec un retour à la ligne"
  )


ggplot(cars)+aes(x=speed, y=dist, col=speed>15)+
  geom_point()+
  theme_ofce(base_size = 12, legend.position = "top")

