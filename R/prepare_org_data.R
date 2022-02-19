#' Prepare Organisation Data
#'
#' @param .data A dataframe containing at least 3 columns ("Team Member",
#' "Manager", and "Reporting Line")
#' @param include_job_titles A boolean for whether to output print job titles
#'
#' @return A prepared dataframe suitable for plotting with the package
prepare_org_data <- function(.data, include_job_titles = TRUE){

  .data %>%
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
    dplyr::mutate(
      `Team Member` = stringr::str_wrap(.data$`Team Member`, 20),
      Manager = stringr::str_wrap(.data$Manager, 20),
      `Job Title` = stringr::str_wrap(.data$`Job Title`, 20),
      label = dplyr::case_when(
        is.na(`Job Title`) | isFALSE(include_job_titles) ~ `Team Member`,
        TRUE ~ paste0(`Team Member`, "\n\n", `Job Title`)
      )
    ) %>%
    dplyr::relocate(.data$`Team Member`, .data$Manager)

}
