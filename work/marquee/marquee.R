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


library(ggplot2)
library(marquee)

g <- ggplot(mtcars) +
  aes(x = mpg, y = hp, color = cyl) +
  geom_point()

# good
g +  theme(legend.position = "bottom",
           legend.direction = "horizontal",
           legend.text = element_marquee(),
           legend.title = element_marquee(),
           axis.title.y = element_text(margin= margin(t= 10, unit = "pt")),
           legend.key.width = unit(32, 'pt'))

# not so good
g +  theme(legend.position = "bottom",
        legend.direction = "horizontal",
        legend.text = element_marquee(),
        legend.title = element_marquee(),
        axis.title.y = element_marquee(margin= margin(t= 10, unit = "pt")),
        legend.key.width = unit(32, 'pt'))


library(ggplot2)
library(marquee)

# Only on line (as expected, wide enough)
ggplot(mtcars) +
  aes(x = mpg, y = hp, color = cyl) +
  geom_point()+
  scale_color_continuous(name = "a scale on 1 line (units)") +
  theme(legend.position = "bottom",
        legend.direction = "horizontal",
        legend.title = element_marquee(),
        legend.key.width = unit(32, 'pt'))

# breaks on 3 lines
ggplot(mtcars) +
  aes(x = mpg, y = hp, color = cyl) +
  geom_point()+
  scale_color_continuous(name = "a scale on 2 lines  \n(units)") +
  theme(legend.position = "bottom",
           legend.direction = "horizontal",
           legend.title = element_marquee(),
           legend.key.width = unit(32, 'pt'))


library(legendry)

ggplot(mtcars) +
  geom_point(aes(x = mpg, y = hp, fill = cyl, size=hp), shape=21, color = "transparent") +
  scale_size(breaks = c(75, 250)) +
  guides(size = guide_circles(override.aes = list(color = "blue", stroke = 0.25)))

ggplot(mtcars) +
  geom_point(aes(x = mpg, y = hp, fill = cyl, size=hp), shape=21, color = "red", stroke = 0.2) +
  scale_size(breaks = c(100, 250)) +
  guides(size = guide_circles(override.aes = list(color = "blue", stroke = 0.25)))

