.onLoad <- function(libname, pkgname) {
  op <- options()
  op.ofce <- list(
    ofce.background_color = "gray97"
  )
  toset <- !(names(op.ofce) %in% names(op))
  if (any(toset)) options(op.ofce[toset])}
