---
title: "Un titre"
subtitle: "tout en finesse"
format: html
categories: Pôle spatial
draft: true
date: 6/23/2023
date-modified: today
editor: visual
wp: 192
author: 
  - name : Maxime Parodi
    email: maxime.parodi@sciencespo.fr
    affiliation: OFCE, Sciences Po Paris
    affiliation-url: https://www.ofce.fr
    orcid: 0009-0008-2543-5234
  - name: Xavier Timbeau
    email: xavier.timbeau@sciencespo.fr
    corresponding: true
    affiliation: OFCE, Ecole Urbaine, Sciences Po Paris
    affiliation-url: https://www.ofce.fr
    orcid: 0000-0002-6198-5953
keep-md: true
---

## Quarto

{{< fa brands github >}}

Quarto enables you to weave together content and executable code into a finished presentation. To learn more about Quarto presentations see <https://quarto.org/docs/presentations/>.

## Bullets

When you click the **Render** button a document will be generated that includes:

-   Content authored with markdown
-   Output from executable code

## Code

When you click the **Render** button a presentation will be generated that includes both content and the output of embedded code. You can embed code like this:

@fig-test


```{.r .cell-code}
library(ggplot2)
library(ofce)
graph <- list(a = ggplot(cars)+geom_point(aes(dist, speed)), b = ggplot(cars)+geom_point(aes(dist, speed)))

tabsetize(graph, girafy = FALSE, pdf = "one")
```

:::: {#fig-test} 

::: {.panel-tabset} 

### a


::: {.cell}

```{.r .cell-code}
plot 
```

::: {.cell-output-display}
![](prs_files/figure-html/4c113f9d-1-1.png){width=672}
:::
:::



### b


::: {.cell}

```{.r .cell-code}
plot 
```

::: {.cell-output-display}
![](prs_files/figure-html/4c113f9d-2-1.png){width=672}
:::
:::



:::



::::
