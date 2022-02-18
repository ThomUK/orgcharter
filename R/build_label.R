#' Build Label
#'
#' @param name The person's name
#' @param job The person's job title
#'
#' @return Character vector of length 1
#'
build_label <- function(name, job){

  return(paste0(name, "\n\n", job))

}
