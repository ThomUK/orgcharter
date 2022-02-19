oc_edges_dtf <- function(.data, nodes){

  edges <- .data %>%
    dplyr::left_join(nodes, by = c("Team Member" = "people")) %>% # join the node id's for people
    dplyr::rename(from = .data$id) %>%
    dplyr::left_join(nodes, by = c("Manager" = "people")) %>%  # join the node id's for managers
    dplyr::rename(to = .data$id) %>%
    dplyr::mutate(
      id = dplyr::row_number(),
      rel = NA # required for certain graph types
    ) %>%
    dplyr::filter(!is.na(.data$to)) %>% # remove the artificially added edges above top nodes
    dplyr::select(.data$id, .data$from, .data$to, .data$rel, .data$color, .data$penwidth)

  return(edges)

}
