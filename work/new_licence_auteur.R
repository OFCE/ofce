devtools::load_all()
plop<- ggplot(iris) +
  aes(x = Sepal.Length, y = Petal.Length, color = Species) +
  geom_point() +
  labs(title = "Longueur des pétales et des sépales",
       x = "Sépale (cm)", y = "Pétale (cm)") +
  theme_ofce() +
  licence_auteur(author = "X. Timbeau",text_size = 3) +
  facet_wrap(~Species)
ggiraph::girafe(plop)

## Reproducible example
##
##
library(tidyverse)
library(munch)
library(marquee)


gg <- ggplot(mtcars) +
  aes(x = disp, y = mpg) +
  geom_point() +
  labs(tag = my_tag) +
  facet_wrap(vars(cyl)) +
  theme_ofce(

  ) +
  licence_auteur(author = "Xavier Timbeau")

gg

ggiraph::girafe(gg)
