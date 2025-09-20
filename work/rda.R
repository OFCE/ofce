library(ggplot2)
library(ofce)

gg <- ggplot(cars) + aes(x = speed, y = dist) + geom_point() + theme_ofce()
save(gg, file="work/gg.rda")
rm(gg)
load("work/gg.rda")
