library(ggplot2)
library(marquee)

ggplot(mtcars) +
  aes(x = mpg, y = drat, color = factor(cyl)) +
  geom_point() +
  labs(subtitle = "A subtitle", title = "A title") +
  theme_ofce(marquee = TRUE)
ggplot(mtcars) +
  aes(x = mpg, y = drat, color = factor(cyl)) +
  geom_point() +
  # labs(title = "title", subtitle = "kd") +
  guides(color = guide_marquee("subtitle {.4 4 cylinders}, {.6 6 cylinders}, {.8 8 cylinders}",
                               position = "bottom"))+
 theme_ofce(marquee = TRUE)
