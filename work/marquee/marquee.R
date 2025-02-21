library(ggplot2)
library(marquee)
library(patchwork)
library(ofce)
ggplot(mtcars) +
  aes(x = mpg, y = drat, color = factor(cyl)) +
  geom_point() +
  labs(subtitle = "A subtitle", title = "A title") +
  theme_ofce(marquee = TRUE)

g1 <- ggplot(mtcars) +
  aes(x = mpg, y = hp, color = factor(cyl)) +
  geom_point()
g1bis <- ggplot(mtcars) +
  aes(x = mpg, y = hp, color = factor(cyl)) +
  geom_point() +
  guides(color = guide_marquee("*Légende* : {.4 **4 cylinders**}, {.6 **6 cylinders**}, {.8 **8 cylinders**}",
                               position = "top"))

g2 <- ggplot(mtcars) +
  aes(x = mpg, y = drat, color = factor(cyl)) +
  geom_point() +
  scale_y_log10() +
  guides(color = guide_marquee("*Légende* : {.4 **4 cylinders**}, {.6 **6 cylinders**}, {.8 **8 cylinders**}",
                               position = "top"))

 g2 /g1bis

set_dim(g2, get_dim(g1))
set_dim(g2, get_dim(g1bis))


g <- ggplot(mtcars) +
  aes(x = mpg, y = hp, color = cyl) +
  geom_point()

g +  theme(legend.position = "bottom",
        legend.direction = "horizontal",
        legend.text = element_marquee(),
        legend.key.width = unit(72, 'pt'))



library(legendry)

ggplot(mtcars) +
  geom_point(aes(x = mpg, y = hp, fill = cyl, size=hp), shape=21, color = "transparent") +
  scale_size(breaks = c(75, 250)) +
  guides(size = guide_circles(override.aes = list(color = "blue", stroke = 0.25)))

ggplot(mtcars) +
  geom_point(aes(x = mpg, y = hp, fill = cyl, size=hp), shape=21, color = "red", stroke = 0.2) +
  scale_size(breaks = c(100, 250)) +
  guides(size = guide_circles(override.aes = list(color = "blue", stroke = 0.25)))

