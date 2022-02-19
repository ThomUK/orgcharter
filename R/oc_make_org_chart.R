#' Prepare Organisation Data
#'
#' @param .data A dataframe containing at least 3 columns ("Team Member",
#' "Manager", and "Reporting Line")
#' @param include_job_titles A boolean for whether to output print job titles

#' @return A grViz object suitable for plotting
#' @export
oc_make_org_chart <- function(.data, include_job_titles = TRUE){

  org_data <- prepare_org_data(.data, include_job_titles)

  nodes <- oc_nodes_dtf(org_data)

  edges <- oc_edges_dtf(org_data, nodes)

  g <- DiagrammeR::create_graph(
    nodes_df = nodes,
    edges_df = edges,
    attr_theme = "bt",

  ) %>%
    DiagrammeR::render_graph()

  return(g)
}
