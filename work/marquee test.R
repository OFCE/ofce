library(tidyverse)
library(showtext)
ggplot(cars)+aes(x=speed, y=dist, col=speed>15)+
  geom_point()+
  theme_ofce(base_size = 12, legend.position = "top", marquee=TRUE) +
  labs(title = NULL,
       subtitle = NULL,
       caption = "*Source* : une source longue, longue, longue, longue, longue, longue,
        longue, longue,
        longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
        longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
        longue, longue, longue, longue, longue, longue.

-    avec un retour à la ligne")


ggplot(cars)+aes(x=speed, y=dist, col=speed>15)+
  geom_point()+
  theme_ofce(base_size = 12, legend.position = "top")

