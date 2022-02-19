oc_nodes_dtf <- function(.data){

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

  return(nodes)

}
