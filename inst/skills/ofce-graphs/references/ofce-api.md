# ofce package — graph function reference

Signatures condensed from the package source (R >= 4.2). Full doc:
`?ofce::theme_ofce` or https://ofce.github.io/ofce/reference/.

## Table of contents

- [Theme](#theme)
- [Caption](#caption)
- [Palettes and color scales](#palettes-and-color-scales)
- [Date scales](#date-scales)
- [French formatting](#french-formatting)
- [Interactivity](#interactivity)
- [Export](#export)

## Theme

```r
theme_ofce(base_size = getOption("ofce.base_size"),
           base_family = getOption("ofce.base_family"),
           marquee = getOption("ofce.marquee"), ...)
theme_ofce_void(...)   # minimal theme for maps
add_logo(plot, logo = NULL, size = 0.25)  # OFCE logo bottom-right
```

- Global options drive everything: `ofce.base_size` (12), `ofce.base_family`
  ("Open Sans"), `ofce.marquee` (markdown text rendering), `ofce.background_color`
  ("transparent"). `theme_ofce(...)` accepts any `theme()` argument, e.g.
  `legend.position = "bottom"`.
- Typical setup in a project `rinit.r`:
  `ggplot2::set_theme(ofce::theme_ofce())` — then chunks need no theme call.

## Caption

```r
ofce_caption(source = "", note = "", lecture = "", champ = "", code = "",
             dpt = "", xlab = "", ylab = "", subtitle = "", title = "",
             dptf = "month", lang = getOption("ofce.caption.lang"), ...)
```

- Method dispatch: works on ggplots (returns a list of `labs()`, add with `+`)
  and on `gt` tables.
- Glue-interpolated: `source = "Eurostat, téléchargé le {date}"` picks up
  `date` from the calling frame. Markdown allowed (`*emph*`, `<br>`,
  `^sup^`, `~sub~`).
- `dpt` = dates of the series (a vector; the latest is displayed via
  `dernier_point(date, freq = "month"|"quarter"|"year", lang = "fr")`, which
  formats "dernier point connu" without depending on the OS locale).
- Related options: `ofce.caption.ofce` (append "calculs OFCE" to source),
  `ofce.caption.author`, `ofce.caption.wrap` (character wrap width, 0 with
  marquee).

## Palettes and color scales

```r
ofce_palette(n = 2)   # main charte palette; n <= 2 returns the blue/red pair
                      # "#185CA1"/"#D40F14" (2 colors even for n = 1)
ofce_palette_seq(colors = c("#005DA4", "#C51315"), ...)  # sequential (colorspace)
ofce_palette_div(colors = c("#005DA4", "#C51315"), ...)  # diverging
scale_color_pays(format = "iso3", lang = "fr", name = NULL,
                 aesthetics = c("color", "fill"), ...)
```

- `scale_color_pays()`: country codes column (ISO 3166-1 alpha-3, Eurostat or
  any format `countrycode::countrycode` accepts, e.g. `"fr"` for clear names);
  maps the charte color codes, `"OTH"` = light grey; partial `values =`
  override merges with the standard palette; `name = NULL` drops the legend
  title.

## Date scales

```r
scale_ofce_date(date_breaks = "5 years", date_minor_breaks = "1 year",
                date_labels = "%Y", labels = NULL,
                guide = "minor_breaks", name = NULL, ...)
```

Returns a list (x date scale + hjust tweak + minor-ticks guide) — add it to
the plot with `+`. Pass custom label functions via `labels =` (e.g.
`scales::label_date_short(format = c("%Y", "%B"))`).

## French formatting

```r
fmt_val(x, digits = 1, scale = 1, suffix = "", plus = FALSE)  # 1234.5 -> "1 234,5"
fmt_pct(x, digits = 0, plus = FALSE)  # x is a FRACTION: 0.12 -> "12%" (no space)
fmt_mds(x)                           # milliards d'euros
```

## Interactivity

```r
girafy(plot, r = 1.5, o = 0.5, s = -1, id = NULL,
       pointsize = 12, width_svg = NULL, height_svg = NULL,
       biratio = NULL, png_dpi = 700, ...)
tabsetize(list, cap = TRUE, girafy = TRUE, asp = NULL,
          r = 1.5, o = 0.5, s = -1, pdf = "all", active = 1)
```

- `girafy()` wraps a ggplot (with `geom_*_interactive()` layers) into a
  `{ggiraph}` widget; returns the plain plot in non-HTML output. It also
  saves the graph (for reuse in presentations) and a thumbnail. `r` = hover
  circle radius in px (>= 0 to enable), `o` = inverse opacity, `biratio =
  c(0.6, 1.333)` serves desktop/mobile variants, `png_dpi` upgrades the
  toolbar PNG export with embedded OFCE fonts.
- Call it as the chunk's last expression: `girafy(plot, r = 1.5)` — not
  `plot + layer |> girafy()`: the pipe `|>` binds tighter than `+`, so only
  the last layer would be piped. Wrap the plot in parentheses if you pipe.
- `tabsetize()` prints a Quarto tabset (one tab per named plot) — chunk must
  have `#| results: asis`. In PDF everything is shown flat.
- Data access + provenance for captions:
  `source_data("data/script.r")` (alias `sourcoise::sourcoise()`),
  `sourcoise::sourcoise_meta("data/script.r")$data_date` (download date,
  POSIXct — format before use, see the caption idiom in SKILL.md).

## Export

```r
graph2png(graph, file = "", rep = "svg", ratio = 4/3, width = 18,
          units = "cm", bg = "white", dpi = 600, ...)
graph2svg(...)   # same signature; also graph2pptx(), graph2jpg()
```

For standalone files (presentations, external use) — not needed inside a
Quarto document, where chunk options and `fig-asp` control sizing.
