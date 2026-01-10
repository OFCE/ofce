gg <- ggplot(mtcars) +
  aes(x=disp, y=mpg)+
  geom_point()+
  theme_ofce(marquee=TRUE)+
  ofce_caption(
    source = "source"
  )

gg +
  ofce_caption(
    source = NULL, ofce = FALSE, author = TRUE,
    code = NULL)
