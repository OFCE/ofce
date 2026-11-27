#' Installe les skills embarqués dans le package
#'
#' Copie les skills livrés avec le package (`inst/skills/`) dans le dossier où
#' l'assistant IA les charge automatiquement. Ils sont actifs dans les
#' nouvelles sessions : toutes (dossier utilisateur) ou celles du projet en
#' cours (dossier projet). Le format (un dossier `SKILL.md` avec frontmatter
#' `name`/`description`) est la spécification Agent Skills, commune à Posit
#' Assistant et Claude Code.
#'
#' @param to Cible de l'installation : `"user"` (défaut) copie vers
#'   `~/.posit/assistant/skills/`, `"project"` vers
#'   `./.posit/assistant/skills/` du répertoire de travail, `"claude"` vers
#'   `./.claude/skills/` (Claude Code, dossier projet) et `"claude_user"`
#'   vers `~/.claude/skills/` (Claude Code, toutes les sessions).
#' @param overwrite Remplace un skill déjà installé de même nom (défaut
#'   `TRUE`).
#' @param dest Destination explicite (chemin complet). Prioritaire sur `to` ;
#'   sert principalement aux tests.
#'
#' @return Invisible : chemins des skills installés.
#' @export
#'
#' @examples
#' \dontrun{
#' # tous les projets de l'utilisateur (Posit Assistant) :
#' ofce::install_assistant_skills()
#' # le projet en cours seulement (à commiter) :
#' ofce::install_assistant_skills(to = "project")
#' # pour Claude Code, dans le projet :
#' ofce::install_assistant_skills(to = "claude")
#' }
install_assistant_skills <- function(
  to = c("user", "project", "claude", "claude_user"),
  overwrite = TRUE,
  dest = NULL
) {
  src <- system.file("skills", package = "ofce")
  if (!nzchar(src)) {
    cli::cli_abort("aucun dossier de skills dans le package installé.")
  }
  skills <- fs::dir_ls(src, type = "directory")
  if (length(skills) == 0) {
    cli::cli_abort("le dossier de skills du package est vide.")
  }
  if (is.null(dest)) {
    to <- match.arg(to)
    dest <- switch(
      to,
      user = fs::path(fs::path_home(), ".posit", "assistant", "skills"),
      project = fs::path(".posit", "assistant", "skills"),
      claude = fs::path(".claude", "skills"),
      claude_user = fs::path(fs::path_home(), ".claude", "skills")
    )
  }
  dest <- fs::as_fs_path(dest)
  fs::dir_create(dest)
  for (skill in skills) {
    target <- fs::path(dest, fs::path_file(skill))
    fs::dir_copy(skill, target, overwrite = overwrite)
    cli::cli_alert_success(
      "skill {.val {fs::path_file(skill)}} installé dans {.path {dest}}"
    )
  }
  invisible(fs::path(dest, fs::path_file(skills)))
}
