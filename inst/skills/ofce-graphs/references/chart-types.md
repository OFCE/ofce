# Chart types — time series deep dive

Condensed from the OFCE vignette *Séries temporelles*
(https://ofce.github.io/ofce/articles/temporelles.html). French terms kept
where they are the convention.

## Table of contents

- [Data preparation](#data-preparation)
- [Base line chart](#base-line-chart)
- [Annotations](#annotations)
- [Aggregation to monthly/quarterly](#aggregation-to-monthlyquarterly)
- [Insets (zoom on recent period)](#insets-zoom-on-recent-period)
- [Quarterly axes](#quarterly-axes)
- [Data availability](#data-availability)

## Data preparation

- **Long format** for plotting: one row per (date, series), grouping columns
  as factors with explicit level order (France first, then others).
- Dates as `<date>`; for annual data: `as.Date(str_c(year, "-01-01"))`.
  Excel numeric dates: `as.Date(x, origin = "1899-12-30")`.
- Build the tooltip column at this stage, e.g. (`taux` here is in percentage
  points; `fmt_pct()` would multiply it by 100 — see the SKILL.md note)

```r
data <- data |>
  mutate(tooltip = str_c(
    "<b>", pays, "</b><br>",
    stamp(orders = "%B %Y", locale = "fr_FR.utf8", quiet = TRUE)(date),
    "<br>Ecart de taux : ", fmt_val(taux), "%"))
```

## Base line chart

```r
(ggplot(data) +
   aes(x = date, y = taux, fill = pays, color = pays, group = pays) +
   geom_line(linewidth = 0.75, alpha = 0.5, show.legend = FALSE) +
   geom_point_interactive(
     aes(tooltip = tooltip, data_id = str_c(pays, date)),
     stroke = 0.5, size = 1, col = "white", shape = 21,
     hover_nearest = TRUE, show.legend = FALSE) +
   scale_color_manual(aesthetics = c("fill", "color"),
                      name = NULL, values = cc) +
   theme_ofce() +
   scale_ofce_date() +
   guides(y = guide_axis(minor.ticks = TRUE)) +
   labs(y = "Ecart de taux à 10 ans", x = NULL) +
   scale_y_continuous(labels = ~ str_c(.x, "%"),
                      minor_breaks = scales::breaks_width(0.1)) +
   ofce_caption(source = "investing.com")) |>
  girafy(r = 2.5)
```

Notes: the plot is wrapped in parentheses before `girafy()` — `|>` binds
tighter than `+`, so `plot + caption |> girafy()` would pipe only the caption.
The legend is off here (`show.legend = FALSE`) because direct labels are
added in the [Annotations](#annotations) section; keep the legend (bottom)
otherwise.

## Annotations

- Basic: `annotate("text", x = as.Date(...), y = ..., label = ...)` plus
  `annotate("segment", arrow = arrow(...))` — verbose but fully controlled.
- Better: `{ggrepel}` — store events in a tibble, `left_join` them to the data
  (with `replace_na(label, "")`) and use `geom_text_repel(aes(label = ...),
  max.overlaps = Inf)`.
- Direct series labels (instead of a legend): `geom_text_repel` on the last
  points, or `annotate("text", color = cc[[i]], fontface = "bold")` —
  preferable for 2–3 series.

## Aggregation to monthly/quarterly

Daily series produce too many points. Force one date per period then
`summarise`:

```r
dates <- data$date
lubridate::day(dates) <- 15          # one date per month
data_m <- data |>
  mutate(date = dates) |>
  group_by(date, pays) |>
  summarize(taux = mean(taux, na.rm = TRUE), .groups = "drop")
```

Re-render the same plot with new data via `%+%`: `main %+% data_m`.

## Insets (zoom on recent period)

Build the inset = same plot, simplified and zoomed (smaller `base_size`,
`axis.line` blank, white background, short date scale
`scales::label_date_short(format = c("%Y", "%B"))`), then insert with
`{patchwork}`: `main + inset_element(inset, 0.75, 0.66, 1, 1)`.
Alternative: `{ggmagnify}` (`geom_magnify(from, to, plot = inset)`),
which also works with ggiraph.

## Quarterly axes

Discrete interaction of quarter and year, nested guide from `{legendry}`:

```r
data_q <- data |>
  mutate(y = year(date),
         q = str_c("T", quarter(date)),
         date_q = floor_date(date, "quarter")) |>
  group_by(date_q, y, q, pays) |> summarize(...) |>
  arrange(date_q)

ggplot(data_q) +
  aes(x = interaction(q, y), y = taux, fill = pays, color = pays) +
  geom_line(linewidth = 0.75, alpha = 0.5, show.legend = FALSE) +
  geom_point(stroke = 0.5, size = 1, col = "white", shape = 21) +
  scale_color_manual(aesthetics = c("fill","color"), name = NULL, values = cc) +
  theme_ofce(axis.text.x = element_text(size = rel(0.8))) +
  scale_y_continuous(labels = ~ str_c(.x, "%")) +
  guides(y = guide_axis(minor.ticks = TRUE),
         x = guide_axis_nested(type = "fence")) +
  theme_guide(text = element_marquee(size = rel(1.2)),
              ticks = element_line(),
              fence.post = element_line("grey"),
              bracket = element_blank())
```

## Data availability

- Add download buttons right after the figure (inline for same-row layout):

```r
downloadthis::download_this(
  data |> select(-tooltip),
  icon = "fa fa-download", class = "dbtn",
  button_label = "Taux mensuels", output_name = "taux_mensuels")
```

- Or in the margin: `::: column-margin` around the chunk. The `rinit.r` of
  recent projects defines `margin_download(data)` for the margin variant.
- Publish the code on a public GitHub repo; reference it in the caption
  (`code = "github.com/org/repo"`).
