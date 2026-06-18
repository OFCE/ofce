# theme OFCE

Applique le theme ofce compatible avec la norme de la Revue de l'OFCE
d'autres éléments de la norme comme les couleurs, l'allure générale du
graphique sont à introduire par ailleurs

## Usage

``` r
theme_ofce(
  base_size = getOption("ofce.base_size"),
  base_family = getOption("ofce.base_family"),
  marquee = getOption("ofce.marquee"),
  ...
)
```

## Arguments

- base_size:

  double(1) Taille des éléments texte du thème. Peut être donné
  globalement par options(ofce.base_size=12).

- base_family:

  character(1) string, police de charactère du thème (globalement et
  défaut options(ofce.base_family="Open Sans"))

- marquee:

  (boléen) utilise marquee pour la plupart des textes dans un plot

- ...:

  Arguments passed on to
  [`ggplot2::theme`](https://ggplot2.tidyverse.org/reference/theme.html)

  `line`

  :   all line elements
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html))

  `rect`

  :   all rectangular elements
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html))

  `text`

  :   all text elements
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html))

  `title`

  :   all title elements: plot, axes, legends
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `text`)

  `point`

  :   all point elements
      ([`element_point()`](https://ggplot2.tidyverse.org/reference/element.html))

  `polygon`

  :   all polygon elements
      ([`element_polygon()`](https://ggplot2.tidyverse.org/reference/element.html))

  `geom`

  :   defaults for geoms
      ([`element_geom()`](https://ggplot2.tidyverse.org/reference/element.html))

  `spacing`

  :   all spacings ([`unit()`](https://rdrr.io/r/grid/unit.html))

  `margins`

  :   all margins
      ([`margin()`](https://ggplot2.tidyverse.org/reference/element.html))

  `aspect.ratio`

  :   aspect ratio of the panel

  `axis.title,axis.title.x,axis.title.y,axis.title.x.top,axis.title.x.bottom,axis.title.y.left,axis.title.y.right`

  :   labels of axes
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html)).
      Specify all axes' labels (`axis.title`), labels by plane (using
      `axis.title.x` or `axis.title.y`), or individually for each axis
      (using `axis.title.x.bottom`, `axis.title.x.top`,
      `axis.title.y.left`, `axis.title.y.right`). `axis.title.*.*`
      inherits from `axis.title.*` which inherits from `axis.title`,
      which in turn inherits from `text`

  `axis.text,axis.text.x,axis.text.y,axis.text.x.top,axis.text.x.bottom,axis.text.y.left,axis.text.y.right,axis.text.theta,axis.text.r`

  :   tick labels along axes
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html)).
      Specify all axis tick labels (`axis.text`), tick labels by plane
      (using `axis.text.x` or `axis.text.y`), or individually for each
      axis (using `axis.text.x.bottom`, `axis.text.x.top`,
      `axis.text.y.left`, `axis.text.y.right`). `axis.text.*.*` inherits
      from `axis.text.*` which inherits from `axis.text`, which in turn
      inherits from `text`

  `axis.ticks,axis.ticks.x,axis.ticks.x.top,axis.ticks.x.bottom,axis.ticks.y,axis.ticks.y.left,axis.ticks.y.right,axis.ticks.theta,axis.ticks.r`

  :   tick marks along axes
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html)).
      Specify all tick marks (`axis.ticks`), ticks by plane (using
      `axis.ticks.x` or `axis.ticks.y`), or individually for each axis
      (using `axis.ticks.x.bottom`, `axis.ticks.x.top`,
      `axis.ticks.y.left`, `axis.ticks.y.right`). `axis.ticks.*.*`
      inherits from `axis.ticks.*` which inherits from `axis.ticks`,
      which in turn inherits from `line`

  `axis.minor.ticks.x.top,axis.minor.ticks.x.bottom,axis.minor.ticks.y.left,axis.minor.ticks.y.right,axis.minor.ticks.theta,axis.minor.ticks.r`

  :   minor tick marks along axes
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html)).
      `axis.minor.ticks.*.*` inherit from the corresponding major ticks
      `axis.ticks.*.*`.

  `axis.ticks.length,axis.ticks.length.x,axis.ticks.length.x.top,axis.ticks.length.x.bottom,axis.ticks.length.y,axis.ticks.length.y.left,axis.ticks.length.y.right,axis.ticks.length.theta,axis.ticks.length.r`

  :   length of tick marks (`unit`). `axis.ticks.length` inherits from
      `spacing`.

  `axis.minor.ticks.length,axis.minor.ticks.length.x,axis.minor.ticks.length.x.top,axis.minor.ticks.length.x.bottom,axis.minor.ticks.length.y,axis.minor.ticks.length.y.left,axis.minor.ticks.length.y.right,axis.minor.ticks.length.theta,axis.minor.ticks.length.r`

  :   length of minor tick marks (`unit`), or relative to
      `axis.ticks.length` when provided with
      [`rel()`](https://ggplot2.tidyverse.org/reference/element.html).

  `axis.line,axis.line.x,axis.line.x.top,axis.line.x.bottom,axis.line.y,axis.line.y.left,axis.line.y.right,axis.line.theta,axis.line.r`

  :   lines along axes
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html)).
      Specify lines along all axes (`axis.line`), lines for each plane
      (using `axis.line.x` or `axis.line.y`), or individually for each
      axis (using `axis.line.x.bottom`, `axis.line.x.top`,
      `axis.line.y.left`, `axis.line.y.right`). `axis.line.*.*` inherits
      from `axis.line.*` which inherits from `axis.line`, which in turn
      inherits from `line`

  `legend.background`

  :   background of legend
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`)

  `legend.margin`

  :   the margin around each legend
      ([`margin()`](https://ggplot2.tidyverse.org/reference/element.html));
      inherits from `margins`.

  `legend.spacing,legend.spacing.x,legend.spacing.y`

  :   the spacing between legends (`unit`). `legend.spacing.x` &
      `legend.spacing.y` inherit from `legend.spacing` or can be
      specified separately. `legend.spacing` inherits from `spacing`.

  `legend.key`

  :   background underneath legend keys
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`)

  `legend.key.size,legend.key.height,legend.key.width`

  :   size of legend keys (`unit`); key background height & width
      inherit from `legend.key.size` or can be specified separately. In
      turn `legend.key.size` inherits from `spacing`.

  `legend.key.spacing,legend.key.spacing.x,legend.key.spacing.y`

  :   spacing between legend keys given as a `unit`. Spacing in the
      horizontal (x) and vertical (y) direction inherit from
      `legend.key.spacing` or can be specified separately.
      `legend.key.spacing` inherits from `spacing`.

  `legend.key.justification`

  :   Justification for positioning legend keys when more space is
      available than needed for display. The default, `NULL`, stretches
      keys into the available space. Can be a location like `"center"`
      or `"top"`, or a two-element numeric vector.

  `legend.frame`

  :   frame drawn around the bar
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html)).

  `legend.ticks`

  :   tick marks shown along bars or axes
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html))

  `legend.ticks.length`

  :   length of tick marks in legend
      ([`unit()`](https://rdrr.io/r/grid/unit.html)); inherits from
      `legend.key.size`.

  `legend.axis.line`

  :   lines along axes in legends
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html))

  `legend.text`

  :   legend item labels
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `text`)

  `legend.text.position`

  :   placement of legend text relative to legend keys or bars ("top",
      "right", "bottom" or "left"). The legend text placement might be
      incompatible with the legend's direction for some guides.

  `legend.title`

  :   title of legend
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `title`)

  `legend.title.position`

  :   placement of legend title relative to the main legend ("top",
      "right", "bottom" or "left").

  `legend.position`

  :   the default position of legends ("none", "left", "right",
      "bottom", "top", "inside")

  `legend.position.inside`

  :   A numeric vector of length two setting the placement of legends
      that have the `"inside"` position.

  `legend.direction`

  :   layout of items in legends ("horizontal" or "vertical")

  `legend.byrow`

  :   whether the legend-matrix is filled by columns (`FALSE`, the
      default) or by rows (`TRUE`).

  `legend.justification`

  :   anchor point for positioning legend inside plot ("center" or
      two-element numeric vector) or the justification according to the
      plot area when positioned outside the plot

  `legend.justification.top,legend.justification.bottom,legend.justification.left,legend.justification.right,legend.justification.inside`

  :   Same as `legend.justification` but specified per `legend.position`
      option.

  `legend.location`

  :   Relative placement of legends outside the plot as a string. Can be
      `"panel"` (default) to align legends to the panels or `"plot"` to
      align legends to the plot as a whole.

  `legend.box`

  :   arrangement of multiple legends ("horizontal" or "vertical")

  `legend.box.just`

  :   justification of each legend within the overall bounding box, when
      there are multiple legends ("top", "bottom", "left", "right",
      "center" or "centre")

  `legend.box.margin`

  :   margins around the full legend area, as specified using
      [`margin()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `margins`.

  `legend.box.background`

  :   background of legend area
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`)

  `legend.box.spacing`

  :   The spacing between the plotting area and the legend box (`unit`);
      inherits from `spacing`.

  `panel.background`

  :   background of plotting area, drawn underneath plot
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`)

  `panel.border`

  :   border around plotting area, drawn on top of plot so that it
      covers tick marks and grid lines. This should be used with
      `fill = NA`
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`)

  `panel.spacing,panel.spacing.x,panel.spacing.y`

  :   spacing between facet panels (`unit`). `panel.spacing.x` &
      `panel.spacing.y` inherit from `panel.spacing` or can be specified
      separately. `panel.spacing` inherits from `spacing`.

  `panel.grid,panel.grid.major,panel.grid.minor,panel.grid.major.x,panel.grid.major.y,panel.grid.minor.x,panel.grid.minor.y`

  :   grid lines
      ([`element_line()`](https://ggplot2.tidyverse.org/reference/element.html)).
      Specify major grid lines, or minor grid lines separately (using
      `panel.grid.major` or `panel.grid.minor`) or individually for each
      axis (using `panel.grid.major.x`, `panel.grid.minor.x`,
      `panel.grid.major.y`, `panel.grid.minor.y`). Y axis grid lines are
      horizontal and x axis grid lines are vertical. `panel.grid.*.*`
      inherits from `panel.grid.*` which inherits from `panel.grid`,
      which in turn inherits from `line`

  `panel.ontop`

  :   option to place the panel (background, gridlines) over the data
      layers (`logical`). Usually used with a transparent or blank
      `panel.background`.

  `panel.widths,panel.heights`

  :   Sizes for panels (`units`). Can be a single unit to set the total
      size for the panel area, or a unit vector to set the size of
      individual panels. Using this setting overrides the aspect ratio
      set by the theme, coord or facets. An exception is made when the
      plot has a single panel and exactly one of the width *or* height
      is set, in which case an attempt is made to preserve the aspect
      ratio.

  `plot.background`

  :   background of the entire plot
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`)

  `plot.title`

  :   plot title (text appearance)
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `title`) left-aligned by default

  `plot.title.position,plot.caption.position`

  :   Alignment of the plot title/subtitle and caption. The setting for
      `plot.title.position` applies to both the title and the subtitle.
      A value of "panel" (the default) means that titles and/or caption
      are aligned to the plot panels. A value of "plot" means that
      titles and/or caption are aligned to the entire plot (minus any
      space for margins and plot tag).

  `plot.subtitle`

  :   plot subtitle (text appearance)
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `title`) left-aligned by default

  `plot.caption`

  :   caption below the plot (text appearance)
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `title`) right-aligned by default

  `plot.tag`

  :   upper-left label to identify a plot (text appearance)
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `title`) left-aligned by default

  `plot.tag.position`

  :   The position of the tag as a string ("topleft", "top", "topright",
      "left", "right", "bottomleft", "bottom", "bottomright") or a
      coordinate. If a coordinate, can be a numeric vector of length 2
      to set the x,y-coordinate relative to the whole plot. The
      coordinate option is unavailable for
      `plot.tag.location = "margin"`.

  `plot.tag.location`

  :   The placement of the tag as a string, one of `"panel"`, `"plot"`
      or `"margin"`. Respectively, these will place the tag inside the
      panel space, anywhere in the plot as a whole, or in the margin
      around the panel space.

  `plot.margin`

  :   margin around entire plot (`unit` with the sizes of the top,
      right, bottom, and left margins); inherits from `margin`.

  `strip.background,strip.background.x,strip.background.y`

  :   background of facet labels
      ([`element_rect()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `rect`). Horizontal facet background
      (`strip.background.x`) & vertical facet background
      (`strip.background.y`) inherit from `strip.background` or can be
      specified separately

  `strip.clip`

  :   should strip background edges and strip labels be clipped to the
      extend of the strip background? Options are `"on"` to clip,
      `"off"` to disable clipping or `"inherit"` (default) to take the
      clipping setting from the parent viewport.

  `strip.placement`

  :   placement of strip with respect to axes, either "inside" or
      "outside". Only important when axes and strips are on the same
      side of the plot.

  `strip.text,strip.text.x,strip.text.y,strip.text.x.top,strip.text.x.bottom,strip.text.y.left,strip.text.y.right`

  :   facet labels
      ([`element_text()`](https://ggplot2.tidyverse.org/reference/element.html);
      inherits from `text`). Horizontal facet labels (`strip.text.x`) &
      vertical facet labels (`strip.text.y`) inherit from `strip.text`
      or can be specified separately. Facet strips have dedicated
      position-dependent theme elements (`strip.text.x.top`,
      `strip.text.x.bottom`, `strip.text.y.left`, `strip.text.y.right`)
      that inherit from `strip.text.x` and `strip.text.y`, respectively.
      As a consequence, some theme stylings need to be applied to the
      position-dependent elements rather than to the parent elements

  `strip.switch.pad.grid,strip.switch.pad.wrap`

  :   space between strips and axes when strips are switched (`unit`);
      inherits from `spacing`.

  `complete`

  :   set this to `TRUE` if this is a complete theme, such as the one
      returned by
      [`theme_grey()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).
      Complete themes behave differently when added to a ggplot object.
      Also, when setting `complete = TRUE` all elements will be set to
      inherit from blank elements.

  `validate`

  :   `TRUE` to run `check_element()`, `FALSE` to bypass checks.

## Value

un thème qui peut être utilisé dans ggplot

## See also

Other themes:
[`theme_foundation()`](https://ofce.github.io/ofce/reference/theme_foundation.md),
[`theme_ofce_void()`](https://ofce.github.io/ofce/reference/theme_ofce_void.md)
