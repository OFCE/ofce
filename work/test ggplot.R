library(ggplot2)
library(showtext)
showtext.auto()
ggplot(cars)+
    geom_point(aes(x=speed, y=dist))+
    theme_ofce(base_family = "Open Sans", base_size = 48)

