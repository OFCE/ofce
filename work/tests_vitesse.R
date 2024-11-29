## test vitesse rinit versions
microbenchmark::microbenchmark(
  version_nouvelle = source("~/Work/ofce/inst/rinit.r") ,
  version_ancienne = source("~/Work/ofce/inst/rinit_og_version.r") ,
  times = 100)

