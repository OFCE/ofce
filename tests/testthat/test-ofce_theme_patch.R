test_that("ofce_theme_patch falls back to the global theme element", {
  old_theme <- ggplot2::theme_get()
  on.exit(ggplot2::theme_set(old_theme), add = TRUE)

  # Thème global dont axis.text.x est un element_marquee (cf. theme_ofce(marquee = TRUE))
  ggplot2::theme_set(
    ggplot2::theme_grey() +
      ggplot2::theme(axis.text.x = marquee::element_marquee(hjust = 0.5))
  )

  p <- ggplot2::ggplot(
    data.frame(time = Sys.Date() + 0:2, y = 1:3),
    ggplot2::aes(time, y)
  ) +
    ggplot2::geom_point() +
    ofce_theme_patch("axis.text.x", hjust = 0)

  # Le patch doit modifier l'élément du thème global sans changer sa classe
  expect_true(inherits(p$theme$axis.text.x, "element_marquee"))
  expect_identical(p$theme$axis.text.x$hjust, 0)
  # La fusion des thèmes (plot vs global) ne doit pas échouer au build
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("ofce_theme_patch skips element_blank and warns when the element is nowhere defined", {
  old_theme <- ggplot2::theme_get()
  on.exit(ggplot2::theme_set(old_theme), add = TRUE)

  # axis.text.x = element_blank dans le thème global : rien à patcher
  ggplot2::theme_set(
    ggplot2::theme_grey() +
      ggplot2::theme(axis.text.x = ggplot2::element_blank())
  )

  p0 <- ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x, y)) +
    ggplot2::geom_point()
  expect_warning(p0 + ofce_theme_patch("axis.text.x", hjust = 0))
  p <- suppressWarnings(p0 + ofce_theme_patch("axis.text.x", hjust = 0))

  expect_true(inherits(p$theme$axis.text.x, "element_text"))
  expect_identical(p$theme$axis.text.x$hjust, 0)
})

test_that("scale_ofce_date builds with a marquee global theme", {
  old_theme <- ggplot2::theme_get()
  on.exit(ggplot2::theme_set(old_theme), add = TRUE)

  ggplot2::theme_set(
    ggplot2::theme_grey() +
      ggplot2::theme(axis.text.x = marquee::element_marquee(hjust = 0.5))
  )

  p <- ggplot2::ggplot(
    data.frame(
      time = seq(as.Date("2000-01-01"), as.Date("2024-01-01"), by = "year"),
      y = 1:25
    ),
    ggplot2::aes(time, y)
  ) +
    ggplot2::geom_point() +
    scale_ofce_date(date_breaks = "2 years")

  expect_no_error(ggplot2::ggplot_build(p))
})
