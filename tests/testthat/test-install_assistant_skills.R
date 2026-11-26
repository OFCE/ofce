test_that("install_assistant_skills copies skills to an explicit destination", {
  dest <- fs::file_temp("posit-skills-")
  paths <- install_assistant_skills(dest = dest)

  src <- system.file("skills", package = "ofce")
  skills <- fs::path_file(fs::dir_ls(src, type = "directory"))
  expect_setequal(fs::path_file(paths), skills)
  for (skill in skills) {
    expect_true(
      fs::file_exists(fs::path(dest, skill, "SKILL.md")),
      label = paste0(dest, "/", skill, "/SKILL.md")
    )
  }
})

test_that("install_assistant_skills is idempotent with overwrite = TRUE", {
  dest <- fs::file_temp("posit-skills-")
  install_assistant_skills(dest = dest)
  expect_no_error(install_assistant_skills(dest = dest, overwrite = TRUE))
})
