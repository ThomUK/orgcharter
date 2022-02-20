#' Create a dataframe of nodes
#'
#' @param .data A dataframe of organisation info
#' @param include_job_titles Optionally exlude job titles, even if they are available
#'
#' @return A dataframe of nodes
#'
oc_nodes_dtf <- function(.data, include_job_titles = TRUE){

  root_nodes <- oc_root_nodes(.data)

  # create a job title column if it doesn't exist
  if(!"Job Title" %in% colnames(.data)){
    .data$`Job Title` <- NA
  }

  # make a complete list of nodes, including root nodes
  nodes <- .data %>% dplyr::pull(.data$`Team Member`) %>% c(root_nodes) %>% unique() %>% tibble::as_tibble_col(column_name = "Team Member") %>%

    # join job titles back on
    dplyr::left_join(.data %>% dplyr::select(.data$`Team Member`, .data$`Job Title`), by = "Team Member") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      tm_wrap = stringr::str_wrap(.data$`Team Member`, 20),
      jt_wrap = stringr::str_wrap(.data$`Job Title`, 20),
      label = dplyr::case_when(
        is.na(.data$`Job Title`) | isFALSE(include_job_titles) ~ tm_wrap,
        TRUE ~ paste0(tm_wrap, "\n\n", jt_wrap)
      )
    ) %>%

    # add required diagrammer columns
    dplyr::mutate(
      id = as.integer(dplyr::row_number()),
      type = NA, # required for certain graph types
      shape = "rectangle",
      height = calc_box_height(.data$label),
      width = 1.5
    )

  return(nodes)

}
