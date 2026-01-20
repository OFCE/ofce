library(tidyverse)
library(marquee)
library(ggtext)


by <- magick::image_read("https://mirrors.creativecommons.org/presskit/icons/by.xlarge.png") |>
  grid::rasterGrob(
    x=0.01 + 0.02 + 0.005, y = 0.5,
    width = 0.02,
    height = 0.02,
    interpolate = TRUE)
cc <- magick::image_read("https://mirrors.creativecommons.org/presskit/icons/cc.xlarge.png") |>
  grid::rasterGrob(
    x = 0.01,
    y = 0.5,
    width = 0.02,
    height = 0.02,
    interpolate = TRUE)
aut <- grid::textGrob(
    "A. Saumtally",
    x = 0.01 + 0.02 + 0.005+0.02+0.0025,
    y = 0.5,
    hjust = 0,
    gp = grid::gpar(
      fontfamily = "Open Sans",
      fontsize = 10 ,
      col = "grey25"
    )
)

logo <- grid::grobTree(cc, by, aut)
grid.newpage()
grid.draw(cc)

library(tidyverse)
library(marquee)
img <- system.file("img", "Rlogo.png", package="png")
(gg <- ggplot(mtcars) +
    aes(x = disp, y = mpg) +
    geom_point() +
    labs(tag = "![]({img}) text ![]({img})" |> glue::glue()) +
    facet_wrap(vars(cyl))+
    theme(
      plot.tag = element_marquee(angle = 270, size = 11, color = "grey25", hjust = 0, vjust = "bottom"),
      plot.tag.location = "plot",
      plot.tag.position = c(1.01,.99),
      plot.margin = margin(r=18)))
ggiraph::girafe(ggobj = gg)

(gg <- ggplot(mtcars) +
    aes(x = disp, y = mpg) +
    geom_point() +
    labs(tag = "<img src='www/ofce.png' /> text") +
    facet_wrap(vars(cyl))+
    theme(
      plot.tag = ggtext::element_markdown(angle = 270, size = 11, color = "grey25"),
      plot.tag.location = "plot",
      plot.tag.position = c(.95,.95),
      plot.margin = margin(r=18)))


