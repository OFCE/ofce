library(ggplot2)
library(showtext)
showtext_opts(dpi=200)
showtext_auto()
ggplot(cars)+
    geom_point(aes(x=speed, y=dist))+
    theme_ofce(base_family = "Open Sans", base_size = 12)

