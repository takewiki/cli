
context("cli progress bars")

test_that("progress bars", {
  x <- 100

  withr::with_options(
    list(cli.width = 40, crayon.enabled = FALSE, crayon.colors = 1), {
    out <- capt0({
      clix$verbatim("so far so good: {x}")
      bar <- clix$progress_bar(total = 5, force = TRUE, show_after = 0)
      bar$tick()
      bar$tick()
      clix$verbatim("still very good: {x}!")
      bar$tick()
      clix$text(strrep("1234567890 ", 6))
      bar$tick()
      bar$tick()
      clix$verbatim("aaaaand we are done")
    })
  })

  out <- strsplit(out, "\n", fixed = TRUE)[[1]]

  exp <- c(
    "so far so good: 100",
    paste0("\r[======>--------------------------]  20%",
           "\r[============>--------------------]  40%",
           "\r                                        ",
           "\rstill very good: 100!"),
    paste0("[============>--------------------]  40%",
           "\r[===================>-------------]  60%",
           "\r                                        ",
           "\r1234567890 1234567890 1234567890"),
    "1234567890 1234567890 1234567890",
    paste0("[===================>-------------]  60%",
           "\r[=========================>-------]  80%",
           "\r[=================================] 100%",
           "\r                                        ",
           "\raaaaand we are done")
  )

  expect_equal(out, exp)
})
