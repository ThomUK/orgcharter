test_that("it returns explicity named root nodes", {

  nodes <- oc_root_nodes(
    tibble::tibble(
      `Team Member` = c("a", "b"),
      Manager = c(NA, NA)
    )
  )

  expect_equal(length(nodes), 2)
  expect_equal(nodes, c("a", "b"))

})

test_that("it returns unnamed root nodes", {

  nodes <- oc_root_nodes(
    tibble::tibble(
      `Team Member` = c("a", "b"),
      Manager = c("c", "d")
    )
  )

  expect_equal(length(nodes), 2)
  expect_equal(nodes, c("c", "d"))

})

test_that("it returns only unique root nodes", {

  nodes <- oc_root_nodes(
    tibble::tibble(
      `Team Member` = c("a", "b", "c", "d"),
      Manager = c("c", "c", "d", NA)
    )
  )

  expect_equal(length(nodes), 1)
  expect_equal(nodes, c("d"))

})
