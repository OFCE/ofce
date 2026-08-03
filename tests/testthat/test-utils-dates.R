library(testthat)
library(lubridate)
source("../../R/utils-dates.R")

test_that(".mois_nom returns French month names by default", {
  expect_equal(.mois_nom(as.Date("2026-01-15")), "janvier")
  expect_equal(.mois_nom(as.Date("2026-08-03")), "ao\u00fbt")
  expect_equal(.mois_nom(as.Date("2026-12-25")), "d\u00e9cembre")
})

test_that(".mois_nom returns English month names when locale starts with 'en'", {
  expect_equal(.mois_nom(as.Date("2026-01-15"), locale = "en_US.UTF-8"), "January")
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "en_GB.UTF-8"), "August")
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "en"), "August")
})

test_that(".mois_nom locale matching is case-insensitive", {
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "EN_US.UTF-8"), "August")
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "FR_FR.UTF-8"), "ao\u00fbt")
})

test_that(".mois_nom falls back to French for unrecognized locales", {
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "de_DE.UTF-8"), "ao\u00fbt")
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = ""), "ao\u00fbt")
})

test_that(".mois_nom abbreviates month names to 3 letters when abbr = TRUE", {
  expect_equal(.mois_nom(as.Date("2026-01-15"), abbr = TRUE), "jan")
  expect_equal(.mois_nom(as.Date("2026-08-03"), abbr = TRUE), "ao\u00fb")
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "en_US.UTF-8", abbr = TRUE), "Aug")
  expect_equal(.mois_nom(as.Date("2026-01-15"), locale = "en_US.UTF-8", abbr = TRUE), "Jan")
})

test_that(".mois_nom is vectorized over dates", {
  dates <- as.Date(c("2026-01-15", "2026-08-03", "2026-12-25"))
  expect_equal(.mois_nom(dates), c("janvier", "ao\u00fbt", "d\u00e9cembre"))
  expect_equal(.mois_nom(dates, locale = "en"), c("January", "August", "December"))
})

test_that(".mois_nom does not depend on the session's LC_TIME locale", {
  old <- Sys.getlocale("LC_TIME")
  on.exit(suppressWarnings(Sys.setlocale("LC_TIME", old)), add = TRUE)
  suppressWarnings(Sys.setlocale("LC_TIME", "C"))
  expect_equal(.mois_nom(as.Date("2026-08-03")), "ao\u00fbt")
  expect_equal(.mois_nom(as.Date("2026-08-03"), locale = "en"), "August")
})
