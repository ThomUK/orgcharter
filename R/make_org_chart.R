#' Make Org Chart
#'
#' @param .data A dataframe prepared by prepare_.data()
#'
#' @return A grViz object suitable for plotting
make_org_chart <- function(.data){

  nodes <- oc_nodes_dtf(.data)

  edges <- oc_edges_dtf(.data, nodes)

  g <- DiagrammeR::create_graph(
    nodes_df = nodes,
    edges_df = edges,
    attr_theme = "bt",

  ) %>%
    DiagrammeR::render_graph()

  return(g)

}
