---
name: blog-data-scripts
description: Structures data code for OFCE Quarto posts (blog, working papers, forecasts). Moves every data download or API call (Insee, DBnomics, Eurostat, IMF, FRED...) out of .qmd chunks into a separate data script, called from the .qmd with ofce::source_data() (alias of sourcoise::sourcoise) so results are cached on disk and committed. Use when creating or editing a post, when adding or refactoring data downloads, when a render fails on data fetching, or when migrating legacy posts to the convention.
metadata:
  author: OFCE
  version: "1.0"
---

# OFCE data scripts (`source_data`)

## The rule

Every data download (API call, web fetch) for a Quarto document lives in a
separate R script, never in a `.qmd` chunk. The `.qmd` calls the script through
`source_data()`, which caches the result on disk.

Why: if the API fails, `source_data()` does **not** break the render — it falls
back to the last successful cached run, so published documents stay
re-renderable. Renders are fast (cache replay, ~ms), the cache is committed so
CI and co-authors reuse it, and data code is decoupled from figures.

## Workflow

1. Create the data script next to the `.qmd` — in the OFCE webblog:
   `posts/<post>/data/<name>.r` (lowercase, short name, one dataset per
   script); in other projects, a `data/` (or topic) folder beside the document.
   Move the download code from the `.qmd` chunk into it.
2. The script must end with `return()` — that object is what gets cached.
   Several objects → `return(list(a = ..., b = ...))`.
3. Replace the code in the `.qmd` chunk with:
   ```r
   data <- source_data("data/<name>.r")
   # or, for a list:
   d <- source_data("data/<name>.r")
   data <- d$a
   ```
4. Render the document to verify (fresh process), then commit the `data/`
   folder **including the `data/.sourcoise/` cache** (`.qs2` + `.json` files).
5. For a published/historical document, consider pinning the period in the
   script (e.g. `filter(year(DATE) <= 2023)`) so revisions at the source don't
   alter the published charts without the text being updated.

## Script conventions

- Paths inside the script are **relative to the script's folder** — it runs with
  its own working directory, not the `.qmd`'s.
- Load packages with `library()` at the top. Only use `ofce::init_qmd()` in the
  script if the `.qmd` itself calls it (recent posts); for legacy documents
  that don't, `init_qmd()` would reset the knitr options of the running render —
  use `library()` instead.
- Scripts can call each other: `nace <- source_data("nace.r")$nace` — factor
  common sources into shared scripts.
- Figures, theming (`theme_ofce()`, `ofce_caption()`), interactivity
  (`girafy()`) stay in the `.qmd`. Only data in scripts.
- `lapse`: omit it (default: run once, never re-execute while the script is
  unchanged) for historical/frozen data; use `lapse = "day"` or `"2 hours"`
  for conjoncture series that must track the source.
- Local input files (xlsx/csv) read by a script → pass them via
  `track = list("file.xlsx")` so modifications invalidate the cache.

## Insee pitfall

`insee::get_idbank_list()` downloads metadata for **all** BDM datasets and is
fragile: an Insee API change can make it crash any fresh process (Nov 2026 case:
combined with an insee 1.1.7 bug it broke CI renders; see the worked example in
[references/examples.md](references/examples.md)). In data scripts:

- Prefer the direct idbank when the series is known:
  `insee::get_insee_idbank("010777608")` — idbanks are stable identifiers and
  the `source_data()` cache protects the document if the API changes again.
- Reserve `get_idbank_list()` for interactive exploration, never in a render.

## Details

- Full argument reference, cache management and options: [references/source-data-reference.md](references/source-data-reference.md)
- Worked examples (legacy post migration, nested scripts): [references/examples.md](references/examples.md)
- The OFCE webblog repository ships a human-facing version of these rules
  (`GUIDELINES.md`, French). If this skill and that file diverge, update both.
