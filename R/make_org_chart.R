#' Make Org Chart
#'
#' @param .data A dataframe prepared by prepare_.data()
#'
#' @return A grViz object suitable for plotting
#' @export
make_org_chart <- function(.data){

  nodes <- data.frame(
    people = unique(c(.data$`Team Member`, .data$Manager)) # de-duplicated list of all names
    ) %>%

    # join labels in
    dplyr::left_join(.data %>% dplyr::select(.data$`Team Member`, .data$label) %>% unique(), by = c("people" = "Team Member")) %>%

    dplyr::mutate(
      id = as.integer(dplyr::row_number()),
      type = NA, # required for certain graph types
      shape = "rectangle",
      height = calc_box_height(.data$label),
      width = 1.5
    ) %>%
    dplyr::filter(!is.na(.data$people)) %>% #remove the node at the top of the tree (the recursive manager's manager)
    dplyr::select(.data$id, .data$type, .data$people, .data$label, .data$shape, .data$height, .data$width)

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

  g <- DiagrammeR::create_graph(
    nodes_df = nodes,
    edges_df = edges,
    attr_theme = "bt",

  ) %>%
    DiagrammeR::render_graph()

  return(g)

}
