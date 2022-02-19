#' Make Org Chart
#'
#' @param org_data A dataframe prepared by prepare_org_data()
#'
#' @return A grViz object suitable for plotting
#' @export
make_org_chart <- function(org_data){

  nodes <- data.frame(
    people = unique(c(org_data$`Team Member`, org_data$Manager)) # de-duplicated list of all names
    ) %>%

    # join labels in
    dplyr::left_join(org_data %>% dplyr::select(`Team Member`, label) %>% unique(), by = c("people" = "Team Member")) %>%

    dplyr::mutate(
      id = as.integer(dplyr::row_number()),
      type = NA, # required for certain graph types
      shape = "rectangle",
      height = calc_box_height(label),
      width = 1.5
    ) %>%
    dplyr::filter(!is.na(people)) %>% #remove the node at the top of the tree (the recursive manager's manager)
    dplyr::select(id, type, people, label, shape, height, width)

  edges <- org_data %>%
    dplyr::left_join(nodes, by = c("Team Member" = "people")) %>% # join the node id's for people
    dplyr::rename(from = id) %>%
    dplyr::left_join(nodes, by = c("Manager" = "people")) %>%  # join the node id's for managers
    dplyr::rename(to = id) %>%
    dplyr::mutate(
      id = dplyr::row_number(),
      rel = NA # required for certain graph types
    ) %>%
    dplyr::filter(!is.na(to)) %>% # remove the artificially added edges above top nodes
    dplyr::select(id, from, to, rel, color, penwidth)

  g <- DiagrammeR::create_graph(
    nodes_df = nodes,
    edges_df = edges,
    attr_theme = "bt",

  ) %>%
    DiagrammeR::render_graph()

  return(g)

}
