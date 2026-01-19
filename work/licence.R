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
grid.draw(logo)

(gg <- ggplot(mtcars) +
    aes(x = disp, y = mpg) +
    geom_point() +
    labs(tag = "![](logo)")+
    facet_wrap(vars(cyl))+
    theme_ofce()+
    theme(
      plot.tag = marquee::element_marquee(angle = 0, size = 10, color = "grey25", hjust = 1, vjust = "top"),
      plot.tag.location = "plot",
      plot.tag.position = c(.995,.99),
      plot.margin = margin(r=12)))

ggiraph::girafe(ggobj = gg)


library(tidyverse)
library(marquee)
