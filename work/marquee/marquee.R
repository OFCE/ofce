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
  xlab(NULL) +
  guides(color = guide_marquee("*Légende* : subtitle {.4 **4 cylinders**}, {.6 **6 cylinders**}, {.8 **8 cylinders**}",
                               position = "top"))+
 theme_ofce(marquee = TRUE) +
 ofce_caption(source = "blabla", note= "blala", ofce=FALSE, wrap = 0)

