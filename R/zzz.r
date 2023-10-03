.onLoad <- function (libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "transparent",
    ofce.base_family = "Open Sans",
    ofce.base_size = 12
  )
  toset <- !(names(op.ofce) %in% names(op))
  if (any(toset)) options(op.ofce[toset])
  if(curl::has_internet()) {
    if(!any(sysfonts::font_files()$family |> stringr::str_detect("Open Sans"))) {
      sysfonts::font_add_google("Open Sans")
      cli::cli_alert_info("Open Sans installé")
    }
    # # Verifie que les fonts de la famille "Roboto" sont installées
    # if (gdtools::font_family_exists(font_family = "Roboto") == FALSE){
    #   sysfonts::font_add_google("Roboto", "Roboto")
    #   cli::cli_alert_info("Roboto installé")
    # }

    # Verifie que les fonts de la famille "Nunito" sont installées
    if (gdtools::font_family_exists(font_family = "Nunito") == FALSE){
      sysfonts::font_add_google("Nunito", "Nunito")
      cli::cli_alert_info("Nunito installé")
    }
  }
}
