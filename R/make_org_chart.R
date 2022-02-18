#' Make Org Chart
#'
#' @param org_data A dataframe prepared by prepare_org_data()
#' @param include_job_titles A boolean for whether to output print job titles
#'
#' @return A grViz object suitable for plotting
#' @export
make_org_chart <- function(org_data, include_job_titles = TRUE){

  nodes <- data.frame(
    people = unique(c(org_data$`Team Member`, org_data$Manager)) # de-duplicated list of all names
    ) %>%

    # join job titles in
    dplyr::left_join(org_data %>% dplyr::select(`Team Member`, `Job Title`, label) %>% unique(), by = c("people" = "Team Member")) %>%

    dplyr::mutate(
      id = as.integer(dplyr::row_number()),
      type = NA, # required for certain graph types
      shape = "rectangle",
      height = 0.5,
      width = 1.4
    ) %>%
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
    dplyr::select(id, from, to, rel, color, penwidth)

  g <- DiagrammeR::create_graph(
    nodes_df = nodes,
    edges_df = edges,
    attr_theme = "bt",

  ) %>%
    DiagrammeR::render_graph()

  return(g)

}
