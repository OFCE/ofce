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
    regular  = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Regular.ttf"),
    italic = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Italic.ttf"),
    bold = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Bold.ttf"),
    bolditalic = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-BoldItalic.ttf")
  )

  sysfonts::font_add(
    "Nunito",
    regular  = stringr::str_c(fonts_dir, "/Nunito/Nunito-Regular.ttf"),
    italic = stringr::str_c(fonts_dir, "/Nunito/Nunito-Italic.ttf"),
    bold = stringr::str_c(fonts_dir, "/Nunito/Nunito-Bold.ttf"),
    bolditalic = stringr::str_c(fonts_dir, "/Nunito/Nunito-BoldItalic.ttf"))

  sysfonts::font_add(
    "Roboto",
    regular  = stringr::str_c(fonts_dir, "/Roboto/Roboto-Regular.ttf"),
    italic = stringr::str_c(fonts_dir, "/Roboto/Roboto-Italic.ttf"),
    bold = stringr::str_c(fonts_dir, "/Roboto/Roboto-Bold.ttf"),
    bolditalic = stringr::str_c(fonts_dir, "/Roboto/Roboto-BoldItalic.ttf"))

}
