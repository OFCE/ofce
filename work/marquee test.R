library(tidyverse)
library(showtext)
showtext_auto()
showtext_opts(dpi = 192)
ggplot(cars)+aes(x=speed, y=dist, col=speed>15)+
  geom_point()+
  theme_ofce(base_size = 12) +
  labs(title = "test 123",
       subtitle = "Un sous titre",
       caption = "*Source* : une source longue, longue, longue, longue, longue, longue, longue, longue,
        longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
        longue, longue, longue, longue, longue, longue, longue, longue, longue, longue,
        longue, longue, longue, longue, longue, longue")


