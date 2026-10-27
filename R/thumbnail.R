# Vignette automatique des posts (image du menu).
#
# `girafy()` (cf. _utils/rinit.r) appelle `thumbnail_save(plot)` : si le label
# du chunk courant est égal au champ `image:` du YAML (extension exclue), par
# ex. label `fig-plot` et `image: fig-plot.png`, le ggplot est sauvé en PNG
# 780 x 480 (sans caption) dans le dossier du document.
#
# Une image qui n'est pas un label de chunk (fournie par l'auteur) n'est donc
# jamais écrasée.

#' Supprime le caption (ofce_caption) d'un ggplot ou d'un patchwork
thumbnail_transform <- function(plot) {
  if (inherits(plot, "patchwork"))
    return((plot & ggplot2::labs(caption = NULL)) +
             patchwork::plot_annotation(caption = NULL))
  plot + ggplot2::labs(caption = NULL)
}

#' Enregistre la vignette d'un ggplot en PNG
save_thumbnail <- function(plot, file = "thumbnail.png",
                           width = 780, height = 480, dpi = 92, bg = "white",
                           scale = 2) {
  # showtext_auto() (rinit) dégrade l'espacement des mots avec ragg
  # (marquee/systemfonts rendent bien les polices) : on le coupe le temps
  # de la sauvegarde, puis on le réactive (état fixé par rinit).
  if (isNamespaceLoaded("showtext")) {
    showtext::showtext_auto(FALSE)
    on.exit(showtext::showtext_auto(TRUE), add = TRUE)
  }
  extension <- fs::path_ext(file)
  device <- ragg::agg_png
  if(extension%in%c("jpg", "jpeg"))
    device <-  ragg::agg_jpeg
  if(extension=="svg")
    device <- svglite::svglite
  ggplot2::ggsave(
    filename = file,
    plot = thumbnail_transform(plot),
    device = device,
    width = width * scale, height = height * scale, units = "px",
    dpi = dpi * scale, bg = bg)
  invisible(file)
}

#' Sauve `plot` comme vignette si le chunk courant correspond à `image:`
thumbnail_save <- function(plot) {
  doc_dir <- Sys.getenv("QUARTO_DOCUMENT_PATH")
  label <- knitr::opts_current$get("label")
  image <- rmarkdown::metadata$image
  if (!isTRUE(knitr::is_html_output()) || doc_dir == "" ||
      is.null(label) || !is.character(image) || length(image) != 1 ||
      image == "")
    return(invisible(NULL))
  if (!identical(fs::path_ext_remove(image), label))
    return(invisible(NULL))
  tryCatch(
    save_thumbnail(plot, fs::path_join(c(doc_dir, image))),
    error = function(e)
      warning("Vignette non générée : ", conditionMessage(e), call. = FALSE))
}
