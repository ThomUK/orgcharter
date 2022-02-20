oc_edges_dtf <- function(.data, nodes){

  edges <- .data %>%
    dplyr::left_join(nodes, by ="Team Member") %>% # join the node id's for people
    dplyr::rename(from = .data$id) %>%
    dplyr::left_join(nodes, by = c("Manager" = "Team Member")) %>%  # join the node id's for managers
    dplyr::rename(to = .data$id) %>%
    dplyr::mutate(
      id = dplyr::row_number(),
      rel = NA # required for certain graph types
    ) %>%
    dplyr::mutate(color = dplyr::case_when(
      tolower(`Reporting Line`) == "solid" ~ "black",
      tolower(`Reporting Line`) == "dotted" ~ "grey",
      TRUE ~ "orange"
    )) %>%
    dplyr::mutate(
      penwidth = dplyr::case_when(
        `Reporting Line` == "Solid" ~ 2, # double width
        `Reporting Line` == "Dotted" ~ 1, # single width
        TRUE ~ 1
      )
    ) %>%

    dplyr::filter(!is.na(.data$to)) %>% # remove the artificially added edges above top nodes
    dplyr::select(.data$id, .data$from, .data$to, .data$rel, .data$color, .data$penwidth)

  return(edges)

}
