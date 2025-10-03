.onLoad <- function (libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "transparent",
    ofce.base_family = "Open Sans",
    ofce.marquee = FALSE,
    ofce.base_size = 12,
    ofce.source_data.force_exec = FALSE,
    ofce.source_data.prevent_exec = FALSE,
    ofce.source_data.cache_rep = ".data",
    ofce.source_data.hash = TRUE,
    ofce.source_data.metadata = FALSE,
    ofce.source_data.lapse = "never",
    ofce.source_data.src_in = "project",
    ofce.source_data.wd = "file",
    ofce.source_data.unfreeze = FALSE,
    ofce.caption.ofce = TRUE,
    ofce.caption.srcplus = NULL,
    ofce.caption.wrap = 100,
    ofce.caption.author = FALSE,
    ofce.caption.marquee_translate = FALSE,
    ofce.caption.glue = TRUE,
    ofce.caption.lang = "fr",
    ofce.init_qmd.local = FALSE,
    ofce.tabsetize.pdf = "all")

  toset <- !(names(op.ofce) %in% names(op))
  if (any(toset)) options(op.ofce[toset])
  library(marquee)
  fonts_dir <- system.file("fonts", package= "ofce")
  sysfonts::font_add(
    "Open Sans",
    regular  = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Regular.ttf"),
    italic = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Italic.ttf"),
    bold = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-Bold.ttf"),
    bolditalic = stringr::str_c(fonts_dir, "/OpenSans/OpenSans-BoldItalic.ttf")
  )

  # sysfonts::font_add(
  #   "Nunito",
  #   regular  = stringr::str_c(fonts_dir, "/Nunito/Nunito-Regular.ttf"),
  #   italic = stringr::str_c(fonts_dir, "/Nunito/Nunito-Italic.ttf"),
  #   bold = stringr::str_c(fonts_dir, "/Nunito/Nunito-Bold.ttf"),
  #   bolditalic = stringr::str_c(fonts_dir, "/Nunito/Nunito-BoldItalic.ttf"))
  #
  # sysfonts::font_add(
  #   "Roboto",
  #   regular  = stringr::str_c(fonts_dir, "/Roboto/Roboto-Regular.ttf"),
  #   italic = stringr::str_c(fonts_dir, "/Roboto/Roboto-Italic.ttf"),
  #   bold = stringr::str_c(fonts_dir, "/Roboto/Roboto-Bold.ttf"),
  #   bolditalic = stringr::str_c(fonts_dir, "/Roboto/Roboto-BoldItalic.ttf"))

}
