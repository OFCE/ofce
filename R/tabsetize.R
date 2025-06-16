#' Tabsetize : fait un tabset à partir d'une liste
#'
#' fabrique un tabset à partir d'une liste de graphiques (a priori des ggplots). Ne s'utilise que dans un qmd ou un markdown (ca n'a pas de sens sinon).
#' On peut également passer des chaines de caractères qui sont des chemins vers des images enregistrées. Cela peut permettre de faire un rendu plus vite.
#' Les noms de la liste sont utilisés pour les noms des onglets
#' Il est important de mettre l'option `results="asis"` au chunk (ou `#| results: asis` dans le chunk)
#' Tabsetize prend en charge aussi les formats non intercatifs et affiche la liste dépliée (d'autres possibilités viendront dans le futur)
#'
#' @param list liste des graphiques
#' @param facety (ne pas utiliser)
#' @param cap TRUE par défaut, insère une caption à la figure, spécifiée comme la caption du chunk (`#| fig-cap: un titre`).
#' @param girafy TRUE par défaut, wrappe avec girafy (qui doit être défini donc dans le rinit.r)
#' @param asp aspect de ratio, mais privilégiez l'aspect ratio général (`#| fig-asp: 1.1`)
#' @param r rayon du cercle de hover pour girafy (paramètre `r` de girafy)
#'
#' @returns string inserted in markdown
#' @export
#'
tabsetize <- function(list, facety = TRUE, cap = TRUE, girafy = TRUE, asp = NULL, r = 1.5) {
  if(knitr::is_html_output()&!interactive()) {
    chunk <- knitr::opts_current$get()
    label <- knitr::opts_current$get()$label
    if(cap) {
      if(is.null(label))
        return(list)
      cat(str_c(":::: {#", label, "} \n\n" ))
    }
    ids <- 1:length(list) |> set_names(names(list))
    cat("::: {.panel-tabset} \n\n")
    purrr::iwalk(list, ~{
      cat(paste0("### ", .y," {.tabset} \n\n"))

      if(is(.x, "ggplot")) {
        id <- str_c(digest::digest(.x, algo = "crc32"), "-", ids[[.y]])
        if(!is.null(asp))
          asp_txt <- glue(", fig.asp={asp}")
        else
          asp_txt <- ""
        lbl <- glue("'{id}'")
        if(girafy) {
          plot <- girafy(.x, r=r)
          lib <- "library(ggiraph)\n"
        }
        else {
          plot <- .x
          lib <- ""}
        rendu <- knitr::knit(
          text = str_c("```{r ", lbl, asp_txt," }\n", lib, "plot \n```"),
          quiet=TRUE)
        cat(rendu, sep="\n")
      }

      if(is(.x, "character")) {
        cat("![](", .x, "){fig-align='center'}")
      }

      cat("\n\n")
    })
    cat(":::\n\n")
    if(cap) {
      cat(chunk$fig.cap)
      cat("\n\n")
      cat("::::\n\n")
    }
  } else {

    ids <- 1:length(list) |> set_names(names(list))
    label <- knitr::opts_current$get()$label

    purrr::iwalk(list, ~{
      id <- ids[[.y]]
      if(!is.null(asp))
        asp_txt <- glue(", fig.asp={asp}")
      else
        asp_txt <- ""
      lbl <- glue("'{label}-{id}'")
      if(is(.x, "ggplot")) {
        plot <- .x
        if(cap)
          figcap <- stringr::str_c("#| fig-cap: ", chunk$fig.cap, " ", .y)
        else
          figcap <- ""
        rendu <- knitr::knit(
          text = str_c("```{r ", lbl, asp_txt," }\n{figcap}\nplot \n```"),
          quiet=TRUE)
      }
      cat("\n")
      cat(rendu, sep="\n")
      cat("\n")
    })
  }
}

#' Tabsetize2 : tabset à deux étages
#'
#' fabrique un tabset de tabset à partir d'une liste de liste de graphiques (a priori des ggplots, mais cela peut être des chemins).
#'  Ne s'utilise que dans un qmd ou un markdown (ca n'a pas de sens sinon).
#' Les noms de la liste sont utilisés pour les noms des onglets.
#' Il est important de mettre l'option `results="asis"` au chunk (ou `#| results: asis` dans le chunk)
#' Tabsetize prend en charge aussi les formats non intercatifs et affiche la liste dépliée (d'autres possibilités viendront dans le futur)
#'
#' @param list liste des graphiques
#' @param facety (ne pas utiliser)
#' @param cap TRUE par défaut, insère une caption à la figure, spécifiée comme la caption du chunk (`#| fig-cap: un titre`).
#' @param girafy FALSE par défaut, wrappe avec girafy (qui doit être défini donc dans le rinit.r)
#' @param asp aspect de ratio, mais privilégiez l'aspect ratio général (`#| fig-asp: 1.1`)
#' @param r rayon du cercle de hover pour girafy (paramètre `r` de girafy)
#'
#' @returns string inserted in markdown
#' @export
#'
tabsetize2 <- function(list, facety = TRUE, cap = TRUE, girafy = FALSE, asp=NULL, r=1.5) {

  if(knitr::is_html_output()) {
    chunk <- knitr::opts_current$get()
    label <- knitr::opts_current$get()$label

    if(cap) {
      if(is.null(label))
        return(list)
      cat(str_c("::::: {#", label, "} \n\n" ))
    }

    cat(":::: {.panel-tabset} \n\n")
    purrr::iwalk(list, ~{
      cat(paste0("### ", .y," {.tabset} \n\n"))
      tabsetize(.x, facety=FALSE, cap = FALSE, girafy = girafy, asp = asp, r = r)
      cat("\n\n")
    })
    cat("::::\n\n")

    if(cap) {
      cat(chunk$fig.cap)
      cat("\n\n")
      cat(":::::\n\n")
    }
  } else {
    purrr::iwalk(list, ~{
      tabsetize(.x, facety=FALSE, cap = FALSE, girafy = girafy, asp = asp, r = r)
      cat("\n\n")
    })
  }
}
