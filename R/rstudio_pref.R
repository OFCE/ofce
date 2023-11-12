#' Reset RStudio prefs
#'
#' Principalement, pas d'enregistrement de l'environnement, pipe natif, ragg en backend graphique
#'
#' @param theme Theme à utiliser (défaut "iPlastic")
#' @param right_console Met la console à droite (défaut TRUE)
#' @return NULL
#' @importFrom rstudioapi writeRStudioPreference
#' @export
#'
#' @examples
#' if(interactive()) setup_RStudio()
#'
setup_RStudio <- function(theme="iPlastic", right_console = TRUE) {
  rstudioapi::writeRStudioPreference("jobs_tab_visibility", "shown")
  rstudioapi::writeRStudioPreference("initial_working_directory", "~")
  rstudioapi::writeRStudioPreference("posix_terminal_shell", "bash")
  rstudioapi::writeRStudioPreference("save_workspace", "never")
  rstudioapi::writeRStudioPreference("load_workspace", FALSE)
  rstudioapi::writeRStudioPreference("insert_native_pipe_operator", TRUE)
  rstudioapi::writeRStudioPreference("highlight_selected_line", TRUE)
  rstudioapi::writeRStudioPreference("show_margin", FALSE)
  rstudioapi::writeRStudioPreference("highlight_r_function_calls", TRUE)
  rstudioapi::writeRStudioPreference("rainbow_parentheses", TRUE)
  rstudioapi::writeRStudioPreference("spelling_dictionary_language", "fr_FR")
  rstudioapi::writeRStudioPreference("save_files_before_build", TRUE)
  rstudioapi::writeRStudioPreference("shiny_viewer_type", "pane")
  rstudioapi::writeRStudioPreference("visual_markdown_editing_font_size_points", 12L)
  rstudioapi::writeRStudioPreference("graphics_backend", "ragg")
  rstudioapi::writeRStudioPreference("doc_outline_show", "sections_and_chunks")
  rstudioapi::writeRStudioPreference("visual_markdown_editing_max_content_width", 900L)
  rstudioapi::writeRStudioPreference("default_project_location", "~")
  rstudioapi::writeRStudioPreference("syntax_color_console", TRUE)
  rstudioapi::writeRStudioPreference("rmd_viewer_type", "pane")
  rstudioapi::writeRStudioPreference("load_workspace", FALSE )
  rstudioapi::applyTheme(theme)
  if(right_console) {
    rstudioapi::writeRStudioPreference(
    "panes",
    list(quadrants=c("Source","TabSet1","Console","TabSet2"),
         TabSet1=c("Environment", "History","Connections","Build","Tutorial"),
         TabSet2=c("Files", "Plots", "Packages", "Help", "Viewer", "Presentation"),
         hiddenTabSet=c("TabSet1"),
         console_left_on_top= FALSE,
         console_right_on_top= TRUE,
         additional_source_columns= 0L))
  }
}
