.onLoad <- function(libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "transparent",
    ofce.base_family = "sans"
  )
  toset <- !(names(op.ofce) %in% names(op))
  if (any(toset)) options(op.ofce[toset])}
