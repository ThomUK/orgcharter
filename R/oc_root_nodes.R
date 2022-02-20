#' Find the root nodes, which are nodes with no manager above them
#'
#' @param .data A dataframe containing organisation details
#'
#' @return A character vector of names for the root nodes
#'
oc_root_nodes <- function(.data){

  # some root nodes are explicitly names (eg. to add a job title)
  named_root_nodes <- .data %>%
    dplyr::select(`Team Member`, Manager) %>%
    unique() %>%
    dplyr::filter(is.na(Manager)) %>%
    dplyr::pull(`Team Member`)

  # some root nodes are not explicitly named, and are names that only appear
  # in the manager column
  tm <- .data %>% dplyr::pull(`Team Member`) %>% unique()
  mgr <- .data %>% dplyr::pull(Manager) %>% unique()
  unnamed_root_nodes <- dplyr::setdiff(mgr, tm)

  # root nodes are the combination of both
  root_nodes <- c(unnamed_root_nodes, named_root_nodes)
  root_nodes <- root_nodes[ !is.na( root_nodes ) ]

  return(root_nodes)

}
