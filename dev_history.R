library(devtools)
library(roxygen2)
library(tidyverse)

usethis::use_build_ignore("dev_history.r")
usethis::use_build_ignore("tests")
# usethis::use_vignette("Functions_presentation")
usethis::use_gpl3_license()
###to build and update
#### Check if ofce is installed

usethis::use_package("dplyr")
usethis::use_package("ggplot2")
usethis::use_package("utils")
usethis::use_package("colorspace")
usethis::use_package("cowplot")
usethis::use_package("quarto")
usethis::use_package("glue")
usethis::use_package("lubridate")
usethis::use_package("plyr")
usethis::use_package("tmap")
usethis::use_package("farver")
usethis::use_package("rlang")
usethis::use_package("ragg")
usethis::use_package("svglite")
usethis::use_package("ggpp")
usethis::use_package("showtext")


## Creer la doc du package
rm(list= ls())
roxygen2::roxygenise()
