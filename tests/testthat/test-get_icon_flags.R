library(testthat)
source("../../R/get_icon_flags.R")

test_that("get_icons returns correct URLs", {
  expect_equal(get_icons("1F430"), "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg")
  expect_equal(get_icons("1F430", format = "png"), "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/72x72/1f430.png")
})

test_that("get_icons supports Pandoc markdown with width", {
  expect_equal(get_icons("1F430", out = "md", size = 50), "![](https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f430.svg){width=50}")
})

test_that("get_icons supports HTML output", {
  # via tooltip = TRUE
  expect_match(get_icons("1F430", tooltip = TRUE, size = 30), "<img src='.*' style='height:30px;width:30px;")
  # via out = "html"
  expect_match(get_icons("1F430", out = "html", size = 25), "<img src='.*' style='height:25px;width:25px;")
})

test_that("get_icons handles error and NA cases", {
  expect_error(get_icons(123), "doit être un vecteur de chaînes de caractères")
  expect_equal(get_icons(NA, out = "md"), NA_character_)
  expect_equal(get_icons(as.character(NA), out = "md"), NA_character_)
})

test_that("get_flags returns correct URLs/HTML", {
  expect_equal(get_flags("FR"), "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1eb-1f1f7.svg")
  expect_match(get_flags("FRA", tooltip = TRUE, size = 20), "<img src='.*' style='height:20px;width:20px;")
})

test_that("get_flags supports the new out parameter", {
  expect_equal(get_flags("USA", out = "md", size = 40), "![](https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/svg/1f1fa-1f1f8.svg){width=40}")
})

test_that("get_flags handles error and NA cases", {
  expect_error(get_flags(123), "doit être un vecteur de chaînes de caractères")
  expect_equal(get_flags(NA, out = "md"), NA_character_)
  expect_equal(get_flags(as.character(NA), out = "md"), NA_character_)
})
