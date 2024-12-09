% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/source_data.R
\name{clear_source_cache}
\alias{clear_source_cache}
\title{Vide le cache}
\usage{
clear_source_cache(
  what = source_data_status(root = root),
  cache_rep = NULL,
  root = NULL
)
}
\arguments{
\item{what}{(--) un tibble issu de source_data, éventuellement filtré}

\item{data_rep}{le répertoire de cache}
}
\value{
la liste des fichiers supprimés
}
\description{
Vide le cache
}
\seealso{
Other source_data: 
\code{\link{set_cache_rep}()},
\code{\link{source_data}()},
\code{\link{source_data_refresh}()},
\code{\link{source_data_status}()}
}
\concept{source_data}
