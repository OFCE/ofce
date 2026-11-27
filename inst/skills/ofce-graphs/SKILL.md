---
name: ofce-graphs
description: Builds OFCE/IFE-compliant ggplot2 figures for Quarto documents (working papers, policy briefs, blog posts, EcoGraph, forecasts). Applies theme_ofce(), ofce_caption() source/note/lecture captions, OFCE country palettes via scale_color_pays(), date axes via scale_ofce_date(), ggiraph interactivity via geom_*_interactive() + girafy()/tabsetize(), and sourcoise/source_data data provenance. Use when creating, editing, translating or reviewing any chart, graph, figure or plot for an OFCE or IFE publication.
metadata:
  author: OFCE
  version: "1.1"
---

# OFCE graphs

## Context

- Figures are `{ggplot2}` plots inside Quarto (`.qmd`) chunks of OFCE/IFE
  publications. `plotly`/base-R/Excel paste-ins are discouraged (harder to
  harmonize, no single source).
- The project's `rinit.r` (sourced by `ofce::init_qmd()`) already sets
  `ggplot2::set_theme(ofce::theme_ofce())`, registers Open Sans, and sets knitr
  chunk defaults (`ragg_png`, transparent background, `out.width="100%"`). So a
  bare `ggplot()` chunk is themed. In a standalone `.qmd` without a project
  `rinit.r`, call `ofce::init_qmd()` in a setup chunk (`#| include: false`): it
  sources the package default `rinit.r` (fonts, global theme, knitr defaults)
  and attaches `tidyverse`, `glue`, `ggiraph`, `gt` and `PrettyCols` — no extra
  `library()` calls needed. If you skip it, add `+ theme_ofce()` to every plot.
- Data comes from `source_data()` / `sourcoise::sourcoise()`: data downloads
  live in separate scripts that end with `return()`, never in a figure chunk.
  The `blog-data-scripts` skill — installed with this one by
  `ofce::install_assistant_skills()` — details the convention.
- Project `rinit.r` files may define extra helpers (`margin_download()`,
  `date1()`, …). Those are **project-specific** — check they exist before
  using them; don't assume the package default provides them.
- Human-facing documentation (French): https://ofce.github.io/ofce/
  (articles *Faire un graphique*, *Séries temporelles*, *Charte graphique*,
  *Le langage des graphiques*).

## Golden rules (from the OFCE chart charter)

1. `theme_ofce()` — never hardcode fonts/sizes in a chunk.
2. Dates are real `<date>` objects (lubridate), **even for annual series**.
3. Date x-axis via `scale_ofce_date()` (5-year major breaks, 1-year minor
   ticks by default); or `scale_x_date(date_breaks=, date_minor_breaks=,
   guide = "minor_ticks")`.
4. If y is in %, put "%" in the y labels (`labels = ~ str_c(.x, "%")`).
5. `geom_line(linewidth = 0.5–1)` plus `geom_point(shape = 21, col = "white",
   stroke = 0.25–0.5)` to mark actual data points. Prefer direct labels over
   a legend when possible; else legend at the bottom.

## Chunk options

````
```{r}
#| label: fig-tauxapp
#| fig-cap: Taux apparent de taxation sur le patrimoine des ménages
#| fig-asp: 0.61
````

- `fig-asp` sets the height/width ratio: `0.61` default (golden ratio),
  `1` for square (maps, stacked panels), `1.4` for a full A4 page.
- **Never `fig-width`/`fig-height`**: fixed sizes render microscopic text.
- **No title inside the plot**: the `fig-cap` is the title (cross-referenced
  as `@fig-tauxapp` in the text).
- Label/data/file names: short, lowercase, no accents, no spaces
  (`fig-pib_par_tete`, never `graphique 1a5`); paths always relative.

## Figure skeleton

Build in this order: data (long format) → geoms → theme → scales → caption.
Last expression makes the figure interactive in HTML and static in PDF.

```r
cc <- ofce_palette(2)   # or PrettyCols::prettycols("Summer", n = 2)

(ggplot(data) +
   aes(x = date, y = value, group = serie, col = serie, fill = serie) +
   geom_line(linewidth = 0.75, alpha = 0.5) +
   geom_point_interactive(
     aes(tooltip = tooltip, data_id = str_c(serie, date)),
     shape = 21, size = 1, stroke = 0.5, col = "white",
     hover_nearest = TRUE, show.legend = FALSE) +
   theme_ofce(legend.position = "bottom") +
   scale_color_manual(aesthetics = c("color", "fill"), name = NULL, values = cc) +
   scale_ofce_date() +
   scale_y_continuous(labels = ~ str_c(.x, "%")) +
   ofce_caption(
     source = "Insee, téléchargé le {date}, code à github.com/org/repo",
     lecture = "…", note = "…", champ = "…")) |>
  girafy(r = 1.5)
```

- The parentheses around the plot are **required**: `|>` binds tighter than
  `+`, so without them `girafy()` would receive only the caption, not the plot.
- `data_id` must identify a point **uniquely** — `serie` + `date`. A bare
  `data_id = date` makes all series highlight together on hover.
- Direct labels instead of the bottom legend: hide the legend
  (`show.legend = FALSE` on every layer) and label the series with
  `annotate("text", ...)` or `{ggrepel}` (see the chart-types reference).

## Colors

- Country charts: a column of country codes (ISO 3166-1 alpha-3 or Eurostat)
  and `scale_color_pays(format = "iso3"|"eurostat", lang = "fr")` — applies
  the charte color codes ("OTH" = light grey for "autres"). Any format
  `countrycode::countrycode` accepts works (`"fr"`, `"iso2"`...).
- OFCE palettes: `ofce_palette(n)` (main — `n <= 2` returns the blue/red
  pair `#185CA1`/`#D40F14`, two colors even for `n = 1`; single series:
  `ofce_palette(2)[1]`), `ofce_palette_seq()` (sequential),
  `ofce_palette_div()` (diverging, blue `#005DA4` / red `#C51315`).
- Recent documents also use `PrettyCols::prettycols("Summer"/"Joyful", n=)`.
  Pick one palette per document and keep colors meaningful (same country,
  same color everywhere).
- When both `col` and `fill` are mapped, use a single
  `scale_color_manual(aesthetics = c("color", "fill"), name = NULL)`.

## Caption (mandatory on every figure)

`ofce_caption(source, note, lecture, champ, code, dpt)` — added with `+`.
All texts are glue-interpolated (variables in scope can be referenced),
markdown is allowed. Labels "Source :", "Note :", "Lecture :" are added
automatically — don't repeat them. Good practice:

- give the download date — `$data_date` is POSIXct, format it first:

```r
date <- sourcoise::sourcoise_meta("R/script.r")$data_date |> ymd_hms()
date <- stringr::str_glue("{day(date)}/{month(date)}/{year(date)}")
```

- `dpt` = last known data point (formatted by `dernier_point()`,
  frequency via `dptf = "month"|"quarter"|"year"`);
- `code = "github.com/org/repo"` links the replication code;
- `xlab(NULL)`; y label explicit with units.

## Interactivity (HTML output; static fallback is automatic)

- Build the tooltip text **in the data frame**, French formatted:
  `str_c("<b>", pays, "</b><br>", fmt_val(taux), "%")`. Careful:
  `fmt_pct()` takes a **fraction** (`fmt_pct(0.12)` → `"12%"`), while axis
  label helpers use raw percentage values — don't mix them up.
- `geom_*_interactive(aes(tooltip = , data_id = ))`; `data_id` must be unique
  per point (series + date). A common trick is a
  transparent `geom_point_interactive(col = "transparent", hover_nearest = TRUE)`
  overlay so hovering works along the whole line.
- End the chunk with `girafy(plot, r = 1.5)` (hover radius, inverse opacity,
  OFCE-styled tooltips, fonts embedded, PNG export at high dpi). `r = -1`
  disables the hover circle.
- Alternative panels: `tabsetize(list_of_plots, active = 1)` inside a
  `#| results: asis` chunk (tabset in HTML, flat list in PDF); `{patchwork}`
  compositions (`plot_layout(axes = "collect_x")`) keep tooltips and take a
  single caption.

## French everywhere (unless the format is `wp-en-*`)

- Axis labels, captions, tooltips, facet labels: French.
- Numbers via `fmt_val()` (space thousands, comma decimals), `fmt_pct()`
  (input is a fraction), `fmt_mds()` (milliards d'euros); recent docs replace
  the hyphen with the minus sign U+2212.
- Dates in French via lubridate `stamp(..., locale=)`; the `date1()` shortcut
  is defined in some project `rinit.r` files, not in the package default.
- Charts for maps/minimal layouts: `theme_ofce_void()`.

## Pitfalls

- **No dual y-axis. Never.**
- Don't set absolute text sizes in chunks or themes (use `rel()`).
- Excel numeric dates: `as.Date(x, origin = "1899-12-30")`.
- Log scale is fine (`scale_y_log10(labels = ...)`) but say it in the note.
- Daily series get cluttered: aggregate to month/quarter first.
- Standalone export (presentations, not `.qmd`): `graph2png()` /
  `graph2svg()` (18 cm wide, 4:3, 600 dpi, OFCE fonts).
- If the render fails on missing Quarto extensions (OFCE formats), run
  `ofce::setup_quarto()` in the project folder. Plain `format: html` needs
  no extension.
- **A chunk error does not fail `quarto render`**: it exits 0 with the error
  embedded in the HTML and unresolved cross-references (`?@fig-...`). After
  rendering, grep the HTML for `?@fig-` and `Error` before trusting it.

## After the figure

- Offer the data: `downloadthis::download_this(data, ...)` right after the
  figure chunk, or in a `::: column-margin` div. Some project `rinit.r`
  files define `margin_download(data)` for the margin variant — check it
  exists before calling it.

## Learn more

- Time-series deep dive (aggregation, insets, quarterly axes, annotations):
  [references/chart-types.md](references/chart-types.md)
- Function reference (theme, caption, palettes, girafy, tabsetize, export):
  [references/ofce-api.md](references/ofce-api.md)
- Worked examples from recent working papers (sourcoise + ggiraph +
  tabsetize, patchwork multi-panel):
  [references/example-fig-workflow.md](references/example-fig-workflow.md)
