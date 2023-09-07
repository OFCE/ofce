#' Reset RStudio prefs
#'
#' @return NULL
#' @importFrom rstudioapi writeRStudioPreference
#' @export
#'
#' @examples
#' setOFCERStudio()
#' 
setOFCERStudio <- function() {
  writeRStudioPreference("jobs_tab_visibility", "shown")
  writeRStudioPreference("initial_working_directory", "~")
  writeRStudioPreference("posix_terminal_shell", "bash")
  writeRStudioPreference("save_workspace", "never")
  writeRStudioPreference("load_workspace", FALSE)
  writeRStudioPreference("editor_theme", "iPlastic")
  writeRStudioPreference("insert_native_pipe_operator", TRUE)
  writeRStudioPreference("highlight_selected_line", TRUE)
  writeRStudioPreference("show_margin", FALSE)
  writeRStudioPreference("highlight_r_function_calls", TRUE)
  writeRStudioPreference("rainbow_parentheses", TRUE)
  writeRStudioPreference("spelling_dictionary_language", "fr_FR")
  writeRStudioPreference("save_files_before_build", TRUE)
  writeRStudioPreference("shiny_viewer_type", "pane")
  writeRStudioPreference("visual_markdown_editing_font_size_points", 12)
  writeRStudioPreference("graphics_backend", "ragg")
  writeRStudioPreference("doc_outline_show", "sections_and_chunks")
  writeRStudioPreference("visual_markdown_editing_max_content_width", 1200)
  writeRStudioPreference("default_project_location", "~")
  writeRStudioPreference("syntax_color_console", TRUE)
  writeRStudioPreference("rmd_viewer_type", "pane")
  writeRStudioPreference("load_workspace", FALSE )
}