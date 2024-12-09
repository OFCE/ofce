% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/source_data.R
\name{source_data}
\alias{source_data}
\title{source_data : exécute le code et cache les données}
\usage{
source_data(
  path,
  args = list(),
  hash = getOption("ofce.source_data.hash"),
  track = list(),
  lapse = getOption("ofce.source_data.lapse"),
  force_exec = getOption("ofce.source_data.force_exec"),
  prevent_exec = getOption("ofce.source_data.prevent_exec"),
  metadata = getOption("ofce.source_data.metadata"),
  wd = getOption("ofce.source_data.wd"),
  src_in = getOption("ofce.source_data.src_in"),
  exec_wd = NULL,
  cache_rep = NULL,
  root = NULL,
  quiet = TRUE,
  nocache = FALSE
)
}
\arguments{
\item{path}{(character) le chemin vers le code à exécuter (sans extension .r ou .R ou avec au choix), ce chemin doit être relatif au projet (voir détails)}

\item{args}{(list) une liste d'arguments que l'on peut utliser dans source (args$xxx)}

\item{hash}{(boléen) Si TRUE (défaut) un changement dans le code déclenche son exécution}

\item{track}{(list) une liste de fichiers (suivant la même règle que src pour les trouver) qui déclenchent l'exécution.}

\item{lapse}{(character) peut être "never" (défaut) "x hours", "x days", "x weeks", "x months", "x quarters", "x years"}

\item{force_exec}{(boléen) Si TRUE alors le code est exécuté ($FORCE_EXEC par défaut)}

\item{prevent_exec}{(boléen) Si TRUE alors le code n'est pas exécuté ($PREVENT_EXEC par défaut), ce flag est prioritaire sur les autres, sauf si il n'y a pas de données en cache}

\item{metadata}{(boléen) Si TRUE (FALSE par défaut) la fonction retourne une liste avec des métadonnées et le champ data qui contient les données elles même}

\item{wd}{(character) si 'project' assure que le wd est le root du project, si 'file' (défaut) c'est le fichier sourcé qui est le wd, si "qmd", c'est le qmd qui appelle}

\item{exec_wd}{(character) NULL par défaut sauf usage particulier}

\item{cache_rep}{(character) défaut .data sauf usage particulier}

\item{quiet}{(boléen) pas de messages}

\item{nocache}{(boléen) n'enregistre pas le cache même si nécessaire}

\item{scr_in}{(character) si "project" cherche le source dans le projet puis les sous dossiers, si "file" cherche dans le dossier du qmd (ou le wd). Dans ce cas, les données sont stockées dans le dossier en question.}
}
\value{
data (list ou ce que le code retourne)
}
\description{
Cette fonction s'utilise presque comme source et permet d'en accélérer l'exécution par le cache des données.
}
\details{
Le fichier source est donné en entrée. Le chemin est relatif au projet, mais si il n'est pas trouvé dans le projet, il est cherché en partant de la racine.
Si le paramètre \code{src_in} est mis à \code{"file"}, alors le source est cherché à partir du qmd (ou du wd si il n'y pas encore de qmd) et les données sont stockées à ce niveau.
Ce cas correspond donc à des dossiers qui ne partagent pas de code (le blog de l'OFCE), alors que l'autre cas correspond à des codes pouvant être partagés (la prévision)

Le code est exécuté (dans un environnement local) et le résultat est mis en cache. Il est important que le code se termine par un return(les_donnees).
Si return() n'est pas présent dans le code, il n'est pas exécuté et un message d'erreur est envoyé ("NULL" est retourné).
le code est exécuté avec un contrôle d'erreur, donc si il bloque, "NULL" est renvoyé, mais sans erreur ni arrêt.
les appels suivants seront plus rapides et sans erreur (sauf si l'erreur n'est pas corrigée).

Une modification du code est détectée et déclenche l'éxécution automatiquement.

Suivant le paramètre lapse on peut déclencher une exécution périodique.
Par exemple, pour ne pas rater une MAJ, on peut mettre \code{lapse = "1 day"} ou \code{"day"} et une fois par jour le code sera exécuté.
Cela permet d'éviter une exécution à chaque rendu, mais permet de vérifier fréquemment la MAJ.
On peut spécifier l'intervalle en heures (\code{hours}), en jours (\code{days}), en semaines (\code{weeks}), en mois (\code{months}) ou en trimestres (\code{quarters}).

On peut bloquer l'exécution en renseignant la variable d'environnement \code{PREVENT_EXEC} par \code{Sys.setenv(PREVENT_EXEC = "TRUE")} ou dans \code{.Renviron}.
Ce blocage est prioritaire sur tous les autres critères (sauf en cas d'absence de cache ou l'exécution est essayée).

Des métadonnées peuvent être renvoyées (paramètre \code{metadata}) avec la date de la dernière exécution (\verb{$date}), le temps d'exécution (\verb{$timing}),
la taille des données (\verb{$size}), le chemin de la source (\verb{$where}), le hash du source (\verb{$hash_src}) et bien sûr les données (\verb{$data}).
Cela peut servir pour renseigner un graphique.

Les valeurs par défaut peuvent être modifiées simplement par \code{options(ofce.source_data.hash = FALSE)} par exemple et persistent pour une session.
Typiquement cela peut être mis dans rinit.r (et donc être exécuté par \code{ofce::init_qmd()}) et cela sera l'option par défaut du projet.

Le paramètre \code{wd} perment de spécifier le répertoire d'exécution du source.
Si il est mis à \code{"file"}, les appels à l'intérieur du code source, comme par exemple un save ou un load seront compris dans le répertoire où se trouve le fichier source.
L'intérêt est que le code peut avoir des éléments persistants, locaux
L'alternative est d'utiliser \code{wd="project"} auquel cas, le répertoire d'exécution sera independant de l'endroit où est appelé le code source.
Les éléments persistants peuvent alors être dasn un endroit commun et le code peut appeler des éléments persistants d'autres codes sources.
En le mettant à \code{qmd}l'exécution part du fichier qmd, ce qui est le comportement standard de \code{quarto}.
Toute autre valeur pour wd laisse le working directory inchnagé et donc dépendant du contexte d'exécution. Pour ceux qui aiment l'incertitude.

En donnant des fichers à suivre par \code{track}, on peut déclencher l'exécution du source lorsque ces fichiers sont modifiés, c'est utile pour des fichiers sources sous excel (ou csv).

\code{unfreeze} permet d'invalider le cache de quarto et de déclencher l'exécution du qmd pour mettre à jour la publication (et pas seulement les données en cache).
}
\seealso{
Other source_data: 
\code{\link{clear_source_cache}()},
\code{\link{set_cache_rep}()},
\code{\link{source_data_refresh}()},
\code{\link{source_data_status}()}
}
\concept{source_data}
