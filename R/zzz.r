
.onLoad <- function (libname, pkgname) {
  # Verifie que les fonts de la famille "Roboto" sont installées
  if (gdtools::font_family_exists(font_family = "Roboto") == FALSE){
    sysfonts::font_add_google("Roboto", "Roboto")
  }

  # Verifie que les fonts de la famille "Nunito" sont installées
  if (gdtools::font_family_exists(font_family = "Nunito") == FALSE){
    sysfonts::font_add_google("Nunito", "Nunito")
  }
}


.onLoad <- function (libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "transparent",
    ofce.base_family = "Open Sans"
  )
  toset <- !(names(op.ofce) %in% names(op))
  if (any(toset)) options(op.ofce[toset])
  if(!any(sysfonts::font_files()$family |> stringr::str_detect("Open Sans"))&curl::has_internet())
    sysfonts::font_add_google("Open Sans")
}
