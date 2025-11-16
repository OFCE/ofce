.onLoad <- function (libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "transparent",
    ofce.base_family = "Open Sans",
    ofce.marquee = FALSE,
    ofce.base_size = 12,
    sourcoise.force_exec = FALSE,
    sourcoise.prevent_exec = FALSE,
    sourcoise.cache_rep = ".data",
    sourcoise.hash = TRUE,
    sourcoise.metadata = FALSE,
    sourcoise.lapse = "never",
    sourcoise.src_in = "project",
    sourcoise.wd = "file",
    sourcoise.unfreeze = FALSE,
    sourcoise.unfreeze = FALSE,
    sourcoise.init_fn = ofce::init_qmd,
    ofce.caption.ofce = TRUE,
    ofce.caption.srcplus = NULL,
    ofce.caption.wrap = 100,
    ofce.caption.author = FALSE,
    ofce.caption.marquee_translate = FALSE,
    ofce.caption.glue = TRUE,
    ofce.caption.lang = "fr",
    ofce.init_qmd.local = FALSE,
    ofce.tabsetize.pdf = "all",
    ofce.savegraph = FALSE,
    ofce.savegraph.dir = "_sav_graph",
    ofce.output_extension = ".csv",
    ofce.output_prefix = "ofce-")

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
