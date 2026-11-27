# Worked examples from recent OFCE working papers

Two real chunks, lightly trimmed, from `wp-xt-travail` (2026) and
`wp-xt-adjust` (2026). They show the target workflow: `sourcoise` data with
provenance → tooltips in the data → ggiraph → `ofce_caption()` →
`tabsetize()` / patchwork → data download button.

## Table of contents

- [Example 1 — faceted country panel, tabsetized (wp-xt-travail)](#example-1--faceted-country-panel-tabsetized-wp-xt-travail)
- [Example 2 — multi-panel patchwork with transparent hover overlay (wp-xt-adjust)](#example-2--multi-panel-patchwork-with-transparent-hover-overlay-wp-xt-adjust)

## Example 1 — faceted country panel, tabsetized (wp-xt-travail)

Context: wage share series from Eurostat, data built by `R/vaq.r`, document
init by `ofce::init_qmd()` (theme and fonts already global). One figure per
field ("champ"), presented as tabs.

```r
# data + provenance date, tooltips built in the data frame
date <- sourcoise::sourcoise_meta("R/vaq.r")$data_date |> ymd_hms()
date <- stringr::str_glue("{day(date)}/{month(date)}/{year(date)}")

naq <- naq |>
  mutate(tooltip = str_c(
    "<b>{lbl(geo)}</b> {year(time)} {champs[champ]}",
    "Part des salaires dans la VAN : {round(psalh*100,1)}%")) |>
  mutate(geo = factor(geo, P6))

# one figure per field
psal <- imap(
  c("Marchand" = "md", "Hors immo. (-L)" = "mdhi",
    "Hors immo. ménages (-Lm)" = "mdhim"),
  ~ggplot(naq |> filter(champ == .x)) +
    aes(x = time, y = psalh, col = geo, group = geo) +
    geom_line(color = "grey80", linewidth = 0.2) +   # other series in grey
    geom_line(linewidth = 0.5) +
    geom_point_interactive(
      aes(tooltip = tooltip, data_id = time, fill = geo),
      size = 1, stroke = 0.5, shape = 21, color = "white",
      hover_nearest = TRUE, show.legend = FALSE) +
    ylab("% de la VA") + xlab(NULL) +
    facet_wrap(vars(geo), ncol = 3, labeller = lbl) +
    scale_ofce_date(labels = date1) +
    scale_y_continuous(labels = scales::label_percent(1),
                       breaks = scales::pretty_breaks(5),
                       limits = c(.65, .95)) +
    scale_color_pays(format = "eurostat") +
    ofce_caption(
      source = "Eurostat, comptes nationaux (nama_10_a64…), téléchargés le
        {date}, code à github.com/xtimbeau/travail/R/vaq.r.",
      champ = "{champs[.x]}, correction par le revenu mixte hybride.",
      note = "Part des salaires corrigés… Les traits fins gris rappellent
        les autres pays."))
```

The chunk holding the figures ends with (chunk option `results: asis`):

```r
tabsetize(psal, active = 2, r = 1.5)
```

followed, in its own chunk, by the data download button:

```r
#| results: asis
margin_download(naq |> select(-tooltip))
```

Points to note: the download date from `sourcoise_meta()` goes into the
caption source; the GitHub path goes in too; faceting keeps one interactive
layer for all panels; `scale_color_pays(format = "eurostat")` applies the
country charte from Eurostat codes.

## Example 2 — multi-panel patchwork with transparent hover overlay (wp-xt-adjust)

Context: quarterly debt dynamics, four panels (a)–(d) stacked with shared
x-axis, one caption for the whole figure. Transparent interactive points let
the user hover anywhere near the line.

```r
#| label: fig-dette
#| fig-cap: La dette et sa dynamique de 2007 à 2026
#| fig-asp: 1.2

gec <- ggplot(dette_trim) +
  aes(x = time) +
  geom_hline(yintercept = 0, linewidth = 0.25, color = "grey75") +
  geom_col(aes(y = ec*dm/(1+g), fill = ecp), alpha = 0.25,
           width = 1, show.legend = FALSE) +
  geom_step(aes(y = ec*dm/(1+g), group = 1),
            direction = "mid", linewidth = 0.25) +
  geom_point_interactive(
    aes(y = ec*dm/(1+g), tooltip = tta),
    size = 1, col = "transparent", hover_nearest = TRUE) +
  labs(y = "% par an", x = NULL,
       subtitle = "(a) d × (r-g)/(1+g) (effet boule de neige)") +
  scale_fill_manual(values = c("p" = "red", "n" = "green")) +
  sx +   # a shared scale_ofce_date() list built once, reused by all panels
  scale_y_continuous(labels = label_percent(1),
                     limits = c(-0.11, 0.06), oob = scales::squish) +
  guides(x = guide_axis(minor.ticks = TRUE))

# ... panels gecapp, gssp, gdm built the same way ...

gfinal <- gec/gecapp/gssp/gdm +          # patchwork: panels stacked
  plot_layout(axes = "collect_x") &
  theme(plot.margin = margin(0),
        axis.text.x = element_text(size = rel(0.75), hjust = 0),
        plot.subtitle = munch::element_md(size = rel(0.75)),
        plot.background = element_rect(fill = "transparent"))

gd <- gfinal +
  ofce_caption(
    source = "INSEE, Banque de France",
    lecture = "Le panneau (b) indique la contribution de l'écart critique
      à la dynamique de la dette…")
```

Points to note: `fig-asp: 1.2` for a tall stacked composition; a single
caption on the assembled patchwork, then `girafy(gd)` as the chunk's last
expression; interactive points with `col = "transparent"` sit on top
of steps/bars so hovering targets the nearest data point; panel subtitles
"(a) … (d) …" are referenced in the caption `lecture`; only `rel()` sizes
inside the theme override.
