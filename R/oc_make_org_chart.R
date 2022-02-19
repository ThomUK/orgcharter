#' Prepare Organisation Data
#'
#' @param .data A dataframe containing at least 3 columns ("Team Member",
#' "Manager", and "Reporting Line")
#' @param include_job_titles A boolean for whether to output print job titles

#' @return A grViz object suitable for plotting
#' @export
oc_make_org_chart <- function(.data, include_job_titles = TRUE){

  prepare_org_data(.data, include_job_titles) %>%
    make_org_chart()

}
