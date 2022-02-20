test_that("it creates the right number of nodes", {

  org_data <- prepare_org_data(
    tibble::tibble(
      `Team Member` = c("a", "b", "c"),
      Manager = c("d", "e", "f"),
      `Reporting Line` = c("solid", "solid", "dotted")
    )
  )

  nodes <- oc_nodes_dtf(org_data)

  expect_equal(nrow(nodes), 6)

})

test_that("it creates the right number of nodes - with dual reporting", {

  org_data <- prepare_org_data(
    tibble::tibble(
      `Team Member` = c("a", "b", "c", "c"),
      Manager = c("d", "d", "d", "e"),
      `Reporting Line` = c("solid", "solid", "solid", "dotted")
    )
  )

  nodes <- oc_nodes_dtf(org_data)

  expect_equal(nrow(nodes), 5)

})
