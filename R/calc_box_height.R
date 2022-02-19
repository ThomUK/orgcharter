#' Calculate height of box
#'
#' @param label The text to fit into the box, including line returns
#'
#' @return Numeric.  The height of the box
#'
calc_box_height <- function(label){

  # base height of 0.6

  no_of_lines <- stringr::str_count(label, "\n")


  return(0.4 + 0.15 * no_of_lines)

}
