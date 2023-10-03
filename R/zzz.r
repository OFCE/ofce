.onLoad <- function (libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "transparent",
    ofce.base_family = "Open Sans",
    ofce.base_size = 12
  )
  toset <- !(names(op.ofce) %in% names(op))
  if (any(toset)) options(op.ofce[toset])

  fonts_dir <- system.file("fonts", package= "ofce")
  sysfonts::font_add(
    "Open Sans",
    regular  = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-VariableFont_wdth,wght.ttf"),
    italic = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Italic-VariableFont_wdth,wght.ttf"))

  sysfonts::font_add(
    "Nunito",
    regular  = stringr::str_c(fonts_dir, "/Nunito/Nunito-VariableFont_wght.ttf"),
    italic = stringr::str_c(fonts_dir, "/Nunito/Nunito-Italic-VariableFont_wght.ttf"))

  sysfonts::font_add(
    "Roboto",
    regular  = stringr::str_c(fonts_dir, "/Roboto/Roboto-Medium.ttf"),
    italic = stringr::str_c(fonts_dir, "/Roboto/Roboto-Italic.ttf"))

  }
