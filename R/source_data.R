
#' @export
#' @importFrom sourcoise sourcoise
sourcoise::sourcoise

#' @export
#' @importFrom sourcoise sourcoise_refresh
sourcoise::sourcoise_refresh

#' @export
#' @importFrom sourcoise sourcoise_status
sourcoise::sourcoise_status

#' @export
#' @importFrom sourcoise sourcoise_clear
sourcoise::sourcoise_clear

# source_data, aliases pour compatibilité avec le changement de nom ------------------------------

#' @export
#' @rdname sourcoise
source_data <- sourcoise

#' @export
#' @rdname sourcoise_refresh
source_data_refresh <- sourcoise_refresh

#' @export
#' @rdname sourcoise_status
source_data_status <- sourcoise_status

#' @export
#' @rdname sourcoise_clear
source_data_clear <- sourcoise_clear
